import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// Mode hapus saat user menekan backspace di sebuah box.
enum PinDeleteMode {
  /// Hapus isi box aktif saja. Box sesudahnya tidak bergeser.
  ///
  /// Sebelum : [1] [2] [3*] [4] [5] [6]
  /// Sesudah : [1] [2] [ *] [4] [5] [6]
  currentOnly,

  /// Hapus isi box aktif, lalu semua box sesudahnya ikut terhapus.
  ///
  /// Sebelum : [1] [2] [3*] [4] [5] [6]
  /// Sesudah : [1] [2] [ *] [ ] [ ] [ ]
  currentAndAfter,

  /// Hapus isi box aktif, lalu geser semua digit sesudahnya ke kiri satu posisi.
  /// Box terakhir menjadi kosong.
  ///
  /// Sebelum : [1] [2] [3*] [4] [5] [6]
  /// Sesudah : [1] [2] [4*] [5] [6] [ ]
  shiftLeft,
}

class AppPinField extends StatefulWidget {
  const AppPinField({
    super.key,
    required this.controller,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.boxSize = 52,
    this.focusedBorderColor,
    this.unfocusedBorderColor,
    this.errorBorderColor,
    this.backgroundColor,
    this.textStyle,
    this.errorText,
    this.borderRadius = 10,
    this.deleteMode = PinDeleteMode.shiftLeft,
  });

  final TextEditingController controller;

  /// Jumlah digit pin.
  final int length;

  final ValueChanged<String>? onChanged;

  /// Dipanggil saat semua digit sudah terisi.
  final ValueChanged<String>? onCompleted;

  final bool enabled;
  final bool autofocus;
  final bool readOnly;

  final double boxSize;
  final double borderRadius;

  final Color? focusedBorderColor;
  final Color? unfocusedBorderColor;
  final Color? errorBorderColor;
  final Color? backgroundColor;

  final TextStyle? textStyle;

  final String? errorText;

  /// Mode hapus saat user menekan backspace. Lihat [PinDeleteMode].
  final PinDeleteMode deleteMode;

  @override
  State<AppPinField> createState() => _AppPinFieldState();
}

class _AppPinFieldState extends State<AppPinField> {
  late final FocusNode _focusNode;

  /// Posisi kursor (index box yang aktif / highlighted).
  int _cursorIndex = 0;

  /// Representasi internal pin sebagai list karakter.
  /// Slot kosong = '' (string kosong).
  /// Panjang list selalu == widget.length.
  late List<String> _chars;

  /// Guard agar listener tidak rekursif.
  bool _isUpdating = false;

  // ─── Init / dispose ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _chars = List.filled(widget.length, '');
    _applyInitialValue(widget.controller.text);
    _focusNode = FocusNode()..addListener(_onFocusChange);
    widget.controller.addListener(_onControllerChanged);
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();

    // Hot reload: lepas & pasang ulang listener controller agar tidak stale.
    widget.controller.removeListener(_onControllerChanged);
    widget.controller.addListener(_onControllerChanged);

    // Reset flag guard agar tidak stuck karena reload di tengah update.
    _isUpdating = false;

    // Cycle focus agar EditableText yang di-rebuild mau menerima input lagi.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final hadFocus = _focusNode.hasFocus;
      _focusNode.unfocus();
      if (hadFocus) {
        Future.microtask(() {
          if (mounted) _focusNode.requestFocus();
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  // ─── Internal helpers ────────────────────────────────────────────────────────

  void _applyInitialValue(String raw) {
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    for (var i = 0; i < widget.length; i++) {
      _chars[i] = i < digits.length ? digits[i] : '';
    }
    _cursorIndex = _firstEmptyIndex ?? widget.length - 1;
  }

  /// Index slot kosong pertama, atau null jika semua terisi.
  int? get _firstEmptyIndex {
    for (var i = 0; i < _chars.length; i++) {
      if (_chars[i].isEmpty) return i;
    }
    return null;
  }

  /// Jumlah slot yang sudah terisi.
  int get _filledCount => _chars.where((c) => c.isNotEmpty).length;

  /// Pin sebagai string murni digit yang terisi (tanpa slot kosong).
  String get _pinValue => _chars.where((c) => c.isNotEmpty).join();

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  // ─── Controller listener ─────────────────────────────────────────────────────

  void _onControllerChanged() {
    if (_isUpdating) return;
    _isUpdating = true;

    try {
      final raw = widget.controller.text;
      final incoming = raw.replaceAll(RegExp(r'[^0-9]'), '');

      if (incoming.length > _filledCount) {
        // INSERT: ambil digit terakhir dari incoming.
        final newChar = incoming[incoming.length - 1];
        _handleInsert(newChar);
      } else if (incoming.length < _filledCount) {
        // DELETE
        _handleDelete();
      }
      // else: panjang sama → tidak ada aksi nyata.

      _syncController();

      final pin = _pinValue;
      widget.onChanged?.call(pin);

      if (_filledCount == widget.length) {
        widget.onCompleted?.call(pin);
      }

      if (mounted) setState(() {});
    } finally {
      _isUpdating = false;
    }
  }

  // ─── Insert ──────────────────────────────────────────────────────────────────

  /// Tulis [char] ke slot [_cursorIndex] (replace jika sudah ada isi),
  /// lalu geser kursor ke kanan satu posisi.
  void _handleInsert(String char) {
    if (_cursorIndex >= widget.length) return;
    _chars[_cursorIndex] = char;
    if (_cursorIndex < widget.length - 1) {
      _cursorIndex++;
    }
  }

  // ─── Delete ──────────────────────────────────────────────────────────────────

  void _handleDelete() {
    var idx = _cursorIndex;

    if (idx < 0 || idx >= widget.length) return;

    if (_chars[idx].isNotEmpty) {
      // Slot aktif berisi digit → hapus sesuai mode.
      _deleteAt(idx);
      // Kursor tetap di posisi yang sama setelah hapus.
    } else {
      // Slot aktif sudah kosong → mundur lalu hapus slot sebelumnya.
      if (idx > 0) {
        idx--;
        _cursorIndex = idx;
        _deleteAt(idx);
      }
      // Jika sudah di index 0 dan kosong, tidak ada yang bisa dihapus.
    }
  }

  void _deleteAt(int idx) {
    switch (widget.deleteMode) {
      case PinDeleteMode.currentOnly:
        // Hapus slot ini saja, slot lain tidak berubah.
        //
        // [1][2][3*][4][5][6] → [1][2][ *][4][5][6]
        _chars[idx] = '';
        break;

      case PinDeleteMode.currentAndAfter:
        // Hapus slot ini dan semua sesudahnya.
        //
        // [1][2][3*][4][5][6] → [1][2][ *][ ][ ][ ]
        for (var i = idx; i < widget.length; i++) {
          _chars[i] = '';
        }
        break;

      case PinDeleteMode.shiftLeft:
        // Hapus slot ini, geser digit sesudahnya ke kiri, slot terakhir jadi kosong.
        //
        // [1][2][3*][4][5][6] → [1][2][4*][5][6][ ]
        for (var i = idx; i < widget.length - 1; i++) {
          _chars[i] = _chars[i + 1];
        }
        _chars[widget.length - 1] = '';
        // Kursor tetap di idx (sekarang berisi digit yang bergeser ke sini).
        break;
    }
  }

  // ─── Sync controller ─────────────────────────────────────────────────────────

  /// Simpan hanya digit yang terisi agar `_filledCount` akurat saat dibandingkan
  /// dengan panjang incoming di listener.
  void _syncController() {
    final value = _pinValue;
    if (widget.controller.text != value) {
      widget.controller.text = value;
    }
  }

  // ─── Box tap ─────────────────────────────────────────────────────────────────

  void _onBoxTap(int index) {
    // Izinkan tap ke slot manapun yang sudah terisi,
    // atau ke slot kosong pertama (tidak bisa melompati slot kosong).
    final maxAllowed = _firstEmptyIndex ?? widget.length - 1;
    _cursorIndex = index.clamp(0, maxAllowed);

    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else {
      setState(() {});
    }
  }

  // ─── UI helpers ──────────────────────────────────────────────────────────────

  bool get _hasError => widget.errorText != null;

  Border _buildBorder({required bool isFocused, required bool isActive}) {
    final Color color;

    if (_hasError) {
      color = widget.errorBorderColor ?? const Color(0xFFD32F2F);
    } else if (isFocused && isActive) {
      color = widget.focusedBorderColor ?? AppTheme.primary;
    } else {
      color = widget.unfocusedBorderColor ?? AppTheme.grey300;
    }

    return Border.all(width: 1.5, color: color);
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;

    return GestureDetector(
      // Tap area kosong di luar box → kursor ke slot kosong pertama.
      onTap: () => _onBoxTap(_firstEmptyIndex ?? widget.length - 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // ── Hidden keyboard trigger ───────────────────────────────────
              SizedBox(
                width: 1,
                height: 1,
                child: EditableText(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Color(0x00000000), fontSize: 1),
                  cursorColor: const Color(0x00000000),
                  backgroundCursorColor: const Color(0x00000000),
                  keyboardType: TextInputType.number,
                  autofocus: widget.autofocus,
                  readOnly: widget.readOnly || !widget.enabled,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              // ── Pin boxes ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(widget.length, (index) {
                  final char = _chars[index];
                  final isFilled = char.isNotEmpty;
                  final isActive = _cursorIndex == index;

                  return GestureDetector(
                    onTap: () => _onBoxTap(index),
                    child: Container(
                      width: widget.boxSize,
                      height: widget.boxSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? AppTheme.grey50,
                        border: _buildBorder(
                          isFocused: hasFocus,
                          isActive: isActive,
                        ),
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius,
                        ),
                      ),
                      child: isFilled
                          ? Text(
                              char,
                              style:
                                  widget.textStyle ??
                                  const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )
                          : (hasFocus && isActive
                                ? _Cursor(
                                    color:
                                        widget.focusedBorderColor ??
                                        AppTheme.primary,
                                  )
                                : const SizedBox.shrink()),
                    ),
                  );
                }),
              ),
            ],
          ),

          if (widget.errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.errorText!,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Blinking cursor ──────────────────────────────────────────────────────────

class _Cursor extends StatefulWidget {
  const _Cursor({required this.color});

  final Color color;

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 24,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

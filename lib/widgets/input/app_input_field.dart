import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.validator,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.autofocus = false,
    this.enabled = true,
    this.inputFormatters,
    this.maxLength,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final Widget? prefix;

  /// Suffix sepenuhnya manual — tidak ada default icon apapun.
  /// Untuk password toggle, pass widget sendiri dari luar.
  final Widget? suffix;

  final bool isPassword;
  final String? Function(String value)? validator;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool autofocus;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late final FocusNode _focusNode;
  bool _isInternalFocusNode = false;

  String? _internalError;

  bool get _hasText => widget.controller.text.isNotEmpty;

  String? get _error => widget.errorText ?? _internalError;

  int get _effectiveMaxLines {
    if (widget.isPassword) return 1;
    return widget.maxLines ?? 1;
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    }
    widget.controller.addListener(_handleChange);
    _focusNode.addListener(_handleFocus);
  }

  void _handleChange() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      if (error != _internalError) _internalError = error;
    }
    widget.onChanged?.call(widget.controller.text);
    setState(() {});
  }

  void _handleFocus() {
    if (!_focusNode.hasFocus && widget.validator != null) {
      _internalError = widget.validator!(widget.controller.text);
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleChange);
    _focusNode.removeListener(_handleFocus);
    if (_isInternalFocusNode) _focusNode.dispose();
    super.dispose();
  }

  List<TextInputFormatter> get _effectiveFormatters => [
    if (widget.maxLength != null)
      LengthLimitingTextInputFormatter(widget.maxLength),
    ...?widget.inputFormatters,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: 45),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.grey50,
            border: Border.all(color: AppTheme.grey300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            spacing: 8,
            crossAxisAlignment: widget.maxLines != 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.prefix != null) ...[
                Opacity(
                  opacity: widget.enabled ? 0.6 : 0.3,
                  child: widget.prefix!,
                ),
              ],
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    if (!_hasText && widget.hintText != null)
                      Text(
                        widget.hintText!,
                        style: GoogleFonts.inter(
                          color: AppTheme.grey400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    EditableText(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      obscureText: widget.isPassword,
                      readOnly: widget.readOnly || !widget.enabled,
                      autofocus: widget.autofocus,
                      keyboardType:
                          widget.keyboardType ??
                          (widget.maxLines != 1
                              ? TextInputType.multiline
                              : TextInputType.text),
                      textInputAction:
                          widget.textInputAction ??
                          (widget.maxLines != 1
                              ? TextInputAction.newline
                              : TextInputAction.done),
                      maxLines: _effectiveMaxLines,
                      minLines: widget.minLines,
                      textCapitalization: widget.textCapitalization,
                      textAlign: widget.textAlign,
                      autocorrect: widget.autocorrect,
                      enableSuggestions: widget.enableSuggestions,
                      inputFormatters: _effectiveFormatters,
                      onSubmitted: widget.onSubmitted,
                      style: GoogleFonts.inter(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      cursorColor: const Color(0xFF424242),
                      backgroundCursorColor: const Color(0xFFBDBDBD),
                      selectionColor: const Color(
                        0xFF424242,
                      ).withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),

              // Suffix murni manual — render apa adanya tanpa logika tambahan
              if (widget.suffix != null) ...[widget.suffix!],
            ],
          ),
        ),

        if (_error != null || widget.maxLength != null) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_error != null)
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const Spacer(),
              if (widget.maxLength != null)
                Text(
                  '${widget.controller.text.length}/${widget.maxLength}',
                  style: TextStyle(
                    color: widget.controller.text.length >= widget.maxLength!
                        ? const Color(0xFFD32F2F)
                        : const Color(0xFF9E9E9E),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

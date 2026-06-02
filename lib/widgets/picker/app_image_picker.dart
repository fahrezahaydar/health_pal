import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:iconsax_latest/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_text_theme.dart';
import '../../../core/theme/app_theme.dart';
import '../button/outline_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TYPES
// ─────────────────────────────────────────────────────────────────────────────

typedef OnPhotoSelected = void Function(File file);

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// Avatar + edit-badge tanpa Material / Cupertino.
/// Tap → custom bottom-sheet pilih Camera / Galeri / Hapus.
class AppPhotoPicker extends StatelessWidget {
  const AppPhotoPicker({
    super.key,
    this.localFile,
    this.remoteUrl,
    this.size = 96,
    this.onPhotoSelected,
    this.onPhotoRemoved,
  });

  /// Path lokal (persistent cache di device).
  final File? localFile;

  /// URL CDN — fallback jika [localFile] null.
  final String? remoteUrl;

  /// Diameter avatar dalam logical pixels.
  final double size;

  final OnPhotoSelected? onPhotoSelected;
  final VoidCallback? onPhotoRemoved;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _AvatarCircle(
              size: size,
              localFile: localFile,
              remoteUrl: remoteUrl,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: _EditBadge(size: size * 0.30),
            ),
          ],
        ),
      ),
    );
  }

  // ── sheet ──────────────────────────────────────────────────────────────────

  void _showSheet(BuildContext context) {
    final bool hasPhoto = localFile != null || (remoteUrl?.isNotEmpty == true);

    _AppBottomSheet.show(
      context,
      child: _PhotoOptionsSheet(
        hasPhoto: hasPhoto,
        onCamera: () async {
          Navigator.of(context).pop();
          await _pick(context, ImageSource.camera);
        },
        onGallery: () async {
          Navigator.of(context).pop();
          await _pick(context, ImageSource.gallery);
        },
        onRemove: hasPhoto
            ? () {
                Navigator.of(context).pop();
                onPhotoRemoved?.call();
              }
            : null,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final XFile? xFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (xFile == null) return;
    onPhotoSelected?.call(File(xFile.path));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AVATAR
// ─────────────────────────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.size, this.localFile, this.remoteUrl});

  final double size;
  final File? localFile;
  final String? remoteUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.square(dimension: size, child: _content()),
    );
  }

  Widget _content() {
    if (localFile != null) {
      return Image.file(
        localFile!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, __, ___) => _Placeholder(size: size),
      );
    }
    if (remoteUrl != null && remoteUrl!.isNotEmpty) {
      return Image.network(
        remoteUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _Shimmer(size: size),
        errorBuilder: (_, __, ___) => _Placeholder(size: size),
      );
    }
    return _Placeholder(size: size);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PLACEHOLDER
// ─────────────────────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: AppTheme.grey200.withValues(alpha: 0.4),
      alignment: Alignment.center,
      child: Transform.translate(
        offset: Offset(0, -(size * 0.2)), // geser ke atas ~6% dari size
        child: Icon(
          Iconsax.profileCircle,
          size: size * 1.4,
          color: AppTheme.grey200,
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER
// ─────────────────────────────────────────────────────────────────────────────

class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.size});
  final double size;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => ColoredBox(
        color: Color.lerp(AppTheme.grey200, AppTheme.grey300, _ctrl.value)!,
        child: SizedBox.square(dimension: widget.size),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EDIT BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _EditBadge extends StatelessWidget {
  const _EditBadge({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.white, width: 2),
      ),
      child: SizedBox.square(
        dimension: size,
        child: Center(
          child: Icon(
            Iconsax.editStyle4,
            size: size * 0.50,
            color: AppTheme.white,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SHEET — full custom route, tanpa showModalBottomSheet
// ─────────────────────────────────────────────────────────────────────────────

class _AppBottomSheet {
  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return Navigator.of(context).push<T>(_BottomSheetRoute<T>(child: child));
  }
}

/// PopupRoute kustom: overlay gelap + slide-up animasi.
class _BottomSheetRoute<T> extends PopupRoute<T> {
  _BottomSheetRoute({required this.child});
  final Widget child;

  @override
  Color get barrierColor => const Color(0x80000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Tutup';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PHOTO OPTIONS SHEET CONTENT
// ─────────────────────────────────────────────────────────────────────────────

class _PhotoOptionsSheet extends StatelessWidget {
  const _PhotoOptionsSheet({
    required this.hasPhoto,
    required this.onCamera,
    required this.onGallery,
    required this.onCancel,
    this.onRemove,
  });

  final bool hasPhoto;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onCancel;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.grey300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const SizedBox(width: 40, height: 4),
                  ),
                ),
                const SizedBox(height: 16),

                // title
                Text(
                  'Foto Profil',
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // options
                _SheetTile(
                  icon: Iconsax.cameraStyle4,
                  label: 'Kamera',
                  onTap: onCamera,
                ),
                _SheetDivider(),
                _SheetTile(
                  icon: Iconsax.galleryStyle4,
                  label: 'Pilih dari Galeri',
                  onTap: onGallery,
                ),
                if (hasPhoto && onRemove != null) ...[
                  _SheetDivider(),
                  _SheetTile(
                    icon: Iconsax.trashStyle4,
                    label: 'Hapus Foto',
                    iconColor: AppTheme.darkRed,
                    labelColor: AppTheme.darkRed,
                    onTap: onRemove!,
                  ),
                ],
                const SizedBox(height: 16),

                // cancel
                LightOutlineButton(onTap: onCancel, label: 'Cancel'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── tile ───────────────────────────────────────────────────────────────────

class _SheetTile extends StatefulWidget {
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  @override
  State<_SheetTile> createState() => _SheetTileState();
}

class _SheetTileState extends State<_SheetTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: _pressed ? 0.45 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 22,
                color: widget.iconColor ?? AppTheme.grey700,
              ),
              const SizedBox(width: 14),
              Text(
                widget.label,
                style: AppTextTheme.bodyMedium.copyWith(
                  color: widget.labelColor ?? AppTheme.grey900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── divider ────────────────────────────────────────────────────────────────

class _SheetDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppTheme.grey100,
      child: const SizedBox(height: 1, width: double.infinity),
    );
  }
}

// ── cancel button ──────────────────────────────────────────────────────────

class _CancelButton extends StatefulWidget {
  const _CancelButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<_CancelButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? AppTheme.grey100 : AppTheme.grey50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Batal',
            style: AppTextTheme.bodyMedium.copyWith(
              color: AppTheme.grey700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

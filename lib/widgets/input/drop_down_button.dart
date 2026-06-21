import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

@Preview(name: 'Preview Dropdown Button')
Widget previewDatePickerSelected() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: AppDropdownButton<String>(
        value: 'Option 1',
        items: [
          AppDropdownItem(label: 'Option 1', value: 'Option 1'),
          AppDropdownItem(label: 'Option 2', value: 'Option 2'),
          AppDropdownItem(label: 'Option 3', value: 'Option 3'),
        ],
      ),
    ),
  );
}
// -----------------------------------------------------------------------------
// APP DROPDOWN ITEM
// -----------------------------------------------------------------------------

class AppDropdownItem<T> {
  const AppDropdownItem({required this.label, required this.value});

  final String label;

  final T value;
}

// -----------------------------------------------------------------------------
// APP DROPDOWN BUTTON
// -----------------------------------------------------------------------------

class AppDropdownButton<T> extends StatefulWidget {
  const AppDropdownButton({
    super.key,
    required this.items,
    this.value,
    this.hintText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.enabled = true,
    this.isShowError = true,
    this.onChanged,
    this.errorSpacing = 4,
  });

  final List<AppDropdownItem<T>> items;

  final T? value;

  final String? hintText;

  final Widget? prefix;

  final Widget? suffix;

  final String? errorText;

  final bool enabled;

  final bool isShowError;

  final ValueChanged<T?>? onChanged;

  final double errorSpacing;

  @override
  State<AppDropdownButton<T>> createState() => _AppDropdownButtonState<T>();
}

class _AppDropdownButtonState<T> extends State<AppDropdownButton<T>> {
  late OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  bool _isOpen = false;

  AppDropdownItem<T>? get _selectedItem {
    try {
      return widget.items.firstWhere((e) => e.value == widget.value);
    } catch (_) {
      return null;
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlay();

    Overlay.of(context).insert(_overlayEntry);

    setState(() {
      _isOpen = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry.remove();

    setState(() {
      _isOpen = false;
    });
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;

    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return DefaultTextStyle(
          style: const TextStyle(fontFamily: 'Inter',fontSize: 14, color: AppTheme.primary),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _removeOverlay,
                  behavior: HitTestBehavior.translucent,
                  child: const SizedBox(),
                ),
              ),

              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 8),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.grey300),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.map((item) {
                      final isSelected = item.value == widget.value;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          widget.onChanged?.call(item.value);

                          _removeOverlay();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            item.label,
                            style: TextStyle(fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry.remove();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: widget.errorSpacing,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: widget.enabled ? _toggleDropdown : null,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              constraints: const BoxConstraints(minHeight: 45),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.grey50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: error != null
                      ? const Color(0xFFD32F2F)
                      : _isOpen
                      ? AppTheme.primary
                      : AppTheme.grey300,
                ),
              ),
              child: Row(
                children: [
                  if (widget.prefix != null) ...[
                    widget.prefix!,
                    const SizedBox(width: 8),
                  ],

                  Expanded(
                    child: Text(
                      _selectedItem?.label ?? widget.hintText ?? '',
                      style: TextStyle(fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _selectedItem == null
                            ? AppTheme.grey400
                            : AppTheme.primary,
                      ),
                    ),
                  ),

                  widget.suffix ??
                      Icon(
                        _isOpen ? AppIcons.arrowUp : AppIcons.arrowDown02,
                        size: 18,
                        color: AppTheme.grey500,
                      ),
                ],
              ),
            ),
          ),
        ),

        if (error != null && widget.isShowError) ...[
          Text(
            error,
            style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
          ),
        ],
      ],
    );
  }
}

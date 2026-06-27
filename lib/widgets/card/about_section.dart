import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key, this.description});

  final String? description;

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    if (widget.description != null && widget.description!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
    }
  }

  void _checkOverflow() {
    if (!mounted) return;
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: AppTextTheme.bodySmall,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );
    final width = context.size?.width ?? 0;
    if (width <= 0) return;
    textPainter.layout(maxWidth: width);
    setState(() => _isOverflowing = textPainter.didExceedMaxLines);
  }

  @override
  Widget build(BuildContext context) {
    final desc = widget.description;
    if (desc == null || desc.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Me', style: AppTextTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                desc,
                style: AppTextTheme.bodySmall,
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
              if (_isOverflowing) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Text(
                    _isExpanded ? 'View Less' : 'View More',
                    style: AppTextTheme.bodySmall.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

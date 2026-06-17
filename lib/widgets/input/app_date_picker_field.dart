import 'package:health_pal/core/theme/app_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';

class AppDatePickerField extends StatelessWidget {
   const AppDatePickerField({
    super.key,
    required this.value,
    this.hintText,
    this.prefix,
    this.suffix,
    this.errorText,
    this.enabled = true,
    this.isShowError = true,
    this.onTap,
  });

  final DateTime? value;

  final String? hintText;

  final Widget? prefix;

  final Widget? suffix;

  final String? errorText;

  final bool enabled;

  final bool isShowError;

  final VoidCallback? onTap;

  String _format(DateTime? d) {
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final error = errorText;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.grey50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: error != null
                    ? const Color(0xFFD32F2F)
                    : AppTheme.grey300,
              ),
            ),
            child: Row(
              children: [
                prefix ??
                    const Icon(
                      AppIcons.calendar2,
                      size: 18,
                      color: AppTheme.grey500,
                    ),

                Expanded(
                  child: Text(
                    value != null ? _format(value) : hintText ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: value == null
                          ? AppTheme.grey400
                          : AppTheme.primary,
                    ),
                  ),
                ),

                ?suffix,
              ],
            ),
          ),

          if (error != null && isShowError) ...[
            const SizedBox(height: 6),
            Text(
              error,
              style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

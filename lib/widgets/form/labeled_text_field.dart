import 'package:flutter/material.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// A labeled text input field with optional validation.
///
/// Renders a [label] above a [TextFormField] bound to [controller].
/// When [required] is true, the field shows an error if empty on submit.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
  });

  final String label;
  final TextEditingController controller;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextTheme.bodyMedium),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.grey200),
            ),
          ),
          validator: required
              ? (v) => (v == null || v.trim().isEmpty)
                    ? '$label wajib diisi'
                    : null
              : null,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:health_pal/core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, this.onTap, required this.label});
  final void Function()? onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(42),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppTheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

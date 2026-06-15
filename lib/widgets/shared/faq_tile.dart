import 'package:flutter/material.dart';
import 'package:iconsax_latest/iconsax_latest.dart';

import '../../core/theme/app_text_theme.dart';
import '../../core/theme/app_theme.dart';

/// An expansion tile styled for FAQ items.
///
/// Displays [question] as the header and [answer] as the expandable content.
class FaqTile extends StatelessWidget {
  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: const Icon(Iconsax.messageQuestion, color: AppTheme.primary),
        title: Text(question, style: AppTextTheme.bodyLarge),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: AppTextTheme.bodySmall.copyWith(color: AppTheme.grey700),
            ),
          ),
        ],
      ),
    );
  }
}

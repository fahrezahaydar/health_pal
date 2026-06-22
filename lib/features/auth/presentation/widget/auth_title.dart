import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  const AuthTitle({super.key, this.title = '', this.subtitle = ''});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(title, style: ts.headlineLarge?.copyWith(color: cs.primary)),
        Text(
          subtitle,
          style: ts.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

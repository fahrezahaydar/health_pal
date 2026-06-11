import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/home/presentation/widget/greeting_section.dart';

@Preview(
  name: 'Greeting Default',
  group: 'Greeting Section',
  size: Size(390, 200),
)
Widget previewGreetingDefault() {
  return const _PreviewScaffold(child: GreetingSection(nickname: 'John'));
}

@Preview(
  name: 'Greeting Loading',
  group: 'Greeting Section',
  size: Size(390, 200),
)
Widget previewGreetingLoading() {
  return const _PreviewScaffold(child: GreetingSection(nickname: ''));
}

@Preview(
  name: 'Greeting Empty Nickname',
  group: 'Greeting Section',
  size: Size(390, 200),
)
Widget previewGreetingEmpty() {
  return const _PreviewScaffold(child: GreetingSection(nickname: ''));
}

class _PreviewScaffold extends StatelessWidget {
  const _PreviewScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppTheme.white,
      ),
      home: Scaffold(body: SafeArea(child: child)),
    );
  }
}

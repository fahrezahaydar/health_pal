import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';

class AppIconsPreviewPage extends StatelessWidget {
  const AppIconsPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = AppIcons.allIcons.entries.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('App Icons (${icons.length})')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: icons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final icon = icons[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon.value, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    icon.key,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

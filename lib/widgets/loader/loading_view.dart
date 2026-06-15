import 'package:flutter/material.dart';

import 'dot_loader.dart';

/// A centered loading view with padding that displays a [DotLoader].
///
/// Used as a simple loading state placeholder in pages.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(padding: EdgeInsets.all(24), child: DotLoader()),
    );
  }
}

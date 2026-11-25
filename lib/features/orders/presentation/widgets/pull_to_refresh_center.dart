import 'package:flutter/material.dart';

/// يخلي محتوى ثابت في النص (خطأ أو فاضي) يدعم سحب التحديث.
/// بدونه RefreshIndicator ما يشتغل لأن ما فيه شي قابل للتمرير.
class PullToRefreshCenter extends StatelessWidget {
  const PullToRefreshCenter({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

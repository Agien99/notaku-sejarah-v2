import 'package:flutter/material.dart';

import '../../../../core/responsive/app_breakpoints.dart';
import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/app_spacing.dart';

class ShellPageFrame extends StatelessWidget {
  const ShellPageFrame({
    required this.windowClass,
    required this.child,
    super.key,
  });

  final AppWindowClass windowClass;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: windowClass.horizontalPagePadding,
          vertical: AppSpacing.lg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: windowClass.maxContentWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

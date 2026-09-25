import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  AppWindowClass windowClass,
);

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({required this.builder, super.key});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowClass = AppBreakpoints.fromWidth(constraints.maxWidth);

        return builder(context, windowClass);
      },
    );
  }
}

extension AppWindowClassX on AppWindowClass {
  bool get isCompact => this == AppWindowClass.compact;

  bool get isMedium => this == AppWindowClass.medium;

  bool get isExpanded => this == AppWindowClass.expanded;

  bool get usesNavigationRail => !isCompact;

  double get horizontalPagePadding {
    switch (this) {
      case AppWindowClass.compact:
        return 20;
      case AppWindowClass.medium:
        return 28;
      case AppWindowClass.expanded:
        return 40;
    }
  }

  double get maxContentWidth {
    switch (this) {
      case AppWindowClass.compact:
        return 720;
      case AppWindowClass.medium:
        return 960;
      case AppWindowClass.expanded:
        return 1200;
    }
  }
}

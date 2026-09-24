enum AppWindowClass { compact, medium, expanded }

abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 900;

  static AppWindowClass fromWidth(double width) {
    if (width < medium) {
      return AppWindowClass.compact;
    }

    if (width < expanded) {
      return AppWindowClass.medium;
    }

    return AppWindowClass.expanded;
  }
}

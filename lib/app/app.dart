import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/shell/presentation/app_shell.dart';

class NotakuSejarahApp extends StatelessWidget {
  const NotakuSejarahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notaku Sejarah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppShell(),
    );
  }
}

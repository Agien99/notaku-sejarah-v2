import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/more/application/app_settings_controller.dart';
import '../features/shell/presentation/app_shell.dart';

class NotakuSejarahApp extends StatefulWidget {
  const NotakuSejarahApp({super.key});

  @override
  State<NotakuSejarahApp> createState() => _NotakuSejarahAppState();
}

class _NotakuSejarahAppState extends State<NotakuSejarahApp> {
  late final AppSettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = AppSettingsController();
    _settingsController.load();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settingsController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Notaku Sejarah',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                  _settingsController.textSize.scale,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: AppShell(settingsController: _settingsController),
        );
      },
    );
  }
}

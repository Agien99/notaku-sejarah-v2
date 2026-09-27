import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/more/application/app_settings_controller.dart';
import '../features/shell/presentation/app_shell.dart';
import '../features/startup/presentation/startup_screen.dart';

class NotakuSejarahApp extends StatefulWidget {
  const NotakuSejarahApp({super.key});

  @override
  State<NotakuSejarahApp> createState() => _NotakuSejarahAppState();
}

class _NotakuSejarahAppState extends State<NotakuSejarahApp> {
  late final AppSettingsController _settingsController;
  bool _startupComplete = false;

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

  void _finishStartup() {
    if (!mounted || _startupComplete) {
      return;
    }

    setState(() {
      _startupComplete = true;
    });
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
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _startupComplete
                ? AppShell(
                    key: const ValueKey('app-shell'),
                    settingsController: _settingsController,
                  )
                : StartupScreen(
                    key: const ValueKey('startup'),
                    onFinished: _finishStartup,
                  ),
          ),
        );
      },
    );
  }
}

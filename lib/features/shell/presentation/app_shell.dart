import 'package:flutter/material.dart';

import '../../../core/responsive/adaptive_navigation_scaffold.dart';
import '../../home/presentation/utama_screen.dart';
import '../../more/application/app_settings_controller.dart';
import '../../more/presentation/more_screen.dart';
import '../../notes/presentation/notes_screen.dart';
import '../../quiz/presentation/quiz_screen.dart';
import '../../records/presentation/records_screen.dart';
import 'widgets/shell_page_frame.dart';

const _appDestinations = [
  AdaptiveNavigationDestination(
    label: 'Utama',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  AdaptiveNavigationDestination(
    label: 'Nota',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book_rounded,
  ),
  AdaptiveNavigationDestination(
    label: 'Kuiz',
    icon: Icons.quiz_outlined,
    selectedIcon: Icons.quiz_rounded,
  ),
  AdaptiveNavigationDestination(
    label: 'Rekod',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history_rounded,
  ),
  AdaptiveNavigationDestination(
    label: 'Lagi',
    icon: Icons.tune_outlined,
    selectedIcon: Icons.tune_rounded,
  ),
];

class AppShell extends StatefulWidget {
  const AppShell({required this.settingsController, super.key});

  final AppSettingsController settingsController;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<Widget> _appPages = [
    UtamaScreen(
      key: const ValueKey('screen-utama'),
      onOpenNotes: () => _selectDestination(1),
      onOpenQuiz: () => _selectDestination(2),
      onOpenRecords: () => _selectDestination(3),
    ),
    const NotesScreen(key: ValueKey('screen-nota')),
    const QuizScreen(key: ValueKey('screen-kuiz')),
    const RecordsScreen(key: ValueKey('screen-rekod')),
    MoreScreen(
      key: const ValueKey('screen-lagi'),
      settingsController: widget.settingsController,
    ),
  ];

  void _selectDestination(int index) {
    if (index == _selectedIndex) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
      selectedIndex: _selectedIndex,
      destinations: _appDestinations,
      onDestinationSelected: _selectDestination,
      bodyBuilder: (context, windowClass) {
        return ShellPageFrame(
          windowClass: windowClass,
          child: IndexedStack(index: _selectedIndex, children: _appPages),
        );
      },
    );
  }
}

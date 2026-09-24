import 'package:flutter/material.dart';

import '../../../core/responsive/adaptive_navigation_scaffold.dart';
import '../../../core/responsive/app_breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

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
];

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

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
        return _ShellBody(
          selectedIndex: _selectedIndex,
          windowClass: windowClass,
        );
      },
    );
  }
}

class _ShellBody extends StatelessWidget {
  const _ShellBody({
    required this.selectedIndex,
    required this.windowClass,
  });

  final int selectedIndex;
  final AppWindowClass windowClass;

  @override
  Widget build(BuildContext context) {
    final page = switch (selectedIndex) {
      0 => const _ShellPage(
          key: ValueKey('shell-page-utama'),
          title: 'Utama',
          description:
              'Halaman utama Notaku Sejarah akan dibina dalam langkah seterusnya.',
          icon: Icons.home_rounded,
        ),
      1 => const _ShellPage(
          key: ValueKey('shell-page-nota'),
          title: 'Nota',
          description:
              'Koleksi nota sejarah akan ditempatkan di bahagian ini.',
          icon: Icons.menu_book_rounded,
        ),
      2 => const _ShellPage(
          key: ValueKey('shell-page-kuiz'),
          title: 'Kuiz',
          description:
              'Modul kuiz interaktif akan ditempatkan di bahagian ini.',
          icon: Icons.quiz_rounded,
        ),
      3 => const _ShellPage(
          key: ValueKey('shell-page-rekod'),
          title: 'Rekod',
          description:
              'Prestasi dan sejarah aktiviti pengguna akan dipaparkan di sini.',
          icon: Icons.history_rounded,
        ),
      _ => const SizedBox.shrink(),
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: windowClass.horizontalPagePadding,
          vertical: AppSpacing.lg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: windowClass.maxContentWidth,
            ),
            child: page,
          ),
        ),
      ),
    );
  }
}

class _ShellPage extends StatelessWidget {
  const _ShellPage({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppRadius.md),
                  ),
                ),
                child: Icon(icon, color: AppColors.navy),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

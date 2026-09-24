import 'package:flutter/material.dart';

import '../../../core/responsive/adaptive_navigation_scaffold.dart';
import '../../../core/responsive/app_breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

const _foundationDestinations = [
  AdaptiveNavigationDestination(
    label: 'Home',
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

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavigationScaffold(
      selectedIndex: 0,
      destinations: _foundationDestinations,
      onDestinationSelected: (_) {},
      bodyBuilder: (context, windowClass) {
        return _ResponsiveFoundationBody(windowClass: windowClass);
      },
    );
  }
}

class _ResponsiveFoundationBody extends StatelessWidget {
  const _ResponsiveFoundationBody({required this.windowClass});

  final AppWindowClass windowClass;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BrandMark(),
                const SizedBox(height: AppSpacing.xl),
                _WindowClassBadge(windowClass: windowClass),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Satu asas. Semua saiz skrin.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Notaku Sejarah V2 kini menggunakan breakpoint dan '
                  'navigasi adaptif yang sama untuk telefon, landscape '
                  'dan tablet.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),
                _ResponsiveCards(windowClass: windowClass),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsiveCards extends StatelessWidget {
  const _ResponsiveCards({required this.windowClass});

  final AppWindowClass windowClass;

  @override
  Widget build(BuildContext context) {
    const architectureCard = _InfoCard(
      eyebrow: 'PHASE 1.3',
      title: 'Responsive Architecture',
      description:
          'Breakpoint, content width, spacing dan navigation behavior kini '
          'dikawal daripada satu tempat.',
    );

    const navigationCard = _InfoCard(
      eyebrow: 'ADAPTIVE NAVIGATION',
      title: 'Phone ke Tablet',
      description:
          'Compact menggunakan bottom navigation. Medium dan Expanded '
          'menggunakan navigation rail tanpa menukar struktur feature.',
    );

    if (windowClass.isCompact) {
      return const Column(
        children: [
          architectureCard,
          SizedBox(height: AppSpacing.md),
          navigationCard,
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: architectureCard),
        SizedBox(width: AppSpacing.md),
        Expanded(child: navigationCard),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          child: const Icon(
            Icons.auto_stories_outlined,
            color: AppColors.goldSoft,
            size: 28,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NOTAKU SEJARAH', style: AppTypography.title),
              SizedBox(height: AppSpacing.xxs),
              Text('MODERN HERITAGE', style: AppTypography.label),
            ],
          ),
        ),
      ],
    );
  }
}

class _WindowClassBadge extends StatelessWidget {
  const _WindowClassBadge({required this.windowClass});

  final AppWindowClass windowClass;

  @override
  Widget build(BuildContext context) {
    final label = switch (windowClass) {
      AppWindowClass.compact => 'COMPACT · < 600',
      AppWindowClass.medium => 'MEDIUM · 600–899',
      AppWindowClass.expanded => 'EXPANDED · ≥ 900',
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: const BoxDecoration(
          color: AppColors.goldSoft,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
        ),
        child: Text(label, style: AppTypography.label),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(eyebrow, style: AppTypography.label),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(description, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

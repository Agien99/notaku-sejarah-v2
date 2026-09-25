import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class UtamaHeader extends StatelessWidget {
  const UtamaHeader({super.key});

  static const double _wideHeaderBreakpoint = 520;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _BrandBar(),
        const SizedBox(height: AppSpacing.xl),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= _wideHeaderBreakpoint;

            if (isWide) {
              return const _WideGreeting();
            }

            return const _CompactGreeting();
          },
        ),
      ],
    );
  }
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
          ),
          child: const Icon(
            Icons.auto_stories_rounded,
            color: AppColors.goldSoft,
            size: 27,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
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
        IconButton.outlined(
          tooltip: 'Tentang Notaku Sejarah',
          onPressed: () => _showAboutDialog(context),
          icon: const Icon(Icons.info_outline_rounded),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.auto_stories_rounded),
          title: const Text('Tentang Notaku Sejarah'),
          content: const Text(
            'Notaku Sejarah membantu pembelajaran Sejarah melalui nota, '
            'kuiz dan rekod kemajuan dalam pengalaman yang ringkas dan moden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class _CompactGreeting extends StatelessWidget {
  const _CompactGreeting();

  @override
  Widget build(BuildContext context) {
    return const _GreetingCopy();
  }
}

class _WideGreeting extends StatelessWidget {
  const _WideGreeting();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _GreetingCopy()),
          SizedBox(width: AppSpacing.xl),
          Expanded(flex: 2, child: _HeritageMark()),
        ],
      ),
    );
  }
}

class _GreetingCopy extends StatelessWidget {
  const _GreetingCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('utama-greeting'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: const BoxDecoration(
            color: AppColors.goldSoft,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          ),
          child: const Text('Selamat datang 👋', style: AppTypography.label),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Jom belajar Sejarah hari ini.',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Teruskan pembelajaran anda, ulang kaji nota dan uji kefahaman '
          'dengan kuiz.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _HeritageMark extends StatelessWidget {
  const _HeritageMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Motif warisan dan sejarah',
      child: Container(
        height: 150,
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 18,
              right: 18,
              child: Icon(
                Icons.history_edu_rounded,
                color: AppColors.goldSoft,
                size: 38,
              ),
            ),
            const Positioned(
              left: 20,
              bottom: 18,
              child: Icon(
                Icons.account_balance_outlined,
                color: AppColors.white,
                size: 58,
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 12,
              child: Container(height: 2, color: AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}

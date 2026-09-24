import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BrandMark(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Sejarah lebih mudah difahami.',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Foundation visual Notaku Sejarah V2 kini menggunakan '
                    'identiti Modern Heritage yang konsisten.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _FoundationCard(),
                ],
              ),
            ),
          ),
        ),
      ),
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

class _FoundationCard extends StatelessWidget {
  const _FoundationCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Phase 1.2', style: AppTypography.label),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Design System Foundation',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Navy, heritage gold dan warm cream kini menjadi asas visual '
              'untuk semua skrin seterusnya.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _PaletteSwatch(label: 'Navy', color: AppColors.navy),
                _PaletteSwatch(label: 'Gold', color: AppColors.gold),
                _PaletteSwatch(label: 'Cream', color: AppColors.cream),
                _PaletteSwatch(label: 'Surface', color: AppColors.surface),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.border),
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: color.computeLuminance() > 0.5
              ? AppColors.textPrimary
              : AppColors.white,
        ),
      ),
    );
  }
}

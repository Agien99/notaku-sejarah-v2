import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'utama_section_header.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({
    required this.onOpenNotes,
    required this.onOpenQuiz,
    required this.onOpenRecords,
    super.key,
  });

  final VoidCallback onOpenNotes;
  final VoidCallback onOpenQuiz;
  final VoidCallback onOpenRecords;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('section-pintasan'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const UtamaSectionHeader(
          title: 'Pintasan',
          subtitle: 'Akses pantas ke bahagian utama pembelajaran anda.',
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.sm;
            final columns = constraints.maxWidth >= 640
                ? 3
                : constraints.maxWidth >= 480
                ? 2
                : 1;
            final cardWidth =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _QuickActionCard(
                    key: const ValueKey('quick-action-nota'),
                    icon: Icons.menu_book_rounded,
                    title: 'Nota',
                    description: 'Baca dan ulang kaji',
                    onTap: onOpenNotes,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _QuickActionCard(
                    key: const ValueKey('quick-action-kuiz'),
                    icon: Icons.quiz_rounded,
                    title: 'Kuiz',
                    description: 'Uji kefahaman',
                    onTap: onOpenQuiz,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _QuickActionCard(
                    key: const ValueKey('quick-action-rekod'),
                    icon: Icons.history_rounded,
                    title: 'Rekod',
                    description: 'Lihat kemajuan',
                    onTap: onOpenRecords,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                ),
                child: Icon(icon, color: AppColors.goldSoft),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/note_form.dart';

class NoteFormCard extends StatelessWidget {
  const NoteFormCard({
    required this.form,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final NoteForm form;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final enabled = form.isAvailable && onTap != null;
    final borderColor = isSelected ? AppColors.gold : AppColors.border;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: borderColor, width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        key: ValueKey('note-form-${form.level}'),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      '${form.level}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.goldSoft,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const Spacer(),
                  _AvailabilityBadge(isAvailable: form.isAvailable),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                form.title,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(form.theme, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 18,
                    color: form.isAvailable
                        ? AppColors.royalBlue
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    form.chapterCountLabel,
                    style: Theme.of(context).textTheme.labelLarge
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const Spacer(),
                  if (form.isAvailable)
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.royalBlue,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.goldSoft : AppColors.cream,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        isAvailable ? 'Tersedia' : 'Akan Datang',
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: AppColors.navy, fontWeight: FontWeight.w700),
      ),
    );
  }
}

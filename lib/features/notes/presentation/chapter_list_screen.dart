import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/models/note_chapter.dart';
import '../domain/models/note_form.dart';
import 'note_reader_screen.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen({
    required this.form,
    this.onChapterSelected,
    super.key,
  });

  final NoteForm form;
  final ValueChanged<NoteChapter>? onChapterSelected;

  void _openChapter(BuildContext context, NoteChapter chapter) {
    final callback = onChapterSelected;
    if (callback != null) {
      callback(chapter);
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NoteReaderScreen(form: form, chapter: chapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: Text(form.title)),
      body: SafeArea(
        child: ResponsiveLayout(
          builder: (context, windowClass) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: windowClass.horizontalPagePadding,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: windowClass.maxContentWidth,
                  ),
                  child: ChapterListPanel(
                    form: form,
                    onChapterSelected: (chapter) =>
                        _openChapter(context, chapter),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChapterListPanel extends StatelessWidget {
  const ChapterListPanel({
    required this.form,
    this.onChapterSelected,
    this.compactHeader = false,
    super.key,
  });

  final NoteForm form;
  final ValueChanged<NoteChapter>? onChapterSelected;
  final bool compactHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('chapter-list-${form.level}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChapterHeader(form: form, compact: compactHeader),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 520 ? 2 : 1;
            const gap = AppSpacing.sm;
            final cardWidth =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final chapter in form.chapters)
                  SizedBox(
                    width: cardWidth,
                    child: _ChapterCard(
                      chapter: chapter,
                      onTap: onChapterSelected == null
                          ? null
                          : () => onChapterSelected!(chapter),
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

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({required this.form, required this.compact});

  final NoteForm form;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 46 : 56,
            height: compact ? 46 : 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              '${form.level}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  form.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  form.theme,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.goldSoft),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Pilih salah satu daripada ${form.chapters.length} bab.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${form.curriculum.label} · Sesi ${form.curriculum.effectiveYear}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.goldSoft,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.onTap});

  final NoteChapter chapter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('note-chapter-${chapter.number}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
                ),
                child: Text(
                  '${chapter.number}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.royalBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      chapter.title,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Baca nota',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Padding(
                  padding: EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(Icons.arrow_forward_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

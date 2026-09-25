import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/note_content_repository.dart';
import '../domain/models/note_chapter.dart';
import '../domain/models/note_chapter_content.dart';
import '../domain/models/note_form.dart';

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen({
    required this.form,
    required this.chapter,
    this.repository = const AssetNoteContentRepository(),
    super.key,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteContentRepository repository;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late Future<NoteChapterContent> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _loadContent();
  }

  @override
  void didUpdateWidget(NoteReaderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.chapter.contentAsset != widget.chapter.contentAsset ||
        oldWidget.repository != widget.repository) {
      _contentFuture = _loadContent();
    }
  }

  Future<NoteChapterContent> _loadContent() async {
    final content = await widget.repository.load(widget.chapter);

    if (content.form != widget.form.level ||
        content.chapter != widget.chapter.number ||
        content.title != widget.chapter.title ||
        content.curriculum != widget.form.curriculum.code ||
        content.contentVersion != widget.form.curriculum.contentVersion) {
      throw const FormatException('Metadata nota tidak sepadan.');
    }

    return content;
  }

  void _retry() {
    setState(() {
      _contentFuture = _loadContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('${widget.form.title} · ${widget.chapter.label}'),
      ),
      body: SafeArea(
        child: FutureBuilder<NoteChapterContent>(
          future: _contentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const _ReaderLoadingState();
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _ReaderErrorState(onRetry: _retry);
            }

            return ResponsiveLayout(
              builder: (context, windowClass) {
                final content = snapshot.data!;
                final horizontalPadding = windowClass.isCompact
                    ? AppSpacing.md
                    : windowClass.horizontalPagePadding;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.md,
                    horizontalPadding,
                    AppSpacing.lg,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1180),
                      child: windowClass.isExpanded
                          ? _ExpandedReader(
                              form: widget.form,
                              chapter: widget.chapter,
                              content: content,
                            )
                          : _CompactReader(
                              form: widget.form,
                              chapter: widget.chapter,
                              content: content,
                            ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CompactReader extends StatelessWidget {
  const _CompactReader({
    required this.form,
    required this.chapter,
    required this.content,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteChapterContent content;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('native-note-reader'),
      child: _ReaderContent(
        form: form,
        chapter: chapter,
        content: content,
      ),
    );
  }
}

class _ExpandedReader extends StatelessWidget {
  const _ExpandedReader({
    required this.form,
    required this.chapter,
    required this.content,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteChapterContent content;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('native-note-reader-expanded'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 270,
          child: _TableOfContents(
            form: form,
            chapter: chapter,
            content: content,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            key: const ValueKey('native-note-reader'),
            child: _ReaderContent(
              form: form,
              chapter: chapter,
              content: content,
              showHeaderMetadata: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReaderContent extends StatelessWidget {
  const _ReaderContent({
    required this.form,
    required this.chapter,
    required this.content,
    this.showHeaderMetadata = true,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteChapterContent content;
  final bool showHeaderMetadata;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReaderHero(
          form: form,
          chapter: chapter,
          content: content,
          showMetadata: showHeaderMetadata,
        ),
        const SizedBox(height: AppSpacing.lg),
        _OverviewCard(text: content.overview),
        if (content.keywords.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _KeywordSection(keywords: content.keywords),
        ],
        for (final section in content.sections) ...[
          const SizedBox(height: AppSpacing.lg),
          _SectionCard(section: section),
        ],
        if (content.keyFacts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _KeyFactsCard(items: content.keyFacts),
        ],
        if (content.summary.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _SummaryCard(items: content.summary),
        ],
        const SizedBox(height: AppSpacing.lg),
        _ReviewStamp(
          curriculum: content.curriculum,
          contentVersion: content.contentVersion,
          reviewedOn: content.reviewedOn,
        ),
      ],
    );
  }
}

class _ReaderHero extends StatelessWidget {
  const _ReaderHero({
    required this.form,
    required this.chapter,
    required this.content,
    required this.showMetadata,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteChapterContent content;
  final bool showMetadata;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _HeroChip(label: form.title),
              _HeroChip(label: chapter.label),
              if (showMetadata)
                _HeroChip(
                  label:
                      '${form.curriculum.label} ${form.curriculum.effectiveYear}',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            chapter.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            form.theme,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.goldSoft,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _ReaderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.auto_stories_outlined,
            title: 'Gambaran Keseluruhan',
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _KeywordSection extends StatelessWidget {
  const _KeywordSection({required this.keywords});

  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    return _ReaderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            icon: Icons.key_rounded,
            title: 'Kata Kunci',
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final keyword in keywords)
                Chip(
                  label: Text(keyword),
                  side: const BorderSide(color: AppColors.border),
                  backgroundColor: AppColors.cream,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final NoteSection section;

  @override
  Widget build(BuildContext context) {
    return _ReaderCard(
      key: ValueKey('note-section-${section.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.id,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.royalBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            section.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            section.intro,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
          if (section.points.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            for (final point in section.points) ...[
              _BulletPoint(text: point),
              const SizedBox(height: AppSpacing.xs),
            ],
          ],
        ],
      ),
    );
  }
}

class _KeyFactsCard extends StatelessWidget {
  const _KeyFactsCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('note-key-facts'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gold),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            icon: Icons.star_outline_rounded,
            title: 'Fakta Penting',
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in items) ...[
            _BulletPoint(text: item, emphasized: true),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('note-summary'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeading(
            icon: Icons.checklist_rounded,
            title: 'Ringkasan Bab',
            foreground: AppColors.goldSoft,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: AppColors.goldSoft,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _TableOfContents extends StatelessWidget {
  const _TableOfContents({
    required this.form,
    required this.chapter,
    required this.content,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteChapterContent content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${form.title} · ${chapter.label}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.royalBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                chapter.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Kandungan Bab',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final section in content.sections)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.id,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.royalBlue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          section.title,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(height: AppSpacing.xl),
              Text(
                '${form.curriculum.label} ${form.curriculum.effectiveYear}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewStamp extends StatelessWidget {
  const _ReviewStamp({
    required this.curriculum,
    required this.contentVersion,
    required this.reviewedOn,
  });

  final String curriculum;
  final String contentVersion;
  final String reviewedOn;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Kandungan $curriculum · Versi $contentVersion · Semakan $reviewedOn',
      key: const ValueKey('note-review-stamp'),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _ReaderCard extends StatelessWidget {
  const _ReaderCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.title,
    this.foreground = AppColors.navy,
  });

  final IconData icon;
  final String title;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: foreground, size: 21),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text, this.emphasized = false});

  final String text;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.royalBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReaderLoadingState extends StatelessWidget {
  const _ReaderLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey('note-reader-loading'),
      child: CircularProgressIndicator(),
    );
  }
}

class _ReaderErrorState extends StatelessWidget {
  const _ReaderErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('note-reader-error'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: AppColors.royalBlue,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nota tidak dapat dibuka',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Kandungan nota tidak dapat dimuatkan. Cuba semula.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Cuba semula'),
            ),
          ],
        ),
      ),
    );
  }
}

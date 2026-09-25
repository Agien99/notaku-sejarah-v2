import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/models/note_chapter.dart';
import '../domain/models/note_form.dart';

typedef NoteViewerBuilder = Widget Function(
  BuildContext context,
  String assetName,
  int initialPageNumber,
  int revision,
  VoidCallback onRetry,
);

class NoteReaderScreen extends StatefulWidget {
  const NoteReaderScreen({
    required this.form,
    required this.chapter,
    this.viewerBuilder,
    super.key,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final NoteViewerBuilder? viewerBuilder;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  int _viewerRevision = 0;

  void _retry() {
    setState(() {
      _viewerRevision++;
    });
  }

  Widget _buildViewer(
    BuildContext context,
    String assetName,
    int initialPageNumber,
    int revision,
    VoidCallback onRetry,
  ) {
    return PdfViewer.asset(
      assetName,
      key: ValueKey('note-pdf-$assetName-$revision'),
      initialPageNumber: initialPageNumber,
      params: PdfViewerParams(
        margin: AppSpacing.sm,
        backgroundColor: AppColors.cream,
        limitRenderingCache: true,
        maxImageBytesCachedOnMemory: 64 * 1024 * 1024,
        buildContextMenu: (context, params) => null,
        loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
          final progress = totalBytes == null || totalBytes <= 0
              ? null
              : bytesDownloaded / totalBytes;

          return _ReaderLoadingState(progress: progress);
        },
        errorBannerBuilder: (context, error, stackTrace, documentRef) {
          return _ReaderErrorState(onRetry: onRetry);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assetName = widget.form.documentAsset;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('${widget.form.title} · ${widget.chapter.label}'),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          builder: (context, windowClass) {
            final horizontalPadding = windowClass.isCompact
                ? AppSpacing.xs
                : windowClass.horizontalPagePadding;
            final verticalPadding = windowClass.isCompact
                ? AppSpacing.xs
                : AppSpacing.md;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    children: [
                      _ReaderHeader(
                        form: widget.form,
                        chapter: widget.chapter,
                        compact: windowClass.isCompact,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            windowClass.isCompact ? AppRadius.sm : AppRadius.lg,
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: assetName == null
                                ? const _ReaderUnavailableState()
                                : (widget.viewerBuilder ?? _buildViewer)(
                                    context,
                                    assetName,
                                    widget.chapter.initialPageNumber,
                                    _viewerRevision,
                                    _retry,
                                  ),
                          ),
                        ),
                      ),
                    ],
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

class _ReaderHeader extends StatelessWidget {
  const _ReaderHeader({
    required this.form,
    required this.chapter,
    required this.compact,
  });

  final NoteForm form;
  final NoteChapter chapter;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter.label.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.goldSoft,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                chapter.title,
                maxLines: compact ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          );

          final pageChip = Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'Muka surat ${chapter.printedPage}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
          );

          if (constraints.maxWidth < 520) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details,
                const SizedBox(height: AppSpacing.sm),
                pageChip,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: details),
              const SizedBox(width: AppSpacing.md),
              pageChip,
            ],
          );
        },
      ),
    );
  }
}

class _ReaderLoadingState extends StatelessWidget {
  const _ReaderLoadingState({required this.progress});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Membuka nota…',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Dokumen sedang disediakan daripada simpanan aplikasi.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReaderErrorState extends StatelessWidget {
  const _ReaderErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
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
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Fail nota mungkin belum tersedia atau tidak dapat dibaca.',
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
      ),
    );
  }
}

class _ReaderUnavailableState extends StatelessWidget {
  const _ReaderUnavailableState();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: const ValueKey('note-reader-unavailable'),
      color: AppColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_book_outlined,
                size: 44,
                color: AppColors.royalBlue,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Nota belum tersedia',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Kandungan untuk bahagian ini akan ditambah kemudian.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

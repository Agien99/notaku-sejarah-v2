import 'package:flutter/material.dart';

import '../../../core/responsive/app_breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/note_repository.dart';
import '../domain/models/note_chapter.dart';
import '../domain/models/note_form.dart';
import 'chapter_list_screen.dart';
import 'note_reader_screen.dart';
import 'widgets/note_form_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({this.repository = const LocalNoteRepository(), super.key});

  final NoteRepository repository;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final List<NoteForm> _forms;
  NoteForm? _selectedForm;

  @override
  void initState() {
    super.initState();
    _forms = widget.repository.getForms();

    for (final form in _forms) {
      if (form.isAvailable) {
        _selectedForm = form;
        break;
      }
    }
  }

  void _openForm(
    BuildContext context,
    NoteForm form,
    AppWindowClass windowClass,
  ) {
    if (!form.isAvailable) {
      return;
    }

    if (windowClass.isExpanded) {
      setState(() {
        _selectedForm = form;
      });
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ChapterListScreen(form: form),
      ),
    );
  }

  void _openChapter(
    BuildContext context,
    NoteForm form,
    NoteChapter chapter,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => NoteReaderScreen(form: form, chapter: chapter),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, windowClass) {
        return Column(
          key: const ValueKey('notes-content'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _NotesHeader(),
            const SizedBox(height: AppSpacing.xl),
            if (windowClass.isExpanded)
              _ExpandedNotesLayout(
                forms: _forms,
                selectedForm: _selectedForm,
                onFormSelected: (form) => _openForm(context, form, windowClass),
                onChapterSelected: (form, chapter) =>
                    _openChapter(context, form, chapter),
              )
            else
              _FormGrid(
                forms: _forms,
                columns: windowClass.isMedium ? 2 : 1,
                onFormSelected: (form) => _openForm(context, form, windowClass),
              ),
          ],
        );
      },
    );
  }
}

class _NotesHeader extends StatelessWidget {
  const _NotesHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NOTA',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.royalBlue,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Nota Sejarah',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            'Pilih tingkatan untuk melihat senarai bab dan mula ulang kaji '
            'Sejarah mengikut kandungan KSSM.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

typedef _ChapterSelection = void Function(NoteForm form, NoteChapter chapter);

class _ExpandedNotesLayout extends StatelessWidget {
  const _ExpandedNotesLayout({
    required this.forms,
    required this.selectedForm,
    required this.onFormSelected,
    required this.onChapterSelected,
  });

  final List<NoteForm> forms;
  final NoteForm? selectedForm;
  final ValueChanged<NoteForm> onFormSelected;
  final _ChapterSelection onChapterSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _FormGrid(
            forms: forms,
            columns: 1,
            selectedForm: selectedForm,
            onFormSelected: onFormSelected,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 6,
          child: selectedForm == null
              ? const _SelectFormHint()
              : ChapterListPanel(
                  form: selectedForm!,
                  compactHeader: true,
                  onChapterSelected: (chapter) =>
                      onChapterSelected(selectedForm!, chapter),
                ),
        ),
      ],
    );
  }
}

class _FormGrid extends StatelessWidget {
  const _FormGrid({
    required this.forms,
    required this.columns,
    required this.onFormSelected,
    this.selectedForm,
  });

  final List<NoteForm> forms;
  final int columns;
  final NoteForm? selectedForm;
  final ValueChanged<NoteForm> onFormSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.sm;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final form in forms)
              SizedBox(
                width: cardWidth,
                child: NoteFormCard(
                  form: form,
                  isSelected: selectedForm?.level == form.level,
                  onTap: form.isAvailable ? () => onFormSelected(form) : null,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SelectFormHint extends StatelessWidget {
  const _SelectFormHint();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            const Icon(
              Icons.menu_book_outlined,
              size: 40,
              color: AppColors.royalBlue,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Pilih tingkatan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Senarai bab akan dipaparkan di sini.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

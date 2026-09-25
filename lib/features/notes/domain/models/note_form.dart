import 'note_chapter.dart';

class NoteForm {
  const NoteForm({
    required this.level,
    required this.theme,
    required this.isAvailable,
    required this.chapters,
    this.documentAsset,
  });

  final int level;
  final String theme;
  final bool isAvailable;
  final List<NoteChapter> chapters;
  final String? documentAsset;

  String get title => 'Tingkatan $level';

  String get chapterCountLabel =>
      chapters.isEmpty ? 'Belum tersedia' : '${chapters.length} bab';
}

import 'note_chapter.dart';
import 'note_curriculum.dart';

class NoteForm {
  const NoteForm({
    required this.level,
    required this.theme,
    required this.isAvailable,
    required this.chapters,
    required this.curriculum,
  });

  final int level;
  final String theme;
  final bool isAvailable;
  final List<NoteChapter> chapters;
  final NoteCurriculum curriculum;

  String get title => 'Tingkatan $level';

  String get chapterCountLabel =>
      chapters.isEmpty ? 'Belum tersedia' : '${chapters.length} bab';
}

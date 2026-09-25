class NoteChapter {
  const NoteChapter({required this.number, required this.title});

  final int number;
  final String title;

  String get label => 'Bab $number';
}

class NoteChapter {
  const NoteChapter({
    required this.number,
    required this.title,
    required this.contentAsset,
  });

  final int number;
  final String title;
  final String contentAsset;

  String get label => 'Bab $number';
}

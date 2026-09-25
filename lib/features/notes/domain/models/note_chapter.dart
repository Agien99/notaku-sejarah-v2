class NoteChapter {
  const NoteChapter({
    required this.number,
    required this.title,
    required this.printedPage,
    required this.initialPageNumber,
  });

  final int number;
  final String title;
  final int printedPage;
  final int initialPageNumber;

  String get label => 'Bab $number';
}

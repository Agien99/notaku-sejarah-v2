class QuizDataException implements Exception {
  const QuizDataException(this.message);

  final String message;

  @override
  String toString() => 'QuizDataException: $message';
}

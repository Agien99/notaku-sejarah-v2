class QuizOption {
  const QuizOption({required this.id, required this.text});

  final String id;
  final String text;

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(id: json['id'] as String, text: json['text'] as String);
  }
}

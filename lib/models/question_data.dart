class QuestionData {
  final String question;
  final int solution;

  QuestionData({required this.question, required this.solution});

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: json['question'] as String,
      solution: json['solution'] as int,
    );
  }
}

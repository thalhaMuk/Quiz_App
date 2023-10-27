import '../helpers/constant_helper.dart';

class QuestionData {
  final String question;
  final int solution;

  QuestionData({required this.question, required this.solution});

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: json[ConstantHelper.questionText] as String,
      solution: json[ConstantHelper.solutionText] as int,
    );
  }
}

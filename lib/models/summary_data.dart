import 'package:hive/hive.dart';

part './summary_data.g.dart';

@HiveType(typeId: 0)
class LocalAnswerHistory {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final int selectedAnswer;

  @HiveField(3)
  final bool isCorrect;

  @HiveField(4)
  final DateTime timestamp;

  LocalAnswerHistory({
    required this.userId,
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timestamp,
  });
}

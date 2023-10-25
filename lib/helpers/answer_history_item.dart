import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'color_helper.dart';
import 'string_helper.dart';

class AnswerHistoryItem extends StatelessWidget {
  final String questionImageUrl;
  final int selectedAnswer;
  final bool isCorrect;
  final Timestamp timestamp;

  const AnswerHistoryItem({
    required this.questionImageUrl,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: isCorrect ? ColorHelper.successColor : ColorHelper.errorColor),
      ),
      child: Column(
        children: [
          Image.network(questionImageUrl),
          Text('${StringHelper.selectedAnswerLabel} $selectedAnswer'),
          Text('${StringHelper.correctAnswerLabel} ${isCorrect ? StringHelper.yesText : StringHelper.noText}',
              style: TextStyle(color: isCorrect ? ColorHelper.successColor : ColorHelper.errorColor)),
          Text('${StringHelper.timestampLabel} ${timestamp.toDate()}'),
        ],
      ),
    );
  }
}

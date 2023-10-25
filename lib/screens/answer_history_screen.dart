import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/helpers/hive_helper.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../helpers/answer_history_item.dart';
import '../helpers/color_helper.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/firebase_helper.dart';
import '../helpers/lazy_load.dart';
import '../main.dart';

class AnswerHistory extends StatefulWidget {
  final User? user;

  const AnswerHistory({Key? key, this.user}) : super(key: key);

  @override
  State<AnswerHistory> createState() => _AnswerHistoryState();
}

class _AnswerHistoryState extends State<AnswerHistory> {
  late Map<String, dynamic> data;
  late Timestamp timestamp;
  late bool isCorrect;
  late String questionImageUrl;
  late int selectedAnswer;
  bool isLoading = true;
  late List<dynamic> answerHistory;

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  @override
  Future<void> initState() async {
    super.initState();
    if (widget.user != null) {
      answerHistory = await FirebaseHelper.initializeFirebase(
          StringHelper.databaseName, widget.user!, _showErrorDialog);
    } else {
      answerHistory = await HiveHelper.getAnswerHistoryFromHive(
          StringHelper.databaseName, _showErrorDialog);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildAnswerHistoryList() {
    return ListView.builder(
      itemCount: answerHistory.length,
      itemBuilder: (context, index) {
        var localHistory = answerHistory[index];
        if (widget.user != null) {
          isCorrect = localHistory.data()[StringHelper.isCorrectText];
          questionImageUrl = localHistory.data()[StringHelper.questionText];
          selectedAnswer = localHistory.data()[StringHelper.selectedAnswerText];
          timestamp = localHistory.data()[StringHelper.timestampText];
        } else {
          isCorrect = localHistory.isCorrect;
          questionImageUrl = localHistory.question;
          selectedAnswer = localHistory.selectedAnswer;
          timestamp = Timestamp.fromDate(localHistory.timestamp);
        }
        return LazyLoad(
          child: AnswerHistoryItem(
            questionImageUrl: questionImageUrl,
            selectedAnswer: selectedAnswer,
            isCorrect: isCorrect,
            timestamp: timestamp,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildAnswerHistoryList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(firebaseUser: widget.user),
            ),
          );
        },
        label: const Text(StringHelper.goBackText),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: ColorHelper.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../helpers/color_helper.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/string_helper.dart';
import '../main.dart';
import '../widgets/opening_screen_widgets/opening_screen_app_bar.dart';
import 'answer_history_screen.dart';
import '../models/summary_data.dart';

class SummaryScreen extends StatefulWidget {
  final User? user;

  const SummaryScreen({Key? key, this.user}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late int totalQuestions;
  late int correctAnswers;
  late int incorrectAnswers;
  bool isLoading = true;
  bool hiveBoxExists = true;

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  Future<void> _getAnswerHistoryFromHive() async {
    try {
      if (await Hive.boxExists(StringHelper.databaseName)) {
        final answerHistoryBox =
            Hive.box<LocalAnswerHistory>(StringHelper.databaseName);
        List<LocalAnswerHistory> history = [];
        for (var i = 0; i < answerHistoryBox.length; i++) {
          history.add(answerHistoryBox.getAt(i)!);
        }
        totalQuestions = history.length;
        correctAnswers = history.where((answer) => answer.isCorrect).length;
        incorrectAnswers = totalQuestions - correctAnswers;
        if (totalQuestions == 0) {
          hiveBoxExists = false;
        }
      } else {
        hiveBoxExists = false;
      }
    } catch (e) {
      _showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeFirebase() async {
    try {
      var userId = widget.user?.uid;
      var answerHistory = await FirebaseFirestore.instance
          .collection(StringHelper.databaseName)
          .where(StringHelper.userIdText, isEqualTo: userId)
          .get();

      totalQuestions = answerHistory.docs.length;
      correctAnswers = answerHistory.docs
          .where((answer) => answer[StringHelper.isCorrectText])
          .length;
      incorrectAnswers = totalQuestions - correctAnswers;
    } catch (e) {
      _showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _initializeFirebase();
    } else {
      _getAnswerHistoryFromHive();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hiveBoxExists
                ? _buildSummaryWidget()
                : _buildNoGamesPlayedWidget(),
      ),
    );
  }

  Widget _buildSummaryWidget() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.5),
        child: const CustomAppBar(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: StringHelper.totalQuestionsText,
                style: const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$totalQuestions",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: ColorHelper.successColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: StringHelper.totalCorrectAnswersText,
                style: const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$correctAnswers",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: ColorHelper.successColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: StringHelper.totalIncorrectAnswersText,
                style: const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$incorrectAnswers",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: ColorHelper.errorColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnswerHistory(user: widget.user),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorHelper.primaryColor),
                textStyle: const TextStyle(color: ColorHelper.primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              ),
              child: const Text(
                StringHelper.checkAnswerHistoryText,
                style: TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(firebaseUser: widget.user),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorHelper.primaryColor),
                textStyle: const TextStyle(color: ColorHelper.primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
              ),
              child: const Text(
                StringHelper.goBackText,
                style: TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoGamesPlayedWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          StringHelper.noGamesPlayedText,
          style: TextStyle(fontSize: 20, color: ColorHelper.textColor),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(firebaseUser: widget.user),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: ColorHelper.primaryColor),
            textStyle: const TextStyle(color: ColorHelper.primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
          ),
          child: const Text(
            StringHelper.goBackText,
            style: TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../helpers/color_helper.dart';
import '../helpers/dialog_helper.dart';
import '../main.dart';
import '../models/summary_data.dart';

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

  Future<void> _initializeFirebase() async {
    try {
      var userId = widget.user?.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection(StringHelper.databaseName)
          .where(StringHelper.userIdText, isEqualTo: userId)
          .get();

      answerHistory = querySnapshot.docs;
    } catch (e) {
      _showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  Future<void> _getAnswerHistoryFromHive() async {
    try {
      if (await Hive.boxExists(StringHelper.databaseName)) {
        final answerHistoryBox = Hive.box<LocalAnswerHistory>(StringHelper.databaseName);
        List<LocalAnswerHistory> history = [];

        for (var i = 0; i < answerHistoryBox.length; i++) {
          var localHistory = answerHistoryBox.getAt(i);
          if (localHistory != null) {
            history.add(localHistory);
          }
        }

        setState(() {
          answerHistory = history;
          isLoading = false;
        });
      } else {
        setState(() {
          answerHistory = [];
          isLoading = false;
        });
      }
    } catch (e) {
      _showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
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

class LazyLoad extends StatefulWidget {
  final Widget child;

  const LazyLoad({super.key, required this.child});

  @override
  State<LazyLoad> createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ? widget.child : const SizedBox.shrink();
  }
}

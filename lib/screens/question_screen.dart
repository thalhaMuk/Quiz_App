import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:quiver/async.dart';
import '../models/summary_data.dart';
import '../models/question_data.dart';
import '../services/api_service.dart';
import '../helpers/dialog_helper.dart';
import '../widgets/question_screen_widgets/custom_keyboard.dart';
import '../widgets/question_screen_widgets/question_screen_app_bar.dart';

class QuestionScreen extends StatefulWidget {
  final User? user;

  const QuestionScreen({Key? key, this.user}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with WidgetsBindingObserver {
  QuestionData _questionData = QuestionData(question: '', solution: 0);
  int _userScore = 0;
  int _wrongAnswersCount = 0;
  int _correctAnswersCount = 0;
  final int _timerSeconds = 20000;
  late CountdownTimer _timer;
  int? _selectedNumber;
  bool _isTimerRunning = false;
  int _remainingTime = 20000;
  bool _timerExpired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadQuestion();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      _showResumeDialog();
    } else if (state == AppLifecycleState.paused && _isTimerRunning) {
      _timer.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    }
  }

  void _startNewQuestion() {
    setState(() {
      _selectedNumber = -1;
      _isTimerRunning = false;
      _remainingTime = _timerSeconds;
    });
    _loadQuestion();
  }

  void _showResumeDialog() {
    DialogHelper.showResumeDialog(context, widget.user, _userScore,
        _correctAnswersCount, _wrongAnswersCount, _startTimer, _restartGame);
  }

  Future<void> _saveAnswerHistory(int selectedAnswer) async {
    if (widget.user != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance.collection('answerHistory').add({
            'userId': user.uid,
            'question': _questionData.question,
            'selectedAnswer': selectedAnswer,
            'isCorrect': selectedAnswer == _questionData.solution,
            'timestamp': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          _showErrorDialog('Error saving answer history.');
        }
      }
    } else {
      if (await Hive.boxExists('answerHistory')) {
        final answerHistoryBox = Hive.box<LocalAnswerHistory>('answerHistory');
        final answerHistory = LocalAnswerHistory(
          userId: 'User',
          question: _questionData.question,
          selectedAnswer: selectedAnswer,
          isCorrect: selectedAnswer == _questionData.solution,
          timestamp: DateTime.now(),
        );
        await answerHistoryBox.add(answerHistory);
      } else {
        _showErrorDialog('Error saving answer history.');
      }
    }
  }

  void _showResultDialog() {
    if (!_timerExpired) {
      _timerExpired = true;
      DialogHelper.showResultDialog(
        context,
        _userScore,
        _correctAnswersCount,
        _wrongAnswersCount,
        _restartGame,
        widget.user,
      );
    }
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _timer = CountdownTimer(
        Duration(milliseconds: _remainingTime),
        const Duration(milliseconds: 1000),
      );

      _timer.listen((timer) {
        setState(() {
          _remainingTime = timer.remaining.inMilliseconds;
        });

        if (_remainingTime <= 0) {
          _showResultDialog();
        }
      });
      setState(() {
        _isTimerRunning = true;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _userScore = 0;
      _selectedNumber = -1;
      _correctAnswersCount = 0;
      _wrongAnswersCount = 0;
      _isTimerRunning = false;
      _timerExpired = false;
      _remainingTime = _timerSeconds;
    });

    _loadQuestion();
  }

  void _loadQuestion() async {
    try {
      Map<String, dynamic> responseData = await ApiService.fetchQuestion();
      _questionData = QuestionData.fromJson(responseData);
      setState(() {});

      if (!_isTimerRunning) {
        _startTimer();
      }
    } catch (e) {
      _showErrorDialog('Failed to load question. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  void _showAnswerResultDialog(bool isCorrect) {
    DialogHelper.showAnswerResultDialog(
        context,
        isCorrect,
        _questionData.solution,
        _startNewQuestion,
        _timer,
        widget.user,
        _userScore,
        _correctAnswersCount,
        _wrongAnswersCount);
  }

  void onEndGamePressed() {
    if (_isTimerRunning) {
      _timer.cancel();
    }
    DialogHelper.showEndGameDialog(
      context,
      widget.user,
      _userScore,
      _correctAnswersCount,
      _wrongAnswersCount,
    );
  }

  void _validateAnswer(int selectedAnswer) {
    _timer.cancel();
    bool isCorrect = selectedAnswer == _questionData.solution;
    if (isCorrect) {
      _userScore += 10;
      _correctAnswersCount++;
    } else {
      _wrongAnswersCount++;
    }
    _saveAnswerHistory(selectedAnswer);
    _showAnswerResultDialog(isCorrect);
  }

  void _onNumberPressed(int number) {
    setState(() {
      _selectedNumber = number;
    });
  }

  void _onSubmitPressed() {
    if (_selectedNumber != null) {
      _validateAnswer(_selectedNumber!);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String user = widget.user?.displayName ?? 'User';
    String remainingTime = (_remainingTime / 1000).toStringAsFixed(0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 125, 36, 210),
              Color.fromARGB(255, 38, 14, 59),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              CustomAppBar(
                user: user.split(' ')[0],
                quizNumber: _correctAnswersCount + _wrongAnswersCount + 1,
                userScore: _userScore,
                wrongAnswersCount: _wrongAnswersCount,
                correctAnswersCount: _correctAnswersCount,
                firebaseUser: widget.user,
                onEndGamePressed: onEndGamePressed,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      minHeight: 20,
                      backgroundColor: Colors.grey,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                      value: (_remainingTime / _timerSeconds),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Time remaining: $remainingTime seconds",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _questionData.question.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _questionData.question,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    )
                  : const CircularProgressIndicator(),
              CustomKeyboard(
                onNumberPressed: _onNumberPressed,
                onSubmitPressed: _onSubmitPressed,
                selectedNumber: _selectedNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

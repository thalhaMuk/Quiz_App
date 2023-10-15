import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import '../models/question_data.dart';
import '../services/api_service.dart';
import '../helpers/dialog_helper.dart';
import '../widgets/question_screen_widgets/custom_keyboard.dart';
import '../widgets/question_screen_widgets/question_screen_app_bar.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  QuestionData _questionData = QuestionData(question: '', solution: 0);
  int _userScore = 0;
  int _wrongAnswersCount = 0;
  int _correctAnswersCount = 0;
  final String _user = 'User'; // To be used in phase 2
  final int _timerSeconds = 20;
  late CountdownTimer _timer;
  int? _selectedNumber;
  bool _isTimerRunning = false;
  int _remainingTime = 20;
  bool _timerExpired = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _showResultDialog() {
    if (!_timerExpired) {
      _timerExpired = true;
      DialogHelper.showResultDialog(context, _userScore, _correctAnswersCount,
          _wrongAnswersCount, _restartGame);
    }
  }

  void _startTimer() {
    _timer = CountdownTimer(
      Duration(seconds: _timerSeconds),
      const Duration(seconds: 1),
    );

    _timer.listen((timer) {
      setState(() {
        _remainingTime = timer.remaining.inSeconds;
      });

      if (_remainingTime <= 0) {
        _showResultDialog();
      }
    });
  }

  void _restartGame() {
    setState(() {
      _userScore = 0;
      _correctAnswersCount = 0;
      _wrongAnswersCount = 0;
      _isTimerRunning = false;
      _timerExpired = false; 
    });

    if (_isTimerRunning) {
      _remainingTime = _timerSeconds;
      _startTimer();
    }
    _loadQuestion();
  }

  void _loadQuestion() async {
    try {
      Map<String, dynamic> responseData = await ApiService.fetchQuestion();
      _questionData = QuestionData.fromJson(responseData);
      setState(() {});

      if (!_isTimerRunning) {
        _isTimerRunning = true;
        _startTimer();
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      DialogHelper.showErrorDialog(
          context, 'Failed to load question. Please try again later.');
    }
  }

  void _validateAnswer(int selectedAnswer) {
    if (selectedAnswer == _questionData.solution) {
      _userScore += 10;
      _correctAnswersCount++;
    } else {
      _wrongAnswersCount++;
    }
    _loadQuestion();
  }

  void _quitGame() {
    DialogHelper.showQuitGameDialog(context, _restartGame);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                children: [
                  CustomAppBar(
                    user: _user,
                    quizNumber: _correctAnswersCount + _wrongAnswersCount + 1,
                    userScore: _userScore,
                    wrongAnswersCount: _wrongAnswersCount,
                    correctAnswersCount: _correctAnswersCount,
                    onQuitGame: _quitGame,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          minHeight: 20,
                          backgroundColor: Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                          value: 1 - (_remainingTime / _timerSeconds),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Time remaining: $_remainingTime seconds",
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
            ],
          ),
        ),
      ),
    );
  }
}

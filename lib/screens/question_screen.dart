import '../helpers/import_helper.dart';

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
  late OverlayEntry loadingOverlay;
  final FirebaseService firebaseHelper = FirebaseService();
  final HiveService hiveHelper = HiveService();
  late int totalScore;

  @override
  void initState() {
    logger.d(StringHelper.mountingStart);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadQuestion();
    logger.d(StringHelper.mountingEnd);
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

  Future<void> _checkMilestone() async {
    if (totalScore % 100 == 0 && totalScore >= 100) {
      bool? userWantsToShare =
          // ignore: use_build_context_synchronously
          await DialogHelper.showCongratulationsPopup(
              context, totalScore.toString());
      if (userWantsToShare == true) {
        Share.share(StringHelper.shareText);
      }
    }
  }

  Future<dynamic> _getTotalSCore() async {
    if (widget.user != null) {
      return await firebaseHelper.getTotalScore(widget.user!.uid);
    } else {
      return await hiveHelper.getTotalScore();
    }
  }

  Future<void> _updateScoreToDatabase() async {
    loadingOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 20,
        left: MediaQuery.of(context).size.width / 2 - 20,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ColorHelper.primaryColor),
        ),
      ),
    );
    Overlay.of(context).insert(loadingOverlay);

    totalScore = await _getTotalSCore();
    int newTotalScore = 10 + totalScore;
    if (widget.user != null) {
    } else {
      await hiveHelper.updateScoreToDatabase(newTotalScore);
    }
    loadingOverlay.remove();
  }

  Future<void> _saveAnswerHistory(
      String question, int selectedAnswer, bool isCorrect) async {
    if (widget.user != null) {
      await firebaseHelper.saveAnswerHistory(
          widget.user!.uid,
          widget.user!.displayName,
          question,
          selectedAnswer,
          isCorrect,
          _showErrorDialog,
          totalScore);
    } else {
      await hiveHelper.saveAnswerHistory(question, selectedAnswer, isCorrect);
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
      _showErrorDialog(StringHelper.loadingQuestionErrorMessage);
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

  void _validateAnswer(int selectedAnswer) async {
    _timer.cancel();
    bool isCorrect = selectedAnswer == _questionData.solution;
    if (isCorrect) {
      _userScore += 10;
      _correctAnswersCount++;
      await _updateScoreToDatabase();
      await _checkMilestone();
    } else {
      _wrongAnswersCount++;
    }
    _saveAnswerHistory(_questionData.question, selectedAnswer, isCorrect);
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
    String user = widget.user?.displayName ?? StringHelper.defaultUsername;
    String remainingTime = (_remainingTime / 1000).toStringAsFixed(0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorHelper.gradientStartColor,
              ColorHelper.gradientEndColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              QuestionScreenAppBar(
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
                      backgroundColor: ColorHelper.timerBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorHelper.timerValueColor),
                      value: (_remainingTime / _timerSeconds),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${StringHelper.timeRemainingText} $remainingTime ${StringHelper.secondsText}",
                          style: const TextStyle(
                              color: ColorHelper.secondaryColor),
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

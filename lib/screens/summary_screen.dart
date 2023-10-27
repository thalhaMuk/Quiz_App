import '../helpers/import_helper.dart';


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
  final FirebaseService firebaseHelper = FirebaseService();
  final HiveService hiveHelper = HiveService();

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  Future<void> _getAnswerHistoryFromHive() async {
    try {
      var history = await HiveService.getAnswerHistoryFromHive(
          ConstantHelper.databaseName, _showErrorDialog);
      if (history.isNotEmpty) {
        totalQuestions = history.length;
        debugPrint(history[0].isCorrect.toString());
        correctAnswers = history
            .where((answer) => answer.isCorrect != null && answer.isCorrect!)
            .length;
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
      var answerHistory = await FirebaseService.initializeFirebase(
          ConstantHelper.databaseName, widget.user!, _showErrorDialog);

      totalQuestions =
          answerHistory.docs[0][ConstantHelper.answerHistory].length;
      correctAnswers = answerHistory.docs[0][ConstantHelper.answerHistory]
          .where((answer) => answer?[ConstantHelper.isCorrectText] == true)
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
    logger.d(StringHelper.mountingStart);
    getData();
    logger.d(StringHelper.mountingEnd);
  }

  void getData() async {
    if (widget.user != null) {
      await _initializeFirebase();
    } else {
      await _getAnswerHistoryFromHive();
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
                style:
                    const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$totalQuestions",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: ColorHelper.successColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: StringHelper.totalCorrectAnswersText,
                style:
                    const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$correctAnswers",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: ColorHelper.successColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: StringHelper.totalIncorrectAnswersText,
                style:
                    const TextStyle(fontSize: 20, color: ColorHelper.textColor),
                children: <TextSpan>[
                  TextSpan(
                    text: "$incorrectAnswers",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: ColorHelper.errorColor),
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
                    builder: (context) => LeaderboardScreen(user: widget.user),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorHelper.primaryColor),
                textStyle: const TextStyle(color: ColorHelper.primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                StringHelper.goLeaderboardButtonText,
                style: TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
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
                builder: (context) => const HomeScreen(),
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

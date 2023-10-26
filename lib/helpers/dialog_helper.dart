import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../screens/home_screen.dart';
import '../screens/summary_screen.dart';

class DialogHelper {
  static void showResultDialog(
      BuildContext passedContext,
      int userScore,
      int correctAnswersCount,
      int wrongAnswersCount,
      Function restartGame,
      User? user) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Center(child: Text(StringHelper.quizResultText)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${StringHelper.userScoreText} $userScore"),
              Text(
                  "${StringHelper.totalQuestionsText} ${correctAnswersCount + wrongAnswersCount}"),
              Text(
                  "${StringHelper.totalCorrectAnswersText} $correctAnswersCount"),
              Text(
                  "${StringHelper.totalIncorrectAnswersText} $wrongAnswersCount"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text(StringHelper.tryAgainText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) => SummaryScreen(user: user),
                  ),
                );
              },
              child: const Text(StringHelper.viewSummaryButtonText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) => HomeScreen(firebaseUser: user),
                  ),
                );
              },
              child: const Text(StringHelper.endGameButtonText),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext passedContext, String errorMessage) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: const Text(StringHelper.errorText),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(StringHelper.okText),
            ),
          ],
        );
      },
    );
  }

  static void showQuitGameDialog(BuildContext passedContext, User? user) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text(StringHelper.quitGameTitle)),
          content: const Text(StringHelper.quitGameMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(StringHelper.cancelText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) => HomeScreen(firebaseUser: user),
                  ),
                );
              },
              child: const Text(StringHelper.endText),
            ),
          ],
        );
      },
    );
  }

  static void showEndGameDialog(BuildContext passedContext, User? user,
      userScore, correctAnswersCount, wrongAnswersCount) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text(StringHelper.gameOverTitle)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${StringHelper.userScoreText} $userScore'),
              Text('${StringHelper.correctAnswersText} $correctAnswersCount'),
              Text('${StringHelper.wrongAnswersText} $wrongAnswersCount'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(passedContext);
              },
              child: const Text(StringHelper.goBackHomeText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) => SummaryScreen(user: user),
                  ),
                );
              },
              child: const Text(StringHelper.viewSummaryButtonText),
            ),
          ],
        );
      },
    );
  }

  static void showResumeDialog(
      BuildContext passedContext,
      User? user,
      int userScore,
      int correctAnswersCount,
      int wrongAnswersCount,
      Function startTimer,
      Function restartGame) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text(StringHelper.resumeGameTitle)),
          content: const Text(StringHelper.resumeGameMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startTimer();
              },
              child: const Text(StringHelper.resumeText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text(StringHelper.newGameText),
            ),
          ],
        );
      },
    );
  }

  static void showAnswerResultDialog(
      BuildContext passedContext,
      bool isCorrect,
      int solution,
      Function startNewQuestion,
      var timer,
      User? user,
      int userScore,
      int correctAnswersCount,
      int wrongAnswersCount) {
    showDialog(
      barrierDismissible: false,
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(isCorrect
                  ? StringHelper.correctAnswerTitleText
                  : StringHelper.wrongAnswerTitleText)),
          content: isCorrect
              ? const Text(StringHelper.congratulationsText)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(StringHelper.oopsText),
                    const SizedBox(height: 10),
                    Text('${StringHelper.correctAnswersText} $solution'),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(passedContext).pop();
                startNewQuestion();
              },
              child: const Text(StringHelper.nextQuestionText),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(passedContext).pop();
                timer.cancel();
                showEndGameDialog(
                  passedContext,
                  user,
                  userScore,
                  correctAnswersCount,
                  wrongAnswersCount,
                );
              },
              child: const Text(StringHelper.endGameButtonText),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showCongratulationsPopup(
      BuildContext context, String totalScore) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${StringHelper.milestoneTitle} $totalScore'),
          content: const Text(StringHelper.milestoneText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(StringHelper.noText),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(StringHelper.yesText),
            ),
          ],
        );
      },
    );
  }
}

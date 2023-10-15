import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogHelper {
  static void showResultDialog(BuildContext context, int userScore, int correctAnswersCount, int wrongAnswersCount, Function restartGame) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Center(child: Text("Quiz Result")),
          content: SizedBox(
            height: 55,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("User Score: $userScore"),
                  Text("Total Questions Answered: ${correctAnswersCount + wrongAnswersCount}"),
                  Text("Correct Answers: $correctAnswersCount"),
                  Text("Incorrect Answers: $wrongAnswersCount"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
              child: const Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod("SystemNavigator.pop");
              },
              child: const Text("Close App"),
            ),
          ],
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showQuitGameDialog(BuildContext context, Function quitGame) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quit Game?'),
          content: const Text('Are you sure you want to quit the game?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                quitGame();
                SystemChannels.platform.invokeMethod("SystemNavigator.pop");
              },
              child: const Text('Quit'),
            ),
          ],
        );
      },
    );
  }
}

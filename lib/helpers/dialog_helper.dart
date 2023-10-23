import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/summary_screen.dart';

class DialogHelper {
  static void showResultDialog(
      BuildContext context,
      int userScore,
      int correctAnswersCount,
      int wrongAnswersCount,
      Function restartGame,
      User? user) {
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
                  Text(
                      "Total Questions Answered: ${correctAnswersCount + wrongAnswersCount}"),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(firebaseUser: user),
                  ),
                );
              },
              child: const Text("View Summary"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(firebaseUser: user),
                  ),
                );
              },
              child: const Text("End Game"),
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

  static void showQuitGameDialog(BuildContext context, User? user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('End Game?'),
          content: const Text('Are you sure you want to end the game?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(firebaseUser: user),
                  ),
                );
              },
              child: const Text('End'),
            ),
          ],
        );
      },
    );
  }

  static void showEndGameDialog(BuildContext context, User? user, userScore,
      correctAnswersCount, wrongAnswersCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: $userScore'),
              Text('Correct Answers: $correctAnswersCount'),
              Text('Wrong Answers: $wrongAnswersCount'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(firebaseUser: user),
                  ),
                );
              },
              child: const Text('Go Back Home'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(firebaseUser: user),
                  ),
                );
              },
              child: const Text('Check Summary'),
            ),
          ],
        );
      },
    );
  }
  
}

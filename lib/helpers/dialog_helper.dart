import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
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
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Center(child: Text("Quiz Result")),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("User Score: $userScore"),
              Text(
                  "Total Questions Answered: ${correctAnswersCount + wrongAnswersCount}"),
              Text("Correct Answers: $correctAnswersCount"),
              Text("Incorrect Answers: $wrongAnswersCount"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) =>
                        SummaryScreen(user: user),
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
                    builder: (passedContext) => MyApp(firebaseUser: user),
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

  static void showErrorDialog(BuildContext passedContext, String errorMessage) {
    showDialog(
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showQuitGameDialog(BuildContext passedContext, User? user) {
    showDialog(
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('End Game?')),
          content: const Text('Are you sure you want to end the game?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) => MyApp(firebaseUser: user),
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

  static void showEndGameDialog(BuildContext passedContext, User? user,
      userScore, correctAnswersCount, wrongAnswersCount) {
    showDialog(
      context: passedContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Game Over')),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                Navigator.pop(context);
                Navigator.pop(passedContext);
              },
              child: const Text('Go Back Home'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (passedContext) =>
                        SummaryScreen(user: user),
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

  static void showResumeDialog(
      BuildContext passedContext,
      User? user,
      int userScore,
      int correctAnswersCount,
      int wrongAnswersCount,
      Function startTimer,
      Function restartGame) {
    showDialog(
      context: passedContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Resume Game?')),
          content: const Text('Do you want to resume your game?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startTimer();
              },
              child: const Text('Resume'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text('New Game'),
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
      context: passedContext,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: Text(isCorrect ? 'Correct Answer!' : 'Wrong Answer!')),
          content: isCorrect
              ? const Text('Congratulations! You answered correctly.')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Oops! Your answer is wrong.'),
                    const SizedBox(height: 10),
                    Text('Correct Answer: $solution'),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(passedContext).pop();
                startNewQuestion();
              },
              child: const Text('Next Question'),
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
              child: const Text('End Game'),
            ),
          ],
        );
      },
    );
  }
}

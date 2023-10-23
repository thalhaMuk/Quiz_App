import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../widgets/opening_screen_widgets/opening_screen_app_bar.dart';
import 'answer_history_screen.dart';

class SummaryScreen extends StatelessWidget {
  final User? firebaseUser;

  const SummaryScreen({this.firebaseUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "You are not logged in!",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(firebaseUser: firebaseUser),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purpleAccent),
                  textStyle: const TextStyle(color: Colors.purpleAccent),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
                child: const Text(
                  "Go Back",
                  style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                ),
              ),
            ],
          ),
        ),
      );
    }

    var userId = firebaseUser?.uid;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.5),
        child: const CustomAppBar(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('answerHistory')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<DocumentSnapshot> answerHistory = snapshot.data!.docs;
          int totalQuestions = answerHistory.length;
          int correctAnswers =
              answerHistory.where((answer) => answer['isCorrect']).length;
          int incorrectAnswers = totalQuestions - correctAnswers;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Total Questions Answered: ",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "$totalQuestions",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Total Correct Answers: ",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "$correctAnswers",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Total Incorrect Answers: ",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: "$incorrectAnswers",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.red),
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
                        builder: (context) => AnswerHistory(firebaseUser: firebaseUser),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purpleAccent),
                    textStyle: const TextStyle(color: Colors.purpleAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    "Check Answer History",
                    style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(firebaseUser: firebaseUser),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purpleAccent),
                    textStyle: const TextStyle(color: Colors.purpleAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 20),
                  ),
                  child: const Text(
                    "Go Back",
                    style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

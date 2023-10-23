import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class CustomAppBar extends StatelessWidget {
  final String user;
  final int quizNumber;
  final int userScore;
  final int wrongAnswersCount;
  final int correctAnswersCount;
  final User? firebaseUser;

  const CustomAppBar(
      {super.key,
      required this.user,
      required this.quizNumber,
      required this.userScore,
      required this.wrongAnswersCount,
      required this.correctAnswersCount,
      this.firebaseUser});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 174, 39, 242),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_outlined),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyApp(firebaseUser: firebaseUser),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.cover,
                    child: RichText(
                      text: TextSpan(
                        text: "Welcome ",
                        style: const TextStyle(fontSize: 30),
                        children: <TextSpan>[
                          TextSpan(
                            text: "$user!",
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Quiz no: ",
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: "$quizNumber",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Score: ",
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: "$userScore",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Wrong answers: ",
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: "$wrongAnswersCount",
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Correct answers: ",
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                            text: "$correctAnswersCount",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

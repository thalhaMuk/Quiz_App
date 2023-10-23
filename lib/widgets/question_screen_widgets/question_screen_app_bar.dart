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
  final VoidCallback onEndGamePressed;

  const CustomAppBar({
    Key? key,
    required this.user,
    required this.quizNumber,
    required this.userScore,
    required this.wrongAnswersCount,
    required this.correctAnswersCount,
    required this.onEndGamePressed,
    this.firebaseUser,
  }) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 7),
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
                  FittedBox(
                    fit: BoxFit.cover,
                    child: RichText(
                      text: TextSpan(
                        text: "Welcome ",
                        style: const TextStyle(fontSize: 25),
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
                              color: Colors.green, fontWeight: FontWeight.w900),
                        ),
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
                              color: Colors.green, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
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
                              color: Colors.red, fontWeight: FontWeight.w900),
                        ),
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
                              color: Colors.green, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onEndGamePressed,
                child: const Text(
                  'End Game',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

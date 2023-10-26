import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helpers/color_helper.dart';
import '../../helpers/string_helper.dart';

class CustomAppBar extends StatelessWidget {
  final String user;
  final int quizNumber;
  final int userScore;
  final int wrongAnswersCount;
  final int correctAnswersCount;
  final User? firebaseUser;
  final Function onEndGamePressed;

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
          color: ColorHelper.appBarColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 35, 20, 5),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: RichText(
                    text: TextSpan(
                      text: StringHelper.welcomeText,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: StringHelper.quizNumberText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                          text: "$quizNumber",
                          style: const TextStyle(
                              color: ColorHelper.successColor, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: StringHelper.scoreText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                          text: "$userScore",
                          style: const TextStyle(
                              color: ColorHelper.successColor, fontWeight: FontWeight.w900),
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
                      text: StringHelper.wrongAnswersText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                          text: "$wrongAnswersCount",
                          style: const TextStyle(
                              color: ColorHelper.errorColor, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: StringHelper.correctAnswersText,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      children: <TextSpan>[
                        TextSpan(
                          text: "$correctAnswersCount",
                          style: const TextStyle(
                              color: ColorHelper.successColor, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  onEndGamePressed();
                },
                child: const Text(
                  StringHelper.endGameButtonText,
                  style: TextStyle(color: ColorHelper.secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

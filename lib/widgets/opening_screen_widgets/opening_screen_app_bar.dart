import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.purpleAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Image.asset(
            'assets/icon.png', 
            width: 125, 
            height: 125,
          ),
          const SizedBox(height: 40),
          const Text(
            "QuizMaster",
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

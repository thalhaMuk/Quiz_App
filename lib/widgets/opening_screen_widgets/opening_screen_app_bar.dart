import 'package:flutter/material.dart';
import 'package:quiz_app/helpers/string_helper.dart';

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
            StringHelper.appIconPath, 
            width: 125, 
            height: 125,
          ),
          const SizedBox(height: 40),
          const Text(
            StringHelper.appName,
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

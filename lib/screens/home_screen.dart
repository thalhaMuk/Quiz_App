import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/helpers/color_helper.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import 'package:quiz_app/widgets/opening_screen/opening_screen_app_bar.dart';
import '../services/auth/login.dart';
import '../services/auth/logout.dart';
import 'question_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  final User? firebaseUser;
  const HomeScreen({Key? key, this.firebaseUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String user = firebaseUser?.displayName?.split(' ')[0] ??
        StringHelper.defaultUsername;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.35),
        child: const CustomAppBar(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  StringHelper.hiMessage.replaceAll('%s', user),
                  style: const TextStyle(
                      fontSize: 40, color: ColorHelper.primaryColor),
                )),
            const SizedBox(height: 10),
            const Text(
              StringHelper.playNowDescription,
              style: TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(user: firebaseUser),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHelper.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text(
                StringHelper.playNowButtonText,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(user: firebaseUser),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorHelper.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              ),
              child: const Text(
                StringHelper.viewSummaryButtonText,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            if (firebaseUser == null)
              OutlinedButton(
                onPressed: () {
                  Login().signIn(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ColorHelper.primaryColor),
                  textStyle: const TextStyle(color: ColorHelper.primaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
                child: const Text(
                  StringHelper.loginButtonText,
                  style:
                      TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
                ),
              ),
            if (firebaseUser != null)
              OutlinedButton(
                onPressed: () {
                  Logout().signOut(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ColorHelper.primaryColor),
                  textStyle: const TextStyle(color: ColorHelper.primaryColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 65, vertical: 20),
                ),
                child: const Text(
                  StringHelper.logoutButtonText,
                  style:
                      TextStyle(fontSize: 20, color: ColorHelper.primaryColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

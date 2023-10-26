import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../../helpers/dialog_helper.dart';
import '../../screens/home_screen.dart';

class Logout {
  void signOut(BuildContext context) async {
    final googleSignIn = GoogleSignIn();

    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())),
          barrierDismissible: false);
      await googleSignIn.disconnect();
      await FirebaseFirestore.instance.clearPersistence();
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showErrorDialog(context, '${StringHelper.signoutError} $e');
    }
  }
}

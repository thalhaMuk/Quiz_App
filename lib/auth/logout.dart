import 'package:flutter/material.dart';
import 'package:quiz_app/main.dart';
import '../helpers/dialog_helper.dart';

class Logout {
  void signOut(BuildContext context) async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showErrorDialog(
          context, 'Failed to sign out. Please try again later. $e');
    }
  }
}

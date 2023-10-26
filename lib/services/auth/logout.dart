import 'package:flutter/material.dart';
import 'package:quiz_app/helpers/string_helper.dart';
import '../../helpers/dialog_helper.dart';
import '../../screens/home_screen.dart';

class Logout {
  void signOut(BuildContext context) async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showErrorDialog(
          context, '${StringHelper.signoutError} $e');
    }
  }
}

import '../../helpers/import_helper.dart';

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
      await FirebaseFirestore.instance.clearPersistence();
      await FirebaseAuth.instance.signOut();
      await googleSignIn.disconnect();
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

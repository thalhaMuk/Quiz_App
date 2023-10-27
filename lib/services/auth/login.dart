import '../../helpers/import_helper.dart';

class Login {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  void signIn(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) => const Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator())),
          barrierDismissible: false);
      UserCredential userCredential = await signInWithGoogle();
      User? user = userCredential.user;
      if (user != null) {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      DialogHelper.showErrorDialog(
          context, '${StringHelper.signoutError} $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'string_helper.dart';

class FirebaseHelper {
  static Future<dynamic> initializeFirebase(
      String databaseName, User user, Function showErrorDialog) async {
    try {
      var userId = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection(databaseName)
          .where(StringHelper.userIdText, isEqualTo: userId)
          .get();

      return querySnapshot.docs;
    } catch (e) {
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }
}

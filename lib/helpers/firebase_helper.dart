import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'string_helper.dart';

class FirebaseHelper {
  final CollectionReference userScoresRef = FirebaseFirestore.instance
      .collection(StringHelper.userScoresDatabaseName);

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

  Future<int> getTotalScore(String userId) async {
    int totalScore = 0;

    var userDoc = await userScoresRef.doc(userId).get();

    if (userDoc.exists) {
      totalScore = userDoc[StringHelper.totalScore] ?? 0;
    }

    return totalScore;
  }

  Future<void> updateScoreToDatabase(
      String userId, int newTotalScore, Function showErrorDialog) async {
    try {
      var userScoreDoc = await userScoresRef.doc(userId).get();

      if (userScoreDoc.exists) {
        await userScoresRef.doc(userId).update({
          StringHelper.totalScore: newTotalScore,
          StringHelper.timestampText: FieldValue.serverTimestamp(),
        });
      } else {
        await userScoresRef.doc(userId).set({
          StringHelper.userIdText: userId,
          StringHelper.totalScore: newTotalScore,
          StringHelper.timestampText: FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }

  Future<void> saveAnswerHistory(String userId, String question,
      int selectedAnswer, bool isCorrect, Function showErrorDialog) async {
    try {
      await FirebaseFirestore.instance.collection('answerHistory').add({
        StringHelper.userIdText: userId,
        StringHelper.questionText: question,
        StringHelper.selectedAnswerText: selectedAnswer,
        StringHelper.isCorrectText: isCorrect,
        StringHelper.timestampText: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }
}

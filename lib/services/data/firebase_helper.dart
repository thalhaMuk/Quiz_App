import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/logger.dart';
import '../../helpers/string_helper.dart';

class FirebaseService {
  final CollectionReference userScoresRef = FirebaseFirestore.instance
      .collection(StringHelper.userScoresDatabaseName);

  static Future<dynamic> initializeFirebase(
      String databaseName, User user, Function showErrorDialog) async {
    logger.d(StringHelper.startingDatabaseSearch);
    try {
      var userId = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection(databaseName)
          .where(StringHelper.userIdText, isEqualTo: userId)
          .get();
      logger.d(StringHelper.endDatabaseSearch);
      return querySnapshot;
    } catch (e) {
      logger.d(StringHelper.loadingAnswerHistoryErrorMessage);
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }

  static Future<dynamic> getLeaderboarDataFirebase(
      String databaseName, User user, Function showErrorDialog) async {
    logger.d(StringHelper.startingDatabaseSearch);
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(StringHelper.userScoresDatabaseName)
          .orderBy(StringHelper.totalScore, descending: true)
          .get();
      logger.d(StringHelper.endDatabaseSearch);
      return querySnapshot;
    } catch (e) {
      logger.d(StringHelper.loadingLeaderboardError);
      showErrorDialog(StringHelper.loadingLeaderboardError);
    }
  }

  Future<int> getTotalScore(String userId) async {
    logger.d(StringHelper.startingDatabaseSearch);
    int totalScore = 0;
    var userDoc = await userScoresRef.doc(userId).get();

    if (userDoc.exists) {
      totalScore = userDoc[StringHelper.totalScore] ?? 0;
    }
    logger.d(StringHelper.endDatabaseSearch);
    return totalScore;
  }

  Future<void> updateScoreToDatabase(
      String userId, int newTotalScore, Function showErrorDialog) async {
    logger.d(StringHelper.updatingTodatabase);
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
      logger.d(StringHelper.updatedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }

  Future<void> saveAnswerHistory(String userId, String question,
      int selectedAnswer, bool isCorrect, Function showErrorDialog) async {
    logger.d(StringHelper.savingTodatabase);
    try {
      await FirebaseFirestore.instance.collection('answerHistory').add({
        StringHelper.userIdText: userId,
        StringHelper.questionText: question,
        StringHelper.selectedAnswerText: selectedAnswer,
        StringHelper.isCorrectText: isCorrect,
        StringHelper.timestampText: FieldValue.serverTimestamp(),
      });
      logger.d(StringHelper.savedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }
}

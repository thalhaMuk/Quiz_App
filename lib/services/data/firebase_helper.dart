import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helpers/logger.dart';
import '../../helpers/string_helper.dart';

class FirebaseService {
  final CollectionReference userAnswersRef =
      FirebaseFirestore.instance.collection('userAnswers');

  static Future<dynamic> initializeFirebase(
      String databaseName, User user, Function showErrorDialog) async {
    logger.d(StringHelper.startingDatabaseSearch);
    try {
      var userId = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection('userAnswers')
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
          .collection('userAnswers')
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
    var userDoc = await userAnswersRef.doc(userId).get();

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
      var userScoreDoc = await userAnswersRef.doc(userId).get();
      if (userScoreDoc.exists) {
        await userAnswersRef.doc(userId).update({
          StringHelper.totalScore: newTotalScore,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
      logger.d(StringHelper.updatedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }

  Future<void> saveAnswerHistory(String userId, String? username, String question,
      int selectedAnswer, bool isCorrect, Function showErrorDialog, int totalscore) async {
    logger.d(StringHelper.savingTodatabase);
    try {
      await userAnswersRef.doc(userId).set({
        'userId': userId,
        'answerHistory': FieldValue.arrayUnion([
          {
            'isCorrect': isCorrect,
            'question': question,
            'selectedAnswer': selectedAnswer,
            'timestamp': Timestamp.now(),
          },
        ]),
        'totalScore': totalscore + 10,
        'lastUpdated': Timestamp.now(),
        'username': username,
      }, SetOptions(merge: true));

      logger.d(StringHelper.savedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }
}

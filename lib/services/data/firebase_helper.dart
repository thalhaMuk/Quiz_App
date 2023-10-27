import '../../helpers/import_helper.dart';

class FirebaseService {
  final CollectionReference userAnswersRef =
      FirebaseFirestore.instance.collection(ConstantHelper.databaseName);

  static Future<dynamic> initializeFirebase(
      String databaseName, User user, Function showErrorDialog) async {
    logger.d(StringHelper.startingDatabaseSearch);
    try {
      var userId = user.uid;
      var querySnapshot = await FirebaseFirestore.instance
          .collection( ConstantHelper.databaseName)
          .where(ConstantHelper.userIdText, isEqualTo: userId)
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
          .collection( ConstantHelper.databaseName)
          .orderBy(ConstantHelper.totalScore, descending: true)
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
      totalScore = userDoc[ConstantHelper.totalScore] ?? 0;
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
          ConstantHelper.totalScore: newTotalScore,
          ConstantHelper.lastUpdated: FieldValue.serverTimestamp(),
        });
      }
      logger.d(StringHelper.updatedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }

  Future<void> saveAnswerHistory(
      String userId,
      String? username,
      String question,
      int selectedAnswer,
      bool isCorrect,
      Function showErrorDialog,
      int totalscore) async {
    logger.d(StringHelper.savingTodatabase);
    try {
      await userAnswersRef.doc(userId).set({
        ConstantHelper.userIdText: userId,
        ConstantHelper.answerHistory: FieldValue.arrayUnion([
          {
            ConstantHelper.isCorrectText: isCorrect,
            ConstantHelper.questionText: question,
            ConstantHelper.selectedAnswerText: selectedAnswer,
            ConstantHelper.timestampText: Timestamp.now(),
          },
        ]),
        ConstantHelper.totalScore: totalscore + 10,
        ConstantHelper.lastUpdated: Timestamp.now(),
        ConstantHelper.username: username,
      }, SetOptions(merge: true));

      logger.d(StringHelper.savedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
      showErrorDialog(StringHelper.errorText);
    }
  }
}

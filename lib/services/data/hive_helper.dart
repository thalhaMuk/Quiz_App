import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/string_helper.dart';
import '../../models/summary_data.dart';
import '../../helpers/logger.dart';

class HiveService {
  static Future<dynamic> getAnswerHistoryFromHive(
      String databaseName, Function showErrorDialog) async {
    logger.d(StringHelper.startingDatabaseSearch);

    try {
      if (await Hive.boxExists(databaseName)) {
        final answerHistoryBox = Hive.box<LocalAnswerHistory>(databaseName);
        List<LocalAnswerHistory> history = [];

        for (var i = 0; i < answerHistoryBox.length; i++) {
          var localHistory = answerHistoryBox.getAt(i);
          if (localHistory != null) {
            history.add(localHistory);
          }
        }
        logger.d(StringHelper.endDatabaseSearch);
        return history;
      } else {
        return [];
      }
    } catch (e) {
      logger.d(StringHelper.loadingAnswerHistoryErrorMessage);
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }

 Future<int> getTotalScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    logger.d(StringHelper.startingDatabaseSearch);
    int totalScore = prefs.getInt(StringHelper.defaultUsername) ?? 0;
    logger.d(StringHelper.endDatabaseSearch);
    return totalScore;
  }

  Future<void> updateScoreToDatabase(int newTotalScore) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logger.d(StringHelper.updatingTodatabase);
      await prefs.setInt(StringHelper.defaultUsername, newTotalScore);
      logger.d(StringHelper.updatedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
    }
  }

  Future<void> saveAnswerHistory(
      String question, int selectedAnswer, bool isCorrect) async {
    try {
      logger.d(StringHelper.savingTodatabase);
      final answerHistoryBox =
          Hive.box<LocalAnswerHistory>(StringHelper.databaseName);
      final answerHistory = LocalAnswerHistory(
        userId: StringHelper.defaultUsername,
        question: question,
        selectedAnswer: selectedAnswer,
        isCorrect: isCorrect,
        timestamp: DateTime.now(),
      );
      await answerHistoryBox.add(answerHistory);
      logger.d(StringHelper.savedTodatabase);
    } catch (e) {
      logger.d(StringHelper.errorText);
    }
  }
}

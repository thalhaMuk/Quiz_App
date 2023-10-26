import 'package:hive/hive.dart';
import '../models/summary_data.dart';
import 'string_helper.dart';

class HiveHelper {
  static Future<dynamic> getAnswerHistoryFromHive(
      String databaseName, Function showErrorDialog) async {
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

        return history;
      } else {
        return [];
      }
    } catch (e) {
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }

  Future<int> getTotalScore() async {
    int totalScore = 0;
    await Hive.openBox(StringHelper.userScoresDatabaseName);
    var hiveBox = Hive.box(StringHelper.userScoresDatabaseName);
    totalScore = hiveBox.get(StringHelper.defaultUsername) ?? 0;
    hiveBox.close();
    return totalScore;
  }

  Future<void> updateScoreToDatabase(int newTotalScore) async {
    await Hive.openBox(StringHelper.userScoresDatabaseName);
    final scoreBox = Hive.box(StringHelper.userScoresDatabaseName);
    scoreBox.put(StringHelper.defaultUsername, newTotalScore);
  }

  Future<void> saveAnswerHistory(
      String question, int selectedAnswer, bool isCorrect) async {
    if (!await Hive.boxExists(StringHelper.databaseName)) {
      await Hive.openBox(StringHelper.databaseName);
    }
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
  }
}

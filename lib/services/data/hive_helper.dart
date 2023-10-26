import 'package:hive/hive.dart';
import '../../helpers/string_helper.dart';
import '../../models/summary_data.dart';

class HiveService {
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
    var hiveBox = Hive.box<int>(StringHelper.userScoresDatabaseName);
    totalScore = hiveBox.get(StringHelper.defaultUsername) ?? 0;
    return totalScore;
  }

  Future<void> updateScoreToDatabase(int newTotalScore) async {
    final scoreBox = Hive.box<int>(StringHelper.userScoresDatabaseName);
    scoreBox.put(StringHelper.defaultUsername, newTotalScore);
  }

  Future<void> saveAnswerHistory(
      String question, int selectedAnswer, bool isCorrect) async {
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

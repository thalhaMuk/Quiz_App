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
      }
      else {
        return [];
      }
    } catch (e) {
      showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/services/data/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helpers/logger.dart';
import 'helpers/string_helper.dart';
import 'models/summary_data.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  final LocalAnswerHistoryAdapter localAnswerHistoryAdapter =
      LocalAnswerHistoryAdapter();
  Hive.registerAdapter(localAnswerHistoryAdapter);
  await Hive.openBox<LocalAnswerHistory>(StringHelper.databaseName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.d(StringHelper.appStartLogger);
  runApp(const MaterialApp(
    title: StringHelper.appName,
    home: HomeScreen(),
  ));
}

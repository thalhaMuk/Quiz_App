import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/widgets/opening_screen_widgets/opening_screen_app_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login.dart';
import 'auth/logout.dart';
import 'helpers/string_helper.dart';
import 'models/summary_data.dart';
import 'screens/question_screen.dart';
import 'screens/summary_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  final LocalAnswerHistoryAdapter localAnswerHistoryAdapter =
      LocalAnswerHistoryAdapter();
  Hive.registerAdapter(localAnswerHistoryAdapter);
  await Hive.openBox<LocalAnswerHistory>(StringHelper.databaseName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    title: StringHelper.appName,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final User? firebaseUser;
  const MyApp({Key? key, this.firebaseUser}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String user =
        firebaseUser?.displayName?.split('')[0] ?? StringHelper.defaultUsername;
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.35),
          child: const CustomAppBar(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    StringHelper.hiMessage.replaceAll('%s', user),
                    style: const TextStyle(
                        fontSize: 40, color: Colors.purpleAccent),
                  )),
              const SizedBox(height: 10),
              const Text(
                StringHelper.playNowDescription,
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionScreen(user: firebaseUser),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  StringHelper.playNowButtonText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryScreen(user: firebaseUser),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                ),
                child: const Text(
                  StringHelper.viewSummaryButtonText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              if (firebaseUser == null)
                OutlinedButton(
                  onPressed: () {
                    Login().signIn(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purpleAccent),
                    textStyle: const TextStyle(color: Colors.purpleAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 20),
                  ),
                  child: const Text(
                    StringHelper.loginButtonText,
                    style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                  ),
                ),
              if (firebaseUser != null)
                OutlinedButton(
                  onPressed: () {
                    Logout().signOut(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purpleAccent),
                    textStyle: const TextStyle(color: Colors.purpleAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 20),
                  ),
                  child: const Text(
                    StringHelper.logoutButtonText,
                    style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

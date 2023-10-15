import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/opening_screen_widgets/opening_screen_app_bar.dart';
import 'screens/question_screen.dart';

void main() {
 runApp(const MaterialApp(
   title: 'Navigation Basics',
   home: MyApp(),
 ));
}
class MyApp extends StatelessWidget {
  final user = "Name";

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.5),
          child: const CustomAppBar(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hi $user!!",
                style: const TextStyle(fontSize: 40, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 10),
              const Text(
                "Play now and Let's quiz!",
                style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuestionScreen()),
                  );  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
                child: const Text(
                  "Play Now!",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  // Phase 2 content
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.purpleAccent),
                  textStyle: const TextStyle(color: Colors.purpleAccent),
                  padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                ),
                child: const Text(
                  "Login",
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


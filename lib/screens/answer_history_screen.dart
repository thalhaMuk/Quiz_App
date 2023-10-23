import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../widgets/opening_screen_widgets/opening_screen_app_bar.dart';

class AnswerHistory extends StatelessWidget {
  final User? firebaseUser;

  const AnswerHistory({this.firebaseUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = firebaseUser?.uid;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const SliverAppBar(
              expandedHeight: 400.0,
              floating: false,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: CustomAppBar(),
              ),
            ),
          ];
        },
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('answerHistory')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<DocumentSnapshot> answerHistory = snapshot.data!.docs;

            answerHistory.sort((a, b) {
              Timestamp timestampA = a['timestamp'] as Timestamp;
              Timestamp timestampB = b['timestamp'] as Timestamp;
              return timestampB.compareTo(timestampA);
            });

            return ListView.builder(
              itemCount: answerHistory.length,
              itemBuilder: (context, index) {
                var data = answerHistory[index].data() as Map<String, dynamic>;
                var isCorrect = data['isCorrect'] as bool;
                var questionImageUrl = data['question'] as String;
                var selectedAnswer = data['selectedAnswer'] as int;
                var timestamp = data['timestamp'] as Timestamp;

                return LazyLoad(
                  child: AnswerHistoryItem(
                    questionImageUrl: questionImageUrl,
                    selectedAnswer: selectedAnswer,
                    isCorrect: isCorrect,
                    timestamp: timestamp,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(firebaseUser: firebaseUser),
            ),
          );
        },
        label: const Text("Go Back"),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: Colors.purpleAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Rest of your code remains unchanged...

class AnswerHistoryItem extends StatelessWidget {
  final String questionImageUrl;
  final int selectedAnswer;
  final bool isCorrect;
  final Timestamp timestamp;

  const AnswerHistoryItem({
    required this.questionImageUrl,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: isCorrect ? Colors.green : Colors.red),
      ),
      child: Column(
        children: [
          Image.network(questionImageUrl),
          Text('Selected Answer: $selectedAnswer'),
          Text('Correct Answer: ${isCorrect ? "Yes" : "No"}',
              style: TextStyle(color: isCorrect ? Colors.green : Colors.red)),
          Text('Timestamp: ${timestamp.toDate()}'),
        ],
      ),
    );
  }
}

class LazyLoad extends StatefulWidget {
  final Widget child;

  const LazyLoad({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _LazyLoadState createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ? widget.child : const SizedBox.shrink();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/color_helper.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/string_helper.dart';
import '../main.dart';

class LeaderboardScreen extends StatefulWidget {
  final User? user;

  const LeaderboardScreen({Key? key, this.user}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool isLoading = true;
  late List<dynamic> leaderboardList;
  late String username;
  late int totalScore;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _initializeFirebase();
    } else {
      _userNotSignedIn();
    }
  }

  Future<void> _initializeFirebase() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection(StringHelper.userScoresDatabaseName)
          .orderBy(StringHelper.totalScore,
              descending: true)
          .get();

      leaderboardList = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      _showErrorDialog(StringHelper.loadingAnswerHistoryErrorMessage);
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    DialogHelper.showErrorDialog(context, message);
  }

  Widget _buildLeaderboard() {
    return ListView.builder(
      itemCount: leaderboardList.length,
      itemBuilder: (context, index) {
        var localHistory = leaderboardList[index];
        var username = localHistory[StringHelper.username];
        var totalScore = localHistory[StringHelper.totalScore];
        var position = index + 1;
        return LazyLoad(
          child: LeaderboardItem(
            username: username,
            totalScore: totalScore,
            position: position,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.user == null
                ? _userNotSignedIn()
                : _buildLeaderboard(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(firebaseUser: widget.user),
            ),
          );
        },
        label: const Text(StringHelper.goBackText),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: ColorHelper.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _userNotSignedIn() {
    setState(() {
      isLoading = false;
    });
    return const Center(
      child: Text(
        StringHelper.notLoggedInMessage,
        style: TextStyle(fontSize: 20, color: ColorHelper.textColor),
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final String username;
  final int totalScore;
  final int position;

  const LeaderboardItem({
    required this.username,
    required this.totalScore,
    required this.position,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (position == 1) {
      backgroundColor = Colors.deepPurpleAccent;
    } else if (position == 2) {
      backgroundColor = Colors.purpleAccent;
    } else if (position == 3) {
      backgroundColor = Colors.purple;
    } else {
      backgroundColor = Colors.white;
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$position',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$totalScore',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class LazyLoad extends StatefulWidget {
  final Widget child;

  const LazyLoad({super.key, required this.child});

  @override
  State<LazyLoad> createState() => _LazyLoadState();
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

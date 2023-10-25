import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/helpers/firebase_helper.dart';
import '../helpers/color_helper.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/lazy_load.dart';
import '../helpers/leaderboard_item.dart';
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
  void initState() async {
    super.initState();
    if (widget.user != null) {
      leaderboardList = await FirebaseHelper.initializeFirebase(
          StringHelper.userScoresDatabaseName, widget.user!, _showErrorDialog);
      leaderboardList.map((doc) => doc.data()).toList();
    } else {
      _userNotSignedIn();
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
    return const Center(
      child: Text(
        StringHelper.notLoggedInMessage,
        style: TextStyle(fontSize: 20, color: ColorHelper.textColor),
      ),
    );
  }
}

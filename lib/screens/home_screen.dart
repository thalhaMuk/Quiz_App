import '../helpers/import_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? firebaseUser;
  String? user;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String user;
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active &&
              !snapshot.hasData) {
            user = StringHelper.defaultUsername;
          } else if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            firebaseUser = snapshot.data!;
            user = firebaseUser?.displayName?.split(' ')[0] ??
                StringHelper.defaultUsername;
          } else {
            user = StringHelper.defaultUsername;
          }
          return Scaffold(
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
                            fontSize: 40, color: ColorHelper.primaryColor),
                      )),
                  const SizedBox(height: 10),
                  const Text(
                    StringHelper.playNowDescription,
                    style: TextStyle(
                        fontSize: 20, color: ColorHelper.primaryColor),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuestionScreen(user: firebaseUser),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
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
                          builder: (context) =>
                              SummaryScreen(user: firebaseUser),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorHelper.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 20),
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
                        side: const BorderSide(color: ColorHelper.primaryColor),
                        textStyle:
                            const TextStyle(color: ColorHelper.primaryColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 20),
                      ),
                      child: const Text(
                        StringHelper.loginButtonText,
                        style: TextStyle(
                            fontSize: 20, color: ColorHelper.primaryColor),
                      ),
                    ),
                  if (firebaseUser != null)
                    OutlinedButton(
                      onPressed: () {
                        Logout().signOut(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorHelper.primaryColor),
                        textStyle:
                            const TextStyle(color: ColorHelper.primaryColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 65, vertical: 20),
                      ),
                      child: const Text(
                        StringHelper.logoutButtonText,
                        style: TextStyle(
                            fontSize: 20, color: ColorHelper.primaryColor),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
  }
}

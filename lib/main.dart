import 'helpers/import_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  await notificationService.initialize();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  WidgetsBinding.instance.addObserver(notificationService);
  Hive.init(appDocumentDirectory.path);
  final LocalAnswerHistoryAdapter localAnswerHistoryAdapter =
      LocalAnswerHistoryAdapter();
  Hive.registerAdapter(localAnswerHistoryAdapter);
  await Hive.openBox<LocalAnswerHistory>(ConstantHelper.databaseName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  logger.d(StringHelper.appStartLogger);
  runApp(const MaterialApp(
    title: StringHelper.appName,
    home: HomeScreen(),
  ));
}

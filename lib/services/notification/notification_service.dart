import '../../helpers/import_helper.dart';

class NotificationService with WidgetsBindingObserver {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);
    initializeTimeZones();
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(ConstantHelper.androidIconPath);
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cancelNotifications();
    } else if (state == AppLifecycleState.paused) {
      _scheduleNotification();
    }
  }

  void _scheduleNotification() async {
    _timer = Timer(const Duration(seconds: 5), () {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        ConstantHelper.channelId,
        ConstantHelper.channelName,
        importance: Importance.high,
        priority: Priority.high,
        ticker: ConstantHelper.ticker,
      );
      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        ConstantHelper.notificationTitle,
        ConstantHelper.notificationbody,
        TZDateTime.now(local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    });
  }

  void _cancelNotifications() {
    _timer?.cancel();
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}

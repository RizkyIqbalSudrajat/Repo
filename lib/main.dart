import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lji/Register.dart';
import 'package:lji/SignIn.dart';
import 'package:lji/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://drawable/logoes', // Ganti dengan nama ikon aplikasi Anda
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );
  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Android initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('logoes');

  // Initialize settings for Android
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the plugin with the appropriate settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;



  final settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  // It requests a registration token for sending messages to users from your App server or other trusted server environment.
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  runApp(MyApp());
  // Panggil fungsi untuk mengatur tampilan loading
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/', // Rute awal ketika aplikasi dimulai
      routes: {
        '/': (context) => SplashScreen(), // Rute untuk halaman utama aplikasi
        '/login': (context) => SignScreen(), // Rute untuk halaman login
        '/register': (context) => Register(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lji/Admin/Notifikasi/notifikasi.dart';
import 'package:lji/FOR%20USER/HistoryUser/HistoryUser.dart';

class FirebaseNotification {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> configure(BuildContext context) async {
    // Inisialisasi Firebase Messaging
    await _firebaseMessaging.requestPermission();

    // Mendapatkan FCM Token
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Mendengarkan pesan (notifikasi)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Menerima pesan: ${message.notification?.title}");
      // Tampilkan notifikasi menggunakan flutter_local_notifications
      _showNotification(message);
      // Periksa payload dan arahkan pengguna berdasarkan payload
      redirectToPageBasedOnPayload(context, message);
    });
  }

  // Fungsi untuk menampilkan notifikasi
  Future<void> _showNotification(RemoteMessage message) async {
    // Inisialisasi flutter_local_notifications
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logoes');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Ekstrak judul dan pesan notifikasi dari pesan
    String? title = message.notification?.title;
    String? body = message.notification?.body;

    // Konfigurasi detail notifikasi
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id', // ID kanal notifikasi
      'your channel name', // Nama kanal notifikasi
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      // Deskripsi kanal notifikasi diberikan sebagai named argument
      channelDescription: 'your channel description',
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Tampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi
      title, // Judul notifikasi
      body, // Isi notifikasi
      platformChannelSpecifics, // Detail notifikasi
    );
  }

  // Fungsi untuk mengarahkan pengguna ke halaman yang sesuai berdasarkan payload
  Future<void> redirectToPageBasedOnPayload(
      BuildContext context, RemoteMessage message) async {
    try {
      // Dapatkan data payload dari pesan
      Map<String, dynamic>? data = message.data;

      if (data != null && data.containsKey('redirect')) {
        String redirectPage = data['redirect'];

        if (redirectPage == 'admin') {
          // Redirect ke halaman Notifikasi untuk admin
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Notifikasi()),
          );
        } else {
          // Dapatkan data pengguna dari database berdasarkan FCM token
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          DocumentSnapshot? userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('fcmToken', isEqualTo: fcmToken)
              .get()
              .then((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              return snapshot.docs.first;
            } else {
              return null;
            }
          });

          if (userSnapshot != null && userSnapshot.exists) {
            // Dapatkan user ID dari dokumen pengguna
            String userId = userSnapshot['user_id'];
            // Redirect ke halaman Riwayat untuk pengguna
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RiwayatUser(userId: userId)),
            );
          } else {
            print('User tidak ditemukan');
            // Handle case di mana user tidak ditemukan
          }
        }
      }
    } catch (e) {
      print('Error: $e');
      // Handle error jika terjadi kesalahan saat mengolah payload
    }
  }
}

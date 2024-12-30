import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lji/Admin/Dashboard/dashboard.dart';
import 'package:lji/FOR%20USER/BagianDashboard.dart';
import 'package:lji/SignIn.dart';
import 'package:lji/styles/dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;
  var internetDialogShown = false;
  late Stream<User?> _authStateStream;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  void dispose() {
    _authStateStream.drain();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void checkIfLogin() async {
    _authStateStream = auth.authStateChanges();
    _authStateStream.listen((User? user) {
      if (mounted) {
        setState(() {
          isLogin = user != null;
        });
        navigateToNextScreen(user);
      }
    });
  }

  void initializeApp() async {
    bool isConnected = await checkInternetConnection();
    if (!isConnected) {
      await waitForInternetConnection();
    } else {
      checkIfLogin();
    }
  }

  Future<void> waitForInternetConnection() async {
    if (!internetDialogShown) {
      internetDialogShown = true;
      showDialog(
        context: context,
        builder: (context) => LostConnect(
          title: "Tidak Ada Koneksi Internet",
          content:
              "Maaf, sepertinya anda tidak terhubung ke internet saat ini. Pastikan anda terhubung ke jaringan wifi atau data saluler",
        ),
      );
    }

    while (true) {
      await Future.delayed(Duration(seconds: 3)); // Check every second
      bool isConnected = await checkInternetConnection();
      if (isConnected) {
        Navigator.pop(context); // Close the dialog
        internetDialogShown = false;
        break;
      }
    }

    initializeApp();
  }

  void navigateToNextScreen(User? user) async {
  if (user != null && isLogin) {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userSnapshot.exists) {
      String role = userSnapshot['role'];
      if (role == 'admin') {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        });
      } else {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuUser()),
          );
        });
      }
    } else {
      // Handle the case where the document doesn't exist
      print("Document does not exist for user ${user.uid}");
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignScreen()),
        );
      });
    }
  } else {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignScreen()),
      );
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1, -1.031),
            end: Alignment(1, 1),
            colors: <Color>[Color(0xffa5cd14), Color(0xff55bc15)],
            stops: <double>[0.285, 0.837],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .4,
            child: Image.asset(
              "assets/Logoes.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

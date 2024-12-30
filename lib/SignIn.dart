import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lji/DataBasePHPMYSQL/TextFieldLogin.dart';
import 'package:lji/DataBasePHPMYSQL/passwordtextfield.dart';
import 'package:lji/Admin/Dashboard/dashboard.dart';
import 'package:lji/FOR%20USER/BagianDashboard.dart';
import 'package:lji/Register.dart';
import 'package:lji/styles/dialog.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance; // Tambahkan baris ini

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: screenWidth,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -1),
                end: Alignment(0, 1),
                colors: <Color>[Color(0xffa5cd14), Color(0xffffffff)],
                stops: <double>[0, 0.875],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                  width: screenWidth,
                  height: 140 + MediaQuery.of(context).padding.horizontal,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Warung Sembako",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 20, 15, 13),
                  padding: EdgeInsets.fromLTRB(28, 20, 28, 20),
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x499c9c9c),
                        offset: Offset(0, 0),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff5cc818),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 5, 0, 35),
                          child: Text(
                            'Masukan email dan password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        LoginInput(
                          hintText: "Email",
                          textController: emailController,
                          leftIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mohon isi email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RegisterInput(
                          hintText: "Password",
                          textController: passwordController,
                          leftIcon: Icons.lock,
                          isObsecure: !isPasswordVisible,
                          rightIcon: isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onRightconPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mohon isi password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Loading(
                                      title: 'Loading', isLoading: true);
                                },
                              );

                              try {
                                String enteredEmail =
                                    emailController.text.trim();
                                String enteredPassword =
                                    passwordController.text.trim();

                                final userSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('email', isEqualTo: enteredEmail)
                                    .get();

                                if (userSnapshot.docs.isEmpty) {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => WarningDialog(
                                      title: "Warning",
                                      content:
                                          "Email atau kata sandi Anda salah. Silakan coba lagi atau daftar jika Anda belum memiliki akun",
                                      buttonConfirm: 'Tutup',
                                      onButtonConfirm: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                  return;
                                }

                                UserCredential userCredential =
                                    await _auth.signInWithEmailAndPassword(
                                  email: enteredEmail,
                                  password: enteredPassword,
                                );

                                if (userCredential.user != null) {
                                  DocumentSnapshot userSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userCredential.user!.uid)
                                          .get();

                                  String role = userSnapshot['role'];
                                  String storedFcmToken =
                                      userSnapshot['fcmToken'];

                                  // Get FCM token
                                  String? fcmToken =
                                      await _firebaseMessaging.getToken();

                                  if (fcmToken != null &&
                                      fcmToken != storedFcmToken) {
                                    // Update the stored FCM token in Firestore
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .update({'fcmToken': fcmToken});
                                  }

                                  if (role == 'admin') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Dashboard(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuUser(),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                print('Error: $e');
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => WarningDialog(
                                          title: "Error",
                                          content:
                                              "Email atau kata sandi Anda salah",
                                          buttonConfirm: 'OK',
                                          onButtonConfirm: () {
                                            Navigator.pop(context);
                                          },
                                        ));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * .7, 40),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.2125,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum memiliki akun ?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              // Navigates to the registration screen
                              // You can implement your registration screen here

                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

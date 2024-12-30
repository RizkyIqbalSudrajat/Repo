import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lji/FOR%20USER/BagianDashboard.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/DataBasePHPMYSQL/passwordtextfield.dart';
import 'package:lji/DataBasePHPMYSQL/TextFieldLogin.dart';
import 'package:lji/SignIn.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final usernameController = TextEditingController();

  bool isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mendapatkan token FCM ketika widget pertama kali dibuat
    _getFcmToken();
  }

  Future<void> _getFcmToken() async {
    String? fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');
  }

  void insertUserToFirebase(
      String email, String username, String uid, String fcmToken) {
    // Implementasi penyimpanan pengguna ke Firebase
    // Anda dapat menggunakan Firestore atau Realtime Database, tergantung pada preferensi Anda
    // Di sini, saya akan memberikan contoh menggunakan Firestore

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'email': email,
          'username': username,
          'role': 'user',
          'user_id': uid,
          'fcmToken': fcmToken // Menambahkan fcmToken ke data pengguna
        }) // Menambahkan username ke Firestore
        .then((value) => print("User added to Firebase"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: MediaQuery.of(context).size.height,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            'Daftar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
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
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                        LoginInput(
                          hintText: "Username",
                          textController: usernameController,
                          leftIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mohon isi nama Anda";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
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
                          height: 15,
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
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                String enteredUsername =
                                    usernameController.text.trim();
                                String enteredEmail =
                                    emailController.text.trim();
                                String enteredPassword =
                                    passwordController.text.trim();

                                // Membuat akun baru dengan email dan password
                                UserCredential userCredential =
                                    await _auth.createUserWithEmailAndPassword(
                                  email: enteredEmail,
                                  password: enteredPassword,
                                );

                                // Check apakah pembuatan akun berhasil
                                if (userCredential.user != null) {
                                  String uid = userCredential.user!.uid;

                                  // Get FCM token
                                  String? fcmToken =
                                      await _firebaseMessaging.getToken();

                                  // Check if FCM token is available
                                  if (fcmToken != null) {
                                    // Call insertUserToFirebase with all required arguments
                                    insertUserToFirebase(
                                      enteredEmail,
                                      enteredUsername,
                                      uid,
                                      fcmToken,
                                    );

                                    // Proceed with navigation
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuUser(),
                                      ),
                                    );
                                  } else {
                                    // Handle case where FCM token is null
                                    // You can show an error message or retry obtaining the token
                                  }
                                } else {
                                  // Handle case where userCredential.user is null
                                  // You may want to display an error message or handle the failure differently
                                }
                              } catch (e) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Gagal Membuat Akun'),
                                      content: Text(
                                          'Terjadi kesalahan saat membuat akun. Silakan coba lagi.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                print('Error: $e');
                                // Handle error, seperti menampilkan pesan kesalahan kepada pengguna
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * .7, 40),
                            backgroundColor: greenPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Daftar',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
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
                              'Sudah memiliki akun ?',
                              style: GoogleFonts.poppins(
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
                                        builder: (context) => SignScreen()));
                              },
                              // Navigates to the registration screen
                              // You can implement your registration screen here

                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

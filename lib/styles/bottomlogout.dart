import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutBottomSheet {
static void show(BuildContext context, AuthService authService) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 25),
              child: Text(
                'Apakah kamu yakin ingin logout?',
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceAround, // Mengatseur ruang di antara tombol
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Pop the bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    // Warna latar belakang tombol
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth.signOut(); // Sign out the user
                      authService.logoutUser();
                      Navigator.pop(context); // Pop the bottom sheet
                      // Navigate to the sign-in page
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    } catch (e) {
                      print("Error signing out: $e");
                      // Handle sign-out errors
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xff49A013), // Warna latar belakang tombol
                  ),
                  child: Text(
                    'Oke',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  ).then((value) {
    // Setelah bottom sheet tertutup, lakukan pekerjaan lainnya di sini
  });
}}

class AuthService {
  bool isLoggedIn = false;

  // Instance method to set the isLoggedIn status
  void loginUserAndSetStatus(bool status) {
    isLoggedIn = status;
  }

  // Instance method to update isLoggedIn status during logout
  void logoutUser() {
    isLoggedIn = false;
  }
}

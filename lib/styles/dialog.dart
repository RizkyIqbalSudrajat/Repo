import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lji/styles/button.dart';
import 'package:lji/styles/color.dart';
import 'package:lji/styles/font.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonCancel;
  final VoidCallback onButtonCancel;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const DeleteDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonCancel,
      required this.onButtonCancel,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
                padding: EdgeInsets.symmetric(vertical: 22),
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: redPrimary, // Ganti warna sesuai keinginan
                ),
                child: Image.asset(
                  "assets/Warning.png",
                )),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: redPrimary)),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonCancel,
                          child: Text(
                            buttonCancel,
                            style: textdialog,
                          ),
                          style: kuningButton),
                      ElevatedButton(
                        onPressed: onButtonConfirm,
                        child: Text(
                          buttonConfirm,
                          style: textdialog,
                        ),
                        style: redButton,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TerimaDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonCancel;
  final VoidCallback onButtonCancel;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const TerimaDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonCancel,
      required this.onButtonCancel,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
              padding: EdgeInsets.symmetric(vertical: 22),
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: greenPrimary // Ganti warna sesuai keinginan
                  ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: greenPrimary)),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonCancel,
                          child: Text(
                            buttonCancel,
                            style: textdialog,
                          ),
                          style: redButton),
                      ElevatedButton(
                        onPressed: onButtonConfirm,
                        child: Text(
                          buttonConfirm,
                          style: textdialog,
                        ),
                        style: greenButton,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LostConnect extends StatelessWidget {
  final String title;
  final String content;

  const LostConnect({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
                padding: EdgeInsets.symmetric(vertical: 22),
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.red, // Ganti warna sesuai keinginan
                ),
                child: Image.asset(
                  "assets/lost.png",
                )),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SucessDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const SucessDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color.fromRGBO(
                    73, 160, 19, 1), // Ganti warna sesuai keinginan
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: greenPrimary)),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonConfirm,
                          child: Text(
                            buttonConfirm,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                          style: greenButton)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String title;
  final bool isLoading; // Add isLoading as a parameter

  const Loading({
    Key? key,
    required this.title,
    required this.isLoading, // Pass isLoading to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show loading dialog when isLoading is true
    if (isLoading) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitWave(
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 30), // Spacer antara SpinKitWave dan teks
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )

              // Kotak atas dengan logo peringatan
              // Spasi antara kotak atas dan bawah
              // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            ],
          ),
        ),
      );
    } else {
      return SizedBox
          .shrink(); // Return an empty SizedBox when isLoading is false
    }
  }
}

class ACC_ADMIN extends StatelessWidget {
  final String title;
  final String content;
  final String buttonCancel;
  final VoidCallback onButtonCancel;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const ACC_ADMIN(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonCancel,
      required this.onButtonCancel,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
                padding: EdgeInsets.symmetric(vertical: 22),
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: greenPrimary, // Ganti warna sesuai keinginan
                ),
                child: Image.asset(
                  "assets/Warning.png",
                )),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: greenPrimary),
                          textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonCancel,
                          child: Text(
                            buttonCancel,
                            style: textdialog,
                          ),
                          style: redButton),
                      ElevatedButton(
                        onPressed: onButtonConfirm,
                        child: Text(
                          buttonConfirm,
                          style: textdialog,
                        ),
                        style: greenButton,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeranjangButton extends StatelessWidget {
  final String title;
  final String content;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const KeranjangButton(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color.fromRGBO(
                    73, 160, 19, 1), // Ganti warna sesuai keinginan
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 70,
              ),
            ),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: greenPrimary)),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonConfirm,
                          child: Text(
                            buttonConfirm,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                          style: greenButton)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarningDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonConfirm;
  final VoidCallback onButtonConfirm;
  const WarningDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.buttonConfirm,
      required this.onButtonConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak atas dengan logo peringatan
            Container(
                padding: EdgeInsets.symmetric(vertical: 22),
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Color.fromARGB(
                      255, 255, 174, 0), // Ganti warna sesuai keinginan
                ),
                child: Image.asset(
                  "assets/Warning.png",
                )),
            SizedBox(height: 16), // Spasi antara kotak atas dan bawah
            // Kotak bawah dengan konfirmasi dan deskripsi peringatan
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 174, 0))),
                  SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: onButtonConfirm,
                          child: Text(
                            buttonConfirm,
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.white),
                          ),
                          style: redButton)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

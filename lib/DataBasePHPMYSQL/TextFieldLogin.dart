import 'package:flutter/material.dart';
import 'package:lji/styles/color.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginInput extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? leftIcon;
  final bool isObsecure;
  final VoidCallback? onLeftIconPressed;
  final String? Function(String?)? validator;

  const LoginInput({
    Key? key,
    required this.hintText,
    this.isObsecure = false,
    this.leftIcon,
    required this.textController,
    this.onLeftIconPressed,
    this.validator,
  }) : super(key: key);

  @override
  State<LoginInput> createState() => LoginInputState();
}

class LoginInputState extends State<LoginInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: greenPrimary,
      style: GoogleFonts.poppins(fontSize: 12),
      obscureText: widget.isObsecure,
      controller: widget.textController,
      validator: widget.validator,
      decoration: InputDecoration(
          counterText: '',
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          hintStyle: GoogleFonts.poppins(fontSize: 12),
          prefixIcon: Icon(widget.leftIcon, color: Color(0xff49A013)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.black12, // Default border color
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Colors.black, // Default border color
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color:
                  const Color.fromRGBO(73, 160, 19, 1), // Desired focus color
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle:
              GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400)),
      maxLength: 50,
    );
  }
}

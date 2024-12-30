import 'package:flutter/material.dart';
import 'package:lji/styles/color.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterInput extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isObsecure;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightconPressed;
  final String? Function(String?)? validator;

  const RegisterInput(
      {Key? key,
      required this.hintText,
      this.isObsecure = false,
      this.leftIcon,
      this.rightIcon,
      required this.textController,
      this.onLeftIconPressed,
      this.onRightconPressed,
      this.validator})
      : super(key: key);

  @override
  State<RegisterInput> createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: greenPrimary,
      obscureText: widget.isObsecure,
      controller: widget.textController,
      validator: widget.validator,
      style: GoogleFonts.poppins(fontSize: 12),
      decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(
            vertical: 2,
          ),
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 12),
          prefixIcon: Icon(widget.leftIcon, color: Color(0xff49A013)),
          suffixIcon: InkWell(
            onTap: () {
              if (widget.onRightconPressed != null) ;
              {
                widget.onRightconPressed!();
              }
            },
            child: Icon(widget.rightIcon, color: Color(0xff49A013)),
          ),
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

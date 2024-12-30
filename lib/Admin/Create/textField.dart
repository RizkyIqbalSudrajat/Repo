// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lji/styles/color.dart';
import 'package:flutter/services.dart';

class CustomNumberField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomNumberField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final text = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText',
          style: text,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          cursorColor: greenPrimary,
          style: text,
          controller: controller,
          validator: validator,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ], // hanya angka
          keyboardType: TextInputType.number, // tipe keyboard angka
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color:
                    const Color.fromRGBO(73, 160, 19, 1), // Desired focus color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: textField,
          ),
        ),
      ],
    );
  }
}
class CustomPercentageField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomPercentageField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textFieldStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final textStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: textStyle,
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          style: textStyle,
          validator: validator,
          cursorColor: Colors.green,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
            _MaxValueInputFormatter(100),
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // Add '%' symbol dynamically
            if (value.isNotEmpty && !value.contains('%')) {
              controller.text = '$value%';
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length - 1),
              );
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            hintText: hintText,
            hintStyle: textFieldStyle,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromRGBO(73, 160, 19, 1)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCurrencyField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomCurrencyField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final text = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText',
          style: text,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          cursorColor: greenPrimary,
          style: text,
          controller: controller,
          validator: validator,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ], // hanya angka
          keyboardType: TextInputType.number, // tipe keyboard angka
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: const Color.fromRGBO(73, 160, 19, 1), // Desired focus color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: textField,
          ),
        ),
      ],
    );
  }
}


class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final text = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText',
          style: text,
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          cursorColor: greenPrimary,
          style: text,
          controller: controller,
          validator: validator, // hanya angka
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color:
                    const Color.fromRGBO(73, 160, 19, 1), // Desired focus color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: textField,
          ),
        ),
      ],
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String labelText;
  final List<String> dropdownValues;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    Key? key,
    required this.labelText,
    required this.dropdownValues,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final text = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    final fieldCreate = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 240, 240, 240));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText',
          style: text,
        ),
        SizedBox(
          height: 5,
        ),
        DropdownButtonFormField(
          validator: validator,
          isExpanded: true,
          value: controller.text.isNotEmpty ? controller.text : null,
          onChanged: (newValue) {
            // Add any additional logic if needed
            controller.text = newValue.toString();
          },
          items: dropdownValues.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: text,
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black12, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black, // Default border color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color:
                    const Color.fromRGBO(73, 160, 19, 1), // Desired focus color
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            hintStyle: textField,
          ),
        ),
      ],
    );
  }
}

class CustomDatePickerField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomDatePickerField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textField = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black26,
    );
    final text = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    // Function to pick the date using DatePicker with custom styling
    void _selectDate(BuildContext context) async {
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primaryColor: greenPrimary, // Header background color
              colorScheme: ColorScheme.light(
                primary: greenPrimary, // Header text and active elements
                onPrimary: Colors.white, // Text color on header
                onSurface: Colors.black, // Body text color
              ),
              textTheme: TextTheme(
                headlineMedium: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                titleLarge: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: greenPrimary,
                ),
              ),
              dialogBackgroundColor: Colors.white, // Dialog background color
            ),
            child: child!,
          );
        },
      );

      if (selectedDate != null) {
        controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$labelText',
          style: text,
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () => _selectDate(context), // Open date picker when tapped
          child: AbsorbPointer( // Prevent manual typing
            child: TextFormField(
              controller: controller,
              validator: validator,
              cursorColor: greenPrimary,
              style: text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                hintText: hintText,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black12, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black, // Default border color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(73, 160, 19, 1), // Desired focus color
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: textField,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _MaxValueInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text.replaceAll('%', ''); // Remove '%' if present
    if (newText.isEmpty) return newValue;

    final newValueInt = int.tryParse(newText);
    if (newValueInt != null && newValueInt > maxValue) {
      return oldValue; // Reject new value if greater than maxValue
    }

    return newValue;
  }
}
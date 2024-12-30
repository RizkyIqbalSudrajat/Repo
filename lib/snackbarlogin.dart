import 'package:get/get.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(String message,
    {bool isError = true, String title = 'Error'}) {
  Get.snackbar(
      backgroundColor: Colors.red,
      title,
      message,
      titleText: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.black,
        ),
      ));
}

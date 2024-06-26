import 'package:flutter/material.dart';

SnackBar getSnackBar(String message, double paddingX, double liftup, bool success) {
  return SnackBar(
    backgroundColor: success ? Colors.lightGreen.shade400 : const Color(0xFFF5F5F5),
    // backgroundColor: success ? Colors.lightGreen.shade400 : Colors.amber.shade400,
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.black),
    ),
    duration: const Duration(milliseconds: 1500),
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 5
    ),
    dismissDirection: DismissDirection.up,
    margin: EdgeInsets.only(bottom: liftup, left: paddingX, right: paddingX),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    elevation: 0,
  );
}

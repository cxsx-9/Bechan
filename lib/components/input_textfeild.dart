// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class InputTextFeild extends StatelessWidget {
  final dynamic controller;
  final String infoText;
  final String hintText;
  final bool obscureText;

  const InputTextFeild({
    super.key,
    required this.controller,
    required this.infoText,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              // backgroundColor: Colors.amberAccent,
              ),
            infoText
          ),
          const SizedBox(height: 2,),
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black26)
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14)
            ),
          ),
        ],
      )
    );
  }
}
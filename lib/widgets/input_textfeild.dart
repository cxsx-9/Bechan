import 'package:flutter/material.dart';

class InputTextFeild extends StatefulWidget {
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
  State<InputTextFeild> createState() => _InputTextFeildState();
}

class _InputTextFeildState extends State<InputTextFeild> {
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
              ),
            widget.infoText
          ),
          const SizedBox(height: 2,),
          TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black26),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.black),
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14)
            ),
          ),
        ],
      )
    );
  }
}
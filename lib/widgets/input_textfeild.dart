import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class InputTextFeild extends StatefulWidget {
  final dynamic controller;
  final String infoText;
  final String hintText;
  final bool obscureText;
  bool obscure;

  InputTextFeild({
    super.key,
    required this.controller,
    required this.infoText,
    required this.hintText,
    required this.obscureText,
    bool ? obscure
  }) 
  :
    obscure = obscureText
  ;

  @override
  State<InputTextFeild> createState() => _InputTextFeildState();
}

class _InputTextFeildState extends State<InputTextFeild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            widget.infoText),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          height: 40,
          child: TextField(
            onSubmitted: (value) => {
              
            },
            controller: widget.controller,
            obscureText: widget.obscure,
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
              hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
              suffixIcon: widget.obscureText ? IconButton(
                  icon:
                  FaIcon(
                    widget.obscure
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye
                    ,size: 17,
                    color: Colors.black26,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.obscure = !widget.obscure;
                    });
                  }) : null,
            ),
          ),
        ),
      ],
    );
  }
}

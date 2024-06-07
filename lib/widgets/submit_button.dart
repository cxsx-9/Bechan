import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final Function()? onTap;
  final String btnText;
  final int type;

  const SubmitButton(
      {super.key,
      required this.onTap,
      required this.btnText,
      required this.type});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    Color bgColor = Colors.black;
    bool borderLine = true;
    if (widget.type == 0) {
      textColor = Colors.white70;
      bgColor = Colors.black38;
    } else if (widget.type == 1) {
      textColor = Colors.white;
      bgColor = Colors.black;
    } else if (widget.type == 2) {
      textColor = Colors.black;
      bgColor = Colors.white;
      borderLine = false;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 55),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border:
                borderLine ? null : Border.all(width: 2, color: Colors.black),
            boxShadow: widget.type == 0
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              widget.btnText,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
            ),
          )),
    );
  }
}

class IconSubmitButton extends StatefulWidget {
  final Function()? onTap;
  final IconData icondata;
  final int type;
  const IconSubmitButton(
      {super.key,
      required this.onTap,
      required this.icondata,
      required this.type});

  @override
  State<IconSubmitButton> createState() => _IconSubmitButtonState();
}

class _IconSubmitButtonState extends State<IconSubmitButton> {
  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    Color bgColor = Colors.black;
    bool borderLine = true;
    if (widget.type == 0) {
      textColor = Colors.white24;
      bgColor = Colors.black26;
    } else if (widget.type == 1) {
      textColor = Colors.white;
      bgColor = Colors.black;
    } else if (widget.type == 2) {
      textColor = Colors.black;
      bgColor = Colors.white;
      borderLine = false;
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          width: 65,
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border:
                borderLine ? null : Border.all(width: 2, color: Colors.black),
            boxShadow: widget.type == 0 ? null : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icondata,
              color: textColor,
              size: 25,
            ),
          )),
    );
  }
}

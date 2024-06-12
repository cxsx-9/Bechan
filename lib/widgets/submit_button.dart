import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final Function()? onTap;
  final int type;
  final String btnText;
  final IconData ? icon;

  const SubmitButton(
      {super.key,
      required this.onTap,
      required this.type,
      String? btnText,
      IconData? icon
      }) : 
      icon = icon ?? null,
      btnText = btnText ?? ""
      ;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onPrimary;
    Color bgColor =  Theme.of(context).colorScheme.primary;
    Color shadow = Colors.black38;
    bool borderLine = true;
    if (widget.type == 0) {
      textColor = Theme.of(context).colorScheme.onSecondary;
      bgColor = Theme.of(context).colorScheme.secondary;
    } else if (widget.type == 1) {
      textColor = Theme.of(context).colorScheme.onPrimary;
      bgColor =  Theme.of(context).colorScheme.primary;
    } else if (widget.type == 2) {
      textColor = Theme.of(context).colorScheme.primary;
      bgColor = Theme.of(context).colorScheme.onPrimary;
      borderLine = false;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 55),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border:
              borderLine ? null : Border.all(width: 2, color: textColor, strokeAlign: BorderSide.strokeAlignOutside),
            boxShadow: widget.type == 0
                ? null
                : [
                    BoxShadow(
                      color: shadow,
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: widget.icon == null ? 
              Text(
                widget.btnText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),              
              ) :
              Icon(
                widget.icon,
                color: textColor,
                size: 25,
              ),
          )
        ),
    );
  }
}

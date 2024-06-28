import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextAndHighlight extends StatelessWidget {
  final String text;
  final String highlight;
  final bool link;
  final Function()? onTap;

  const TextAndHighlight ({
    super.key,
    required this.text,
    required this.highlight,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child:Text(
            highlight,
            style: TextStyle(
              color: link ? Colors.blueAccent : Colors.black,
              fontWeight: FontWeight.w600,
              backgroundColor: link ? Colors.transparent : Colors.amber.shade300,
            ),
          ),
        )
      ],
    );
  }
}
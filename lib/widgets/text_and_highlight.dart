import 'package:flutter/material.dart';

class TextAndHighlight extends StatelessWidget {
  final String text;
  final String highlight;

  const TextAndHighlight ({
    super.key,
    required this.text,
    required this.highlight,
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
        Text(
          highlight,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            backgroundColor: Colors.amber.shade300,
          ),
        ),
      ],
    );
  }
}
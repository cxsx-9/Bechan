import 'package:flutter/material.dart';

class TextInfo extends StatelessWidget{
  final topic;
  final info;

  const TextInfo ({
    super.key,
    required this.info,
    required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          topic,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 15,),
        Text(info),
      ]
    );
  }
}
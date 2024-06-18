import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigCard extends StatelessWidget {
  final String topic;
  final String data;
  
  const BigCard ({
    super.key,
    String ? topic,
    String ? data,
  }) : topic = topic ?? '?',
    data = data ?? 'Nothing'
  ;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 500,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )]
        ),
        // DATA HERE
      ),
    );
  }
}

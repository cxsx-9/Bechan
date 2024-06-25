import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TinyCards extends StatelessWidget {
  final String topic;
  final String data;
  final Color color;
  final Color backgroundColor;
  
  const TinyCards ({
    super.key,
    String ? topic,
    String ? data,
    Color ? color,
    Color ? backgroundColor
  }) : topic = topic ?? '?',
    data = data ?? '00.00',
    color = color ?? Colors.black,
    backgroundColor = backgroundColor ?? Colors.white
  ;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 90,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              topic,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              )
            ),
            Text(
              data,
              style: GoogleFonts.inter(
                fontSize: data.length < 10 ? 18 : 14,
                color: color,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallCard extends StatelessWidget {
  final String topic;
  final String data;
  
  const SmallCard ({
    super.key,
    String ? topic,
    String ? data,
  }) : topic = topic ?? '?',
    data = data ?? '00.00'
  ;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 90,
      child: Container(
        decoration: cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              topic,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            Text(
              data,
              style: GoogleFonts.inter(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

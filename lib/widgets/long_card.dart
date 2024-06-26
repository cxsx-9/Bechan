import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LongCard extends StatelessWidget {
  final String topic;
  final String data;
  
  const LongCard ({
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
      height: 60,
      child: Container(
        decoration: cardDecoration(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    topic,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ),
                  const SizedBox(width: 10,),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16,),
                ],
              ),
              Text(
                data,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

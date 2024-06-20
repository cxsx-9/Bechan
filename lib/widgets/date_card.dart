import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final DateTime time;
  DateCard ({
    super.key,
    required this.time
  });

  final String date = DateFormat('dd').format(DateTime.now());
  final String month = DateFormat('MMMM').format(DateTime.now());
  final String year = DateFormat('yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 90,
      child: Container(
        decoration: CardDecoration(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ),
                  Text(
                    year,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

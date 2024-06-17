import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallProfileCard extends StatelessWidget {
  final String firstname;
  final String greeting;
  
  const SmallProfileCard ({
    super.key,
    required this.firstname,
    required this.greeting,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/default_profile_image.png',
                    height: 48,
                    width: 48,
                  ),
                ],
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstname,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    ),
                    Text(
                      greeting,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

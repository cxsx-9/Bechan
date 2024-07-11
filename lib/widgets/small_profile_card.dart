import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class SmallProfileCard extends StatelessWidget {
  final String firstname;
  final String email;
  final String greeting;
  final String profilePath;
  
  const SmallProfileCard ({
    super.key,
    required this.firstname,
    required this.email,
    required this.profilePath,
    required this.greeting,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 90,
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
              SizedBox(
                width: 48,
                height: 48,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    '${config.BASE_URL}/$profilePath'
                  ),
                ),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      firstname,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    ),
                    Text(
                      greeting,
                      style: TextStyle(
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

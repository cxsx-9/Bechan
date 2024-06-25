import 'package:flutter/material.dart';

class NoTransaction extends StatelessWidget{
  const NoTransaction({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/dance.webp',
            height: 120,
          ),
          const Text(
            "No transactions today?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5,),
          const Text(
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              // color: Theme.of(context).colorScheme.secondary
            ),
            textAlign: TextAlign.center,
            "That's awesome!\nMaybe you're saving like a pro!",
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
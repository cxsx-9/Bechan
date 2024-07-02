import 'package:flutter/material.dart';

class NoTransaction extends StatelessWidget{
  final dynamic snapshot;
  const NoTransaction({super.key, dynamic snapshot}) : snapshot = snapshot ?? null;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset(
            'assets/dance.webp',
            height: 120,
          ),
          Text(
            !snapshot.hasError
            ? "No transactions today?"
            : "offline",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            !snapshot.hasError
            ? "That's awesome!\nMaybe you're saving like a pro!"
            : 'You are Not Connected to the Internet \n\n${snapshot.error}'
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Tap to start :)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
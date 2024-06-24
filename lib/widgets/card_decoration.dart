import 'package:flutter/material.dart';

BoxDecoration cardDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.onPrimary,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow,
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 2),
      )
    ]
  );
}

import 'package:flutter/material.dart';

class ListCategory extends StatelessWidget {
  final String name;
  final String type;


  const ListCategory({
    required this.name,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: Theme.of(context).colorScheme.secondary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            name,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15
            ),
          ),
        ),
      ),
    );
  }
}
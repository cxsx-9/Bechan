import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String text;
  final bool selected;
  final Color backgroundColor;
  final Color selectedColor;

  const CustomChip({
    super.key, 
    required this.text,
    required this.selected,
    required this.backgroundColor,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? selectedColor : backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
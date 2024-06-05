import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function()? onTap;
  const SubmitButton({
    super.key,
    required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 55),
        decoration: const BoxDecoration(
          color : Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: const Center(
          child: Text(
            "SignText",
            style: TextStyle(color: Colors.white),
          ),
        )
      ),
    );
  }
}
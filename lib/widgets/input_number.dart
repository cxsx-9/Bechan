import 'package:flutter/material.dart';

class InputNumber extends StatelessWidget{
  final dynamic controller;
  final String hintText;
  final String infoText;

  const InputNumber({super.key, required this.controller, String ? hintText, String ? infoText}) 
  : hintText = hintText ?? "", infoText = infoText ?? "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          infoText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          height: 70,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 30, fontWeight: FontWeight.w200),
            ),
          ),
        ),
      ],
    ); 
  }
}
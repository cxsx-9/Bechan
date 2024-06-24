import 'package:flutter/material.dart';

class InputNumber extends StatefulWidget{
  final dynamic controller;
  final String hintText;
  final String infoText;
  final String initialValue;

  const InputNumber({super.key, required this.controller, String ? hintText, String ? infoText, String ? initialValue}) 
  : hintText = hintText ?? "", infoText = infoText ?? "", initialValue = initialValue ?? "";

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  @override
  void initState() {
    if (widget.initialValue != '') {
      widget.controller.text = widget.initialValue;
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.infoText,
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
            controller: widget.controller,
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
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 30, fontWeight: FontWeight.w200),
            ),
          ),
        ),
      ],
    ); 
  }
}
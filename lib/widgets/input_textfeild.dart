import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class InputTextFeild extends StatefulWidget {
  final dynamic controller;
  final String infoText;
  final String hintText;
  final bool obscureText;
  bool obscure;
  String errorText;

  InputTextFeild(
      {super.key,
      required this.controller,
      required this.infoText,
      required this.hintText,
      required this.obscureText,
      bool? obscure,
      String? errorText})
      : obscure = obscureText,
        errorText = errorText ?? "";

  @override
  State<InputTextFeild> createState() => _InputTextFeildState();
}

class _InputTextFeildState extends State<InputTextFeild> {
  bool isValid = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            widget.infoText),
        const SizedBox(
          height: 2,
        ),
        SizedBox(
          height: 40,
          child: TextFormField(
            onChanged: (value) => {
              if (widget.infoText == "Email" && widget.errorText.isNotEmpty)
                {
                  setState(() {
                    isValid = EmailValidator.validate(value);
                  }),
                }
            },
            controller: widget.controller,
            obscureText: widget.obscure,
            decoration: InputDecoration(
              errorText: isValid || widget.controller.text.isEmpty
                  ? null
                  : widget.errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              fillColor: Theme.of(context).colorScheme.surface,
              filled: true,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: FaIcon(
                        widget.obscure
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 17,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.obscure = !widget.obscure;
                        });
                      })
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

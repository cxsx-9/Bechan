import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function()? onTap;
  final String  btnText;
  final bool active;
  const SubmitButton({
    super.key,
    required this.onTap,
    required this.btnText,
    required this.active
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 55),
        decoration: BoxDecoration(
          color : active ? Colors.black :  Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border : active ? null : Border.all(
            width: 2,
            color: Colors.black
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child:Text(
            btnText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: active ? Colors.white : Colors.black
              ),
          ),
        )
      ),
    );
  }
}

class IconSubmitButton extends StatelessWidget {
  final Function()? onTap;
  final IconData icondata;
  final bool active;
  const IconSubmitButton({
    super.key,
    required this.onTap,
    required this.icondata,
    required this.active
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 50,

        decoration: BoxDecoration(
          color : active ? Colors.black :  Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border : active ? null : Border.all(
            width: 2,
            color: Colors.black
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child:Icon(
            icondata,
            color: active ? Colors.white : Colors.black,
            size: 25,
          ),
        )
      ),
    );
  }
}
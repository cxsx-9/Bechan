import 'package:flutter/material.dart';

class SoftAppearDialog extends StatelessWidget {
  final Widget child;

  const SoftAppearDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }
}
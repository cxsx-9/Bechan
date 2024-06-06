import 'package:flutter/material.dart';
import 'package:bechan/components/submit_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Text("Home Page"),
            SubmitButton(
                onTap: () {
                  Navigator.pop(context);
                },
                btnText: "Back",
                active: false),
          ],
        ),
      ),
    );
  }
}

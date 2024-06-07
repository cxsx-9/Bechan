import 'package:bechan/widgets/text_info.dart';
import 'package:flutter/material.dart';
import 'package:bechan/widgets/submit_button.dart';
import '../config.dart' as config;

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
            const SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInfo(topic: 'username', info: config.USER_DATA.username),
                  TextInfo(topic: 'firstname', info: config.USER_DATA.firstname),
                  TextInfo(topic: 'lastname', info: config.USER_DATA.lastname),
                ],
              ),
            ),
            
            const Expanded(
              child: SizedBox(),
            ),
            SubmitButton(
                onTap: () {
                  Navigator.pop(context);
                },
                btnText: "Back",
                type: 2),
          ],
        ),
      ),
    );
  }
}

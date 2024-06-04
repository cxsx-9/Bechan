import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [

              // LOGO
              const SizedBox(height: 90,),
              Image.asset(
                'Bechan_logo.png',
                height: 83,
              ),
              const SizedBox(height: 70,),

              // TextFeild
              
            ],
          ),
        ),
      ),
    );
  }
}
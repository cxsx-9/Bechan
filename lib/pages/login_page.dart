import 'package:bechan/pages/login_textfeild.dart';
import 'package:bechan/pages/submit_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void SignInUser(){}

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
              InputTextFeild(controller: usernameController, infoText: "Username or Email", hintText: "Enter Username or Email", obscureText: false),
              const SizedBox(height: 20,),
              InputTextFeild(controller: passwordController, infoText: "Password", hintText: "Enter Password", obscureText: true),


              // Register
              const SizedBox(height: 300,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account? ", style: TextStyle(color: Colors.black38),),
                  Text("Register", style: TextStyle(color: Colors.black),)
                  
                ],
              ),
              const SizedBox(height: 5,),
              SubmitButton(
                onTap: SignInUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
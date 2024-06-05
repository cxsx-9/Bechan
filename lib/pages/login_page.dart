import 'package:bechan/components/login_textfeild.dart';
import 'package:bechan/components/submit_button.dart';
import 'package:bechan/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() {}
  void registerUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // LOGO
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              'Banche_logo.png',
              height: 83,
            ),
            const SizedBox(
              height: 70,
            ),

            // TextFeild
            InputTextFeild(
                controller: usernameController,
                infoText: "Username or Email",
                hintText: "Enter Username or Email",
                obscureText: false),
            const SizedBox(
              height: 20,
            ),
            InputTextFeild(
                controller: passwordController,
                infoText: "Password",
                hintText: "Enter Password",
                obscureText: true),

            // Register
            const SizedBox(
              height: 300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
                GestureDetector(
                    onTap: registerUser,
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        backgroundColor: Color.fromRGBO(255, 215, 64, 1),
                      ),
                    )
                  )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            SubmitButton(onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
              },
              btnText: "Login",
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bechan/components/login_textfeild.dart';
import 'package:bechan/components/submit_button.dart';
import 'package:bechan/pages/home_page.dart';
import 'package:bechan/pages/login_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signInUser() {}
  void registerUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // LOGO
            const SizedBox(
              height: 70,
            ),
            Image.asset(
              'assets/Banche_logo.png',
              height: 83,
            ),
            const SizedBox(
              height: 50,
            ),

            // TextFeild
            InputTextFeild(
                controller: usernameController,
                infoText: "Username or Email",
                hintText: "Enter Username or Email",
                obscureText: false),
            const SizedBox(
              height: 10,
            ),
            InputTextFeild(
                controller: passwordController,
                infoText: "Password",
                hintText: "Enter Password",
                obscureText: true),
            const SizedBox(
              height: 10,
            ),
            InputTextFeild(
                controller: confirmPasswordController,
                infoText: "Confirm Password",
                hintText: "Confirm Password",
                obscureText: true),

            // Login
            const SizedBox(
              height: 150,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black38,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              backgroundColor: Color.fromRGBO(255, 215, 64, 1),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SubmitButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    btnText: "Register",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

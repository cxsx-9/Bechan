import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
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
                height: 110,
              ),
              Expanded(
                child: Column(
                  children: [
                    SubmitButton(
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.pushNamed(context, '/homePage');
                      },
                      btnText: "Register",
                      active: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            backgroundColor:
                                Color.fromRGBO(255, 215, 64, 1),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    IconSubmitButton(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pushNamed(context, '/loginPage');
                        },
                        icondata: Icons.arrow_back_rounded,
                        active: false),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

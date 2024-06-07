import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/services/login_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future <String> getStatus() async {
    String message = await LoginService('login').callApi(usernameController.text, passwordController.text);
    return message;
  }

  Future<void> login(context) async {
    final message = await getStatus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        width: 280.0, // Width of the SnackBar.r
        padding: const EdgeInsets.symmetric(
          horizontal:
              8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        // margin: const EdgeInsets.only(bottom: 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

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
                height: 20,
              ),
              InputTextFeild(
                  controller: passwordController,
                  infoText: "Password",
                  hintText: "Enter Password",
                  obscureText: true),

              // Register
              const SizedBox(
                height: 180,
              ),
              Expanded(
                child: Column(
                  children: [
                    SubmitButton(
                        onTap: () {
                          login(context);
                        },
                        btnText: "Login",
                        active: true),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            backgroundColor: Color.fromRGBO(255, 215, 64, 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SubmitButton(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.pushNamed(context, '/registerPage');
                        },
                        btnText: "Register",
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

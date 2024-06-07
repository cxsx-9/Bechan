import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/services/user_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();

  final pass = TextEditingController();

  Future<String> getStatus() async {
    Status res = await UserService()
        .callApi('login', {'username': user.text, 'password': pass.text});
    return res.message.toString();
  }

  Future<void> login(context) async {
    if (user.text.isEmpty || pass.text.isEmpty) {
      return;
    }
    String message = await getStatus();
    if (message == "Login success") {
      await UserService().callApi('user', null);
      Navigator.pushNamed(context, '/homePage');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.amber,
        content: const Text(
          "Wrong username or password.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        dismissDirection: DismissDirection.up,
        margin: const EdgeInsets.only(bottom: 220, left: 55, right: 55),
        behavior: SnackBarBehavior.floating,
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
                  controller: user,
                  infoText: "Username or Email",
                  hintText: "Enter Username or Email",
                  obscureText: false),
              const SizedBox(
                height: 20,
              ),
              InputTextFeild(
                  controller: pass,
                  infoText: "Password",
                  hintText: "Enter Password",
                  obscureText: true),

              // Button
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
                        type: user.text.isNotEmpty && pass.text.isNotEmpty ? 1 : 0),
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
                          Navigator.pushNamed(context, '/registerPage');
                        },
                        btnText: "Register",
                        type: 2),
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

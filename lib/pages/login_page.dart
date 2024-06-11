import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:bechan/services/user_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool enableBtn = true;
  bool isFeildFull = false;

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      setState(() { isFeildFull = emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty; });
    }

    emailCtrl.addListener(() { setIsFull(); });
    passCtrl.addListener(() { setIsFull(); });
  }

  Future<void> login(context) async {
    dynamic response = await UserService().callApi('login', {'email': emailCtrl.text, 'password': passCtrl.text});
    String message = response != null ? response.message : "";
    if (message == "Login success") {
      await UserService().callApi('user', null);
      Navigator.pushNamed(context, '/homePage');
      return;
    } else { message = "Wrong email or password."; }
    ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,240,false));
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
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55.0),
                  child: Column(
                    children: [
                      InputTextFeild(
                          controller: emailCtrl,
                          infoText: "Email",
                          hintText: "Enter Email",
                          obscureText: false),
                      const SizedBox(
                        height: 20,
                      ),
                      InputTextFeild(
                          controller: passCtrl,
                          infoText: "Password",
                          hintText: "Enter Password",
                          obscureText: true),
                    ],
                  )),
              const SizedBox(
                height: 190,
              ),
              Expanded(
                child: Column(
                  children: [
                    SubmitButton(
                        onTap: (emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) &&
                                enableBtn
                            ? () async {
                                setState(() {
                                  enableBtn = false;
                                });
                                await login(context);
                                setState(() {
                                  enableBtn = true;
                                });
                              }
                            : null,
                        btnText: "Login",
                        type: (emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) &&
                                enableBtn
                            ? 1
                            : 0),
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

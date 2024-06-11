import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final fnameCtrl = TextEditingController();
  final lnameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final cpassCtrl = TextEditingController();
  bool enableBtn = true;
  bool isFeildFull = false;
  bool validEmail = false;

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      setState(() {
        isFeildFull = emailCtrl.text.isNotEmpty &&
            fnameCtrl.text.isNotEmpty &&
            lnameCtrl.text.isNotEmpty &&
            passCtrl.text.isNotEmpty &&
            cpassCtrl.text.isNotEmpty;
        if (isFeildFull) {
          validEmail = EmailValidator.validate(emailCtrl.text);
        }
      });
    }
    emailCtrl.addListener(() { setIsFull(); });
    fnameCtrl.addListener(() { setIsFull(); });
    lnameCtrl.addListener(() { setIsFull(); });
    passCtrl.addListener(() { setIsFull(); });
    cpassCtrl.addListener(() { setIsFull(); });
  }

  Future<void> register(context) async {
    String message = "";
    if (passCtrl.text != cpassCtrl.text) {
      message = "Passwords do NOT match";
    } else {
      dynamic response = await UserService().callApi('register', {
        'email': emailCtrl.text,
        'password': passCtrl.text,
        'firstname': fnameCtrl.text,
        'lastname': lnameCtrl.text
      });
      message = response != null ? response.message : "no message";
    }
    bool success = message == "User registered successfully";
    ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message, 55, 240, success));
    if (success) { Navigator.pop(context); }
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55.0),
                child: Column(
                  children: [
                    InputTextFeild(
                        controller: emailCtrl,
                        infoText: "Email",
                        hintText: "Enter Email",
                        obscureText: false,
                        errorText: "Enter a valid email address",
                        ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputTextFeild(
                              controller: fnameCtrl,
                              infoText: "Firstname",
                              hintText: "Enter Firstname",
                              obscureText: false),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputTextFeild(
                              controller: lnameCtrl,
                              infoText: "Lastname",
                              hintText: "Enter Lastname",
                              obscureText: false),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InputTextFeild(
                      controller: passCtrl,
                      infoText: "Password",
                      hintText: "Enter Password",
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InputTextFeild(
                        controller: cpassCtrl,
                        infoText: "Confirm Password",
                        hintText: "Confirm Password",
                        obscureText: true),
                  ],
                ),
              ),

              // Register and back
              const SizedBox(
                height: 80,
              ),
              Expanded(
                child: Column(
                  children: [
                    SubmitButton(
                        onTap: isFeildFull && enableBtn && validEmail ? () async {
                                setState(() {enableBtn = false;});
                                await register(context);
                                setState(() {enableBtn = true;});
                              } : null,
                        btnText: "Register",
                        type: isFeildFull && enableBtn && validEmail ? 1 : 0),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
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
                            backgroundColor: Colors.amber.shade300,
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
                        },
                        icondata: Icons.arrow_back_rounded,
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

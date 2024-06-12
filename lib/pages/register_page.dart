import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bechan/theme/theme.dart';

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
    if (passCtrl.text != cpassCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(getSnackBar("Passwords do NOT match", 55, 240, false));
      return ;
    }

    dynamic response = await UserService().callApi('register', {
      'email': emailCtrl.text,
      'password': passCtrl.text,
      'firstname': fnameCtrl.text,
      'lastname': lnameCtrl.text
    });
    String message = response.message;
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
        resizeToAvoidBottomInset: true, // Enable resizing to avoid bottom inset
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Center(
                  child: Image.asset(
                    Provider.of<ThemeProvider>(context, listen: false).isDarkMode ? 'assets/Banche_logo_dark.png' : 'assets/Banche_logo_light.png',
                    height: 83,
                  ),
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
                              obscureText: false
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: InputTextFeild(
                              controller: lnameCtrl,
                              infoText: "Lastname",
                              hintText: "Enter Lastname",
                              obscureText: false
                            ),
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
                        obscureText: true
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: Column(
                    children: [
                      SubmitButton(
                        onTap: isFeildFull && enableBtn && validEmail ? () async {
                          setState(() { enableBtn = false; });
                          await register(context);
                          setState(() { enableBtn = true; });
                        } : null,
                        btnText: "Register",
                        type: isFeildFull && enableBtn && validEmail ? 1 : 0
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                backgroundColor: Colors.amber.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SubmitButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        icon: Icons.arrow_back_rounded,
                        type: 2
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
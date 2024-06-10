import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final user = TextEditingController();
  final fname = TextEditingController();
  final lname = TextEditingController();
  final pass = TextEditingController();
  final cpass = TextEditingController();
  bool enableBtn = true;
  bool isFeildFull = false;

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      setState(() {
        isFeildFull = user.text.isNotEmpty &&
            fname.text.isNotEmpty &&
            lname.text.isNotEmpty &&
            pass.text.isNotEmpty &&
            cpass.text.isNotEmpty;
      });
    }

    user.addListener(() { setIsFull(); });
    fname.addListener(() { setIsFull(); });
    lname.addListener(() { setIsFull(); });
    pass.addListener(() { setIsFull(); });
    cpass.addListener(() { setIsFull(); });
  }

  Future<void> register(context) async {
    String message = "";
    if (pass.text != cpass.text) {
      message = "Passwords do NOT match";
    } else {
      dynamic response = await UserService().callApi('register', {
        'username': user.text,
        'password': pass.text,
        'firstname': fname.text,
        'lastname': lname.text
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
                        controller: user,
                        infoText: "Username",
                        hintText: "Enter Username",
                        obscureText: false),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputTextFeild(
                              controller: fname,
                              infoText: "Firstname",
                              hintText: "Enter Firstname",
                              obscureText: false),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InputTextFeild(
                              controller: lname,
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
                      controller: pass,
                      infoText: "Password",
                      hintText: "Enter Password",
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InputTextFeild(
                        controller: cpass,
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
                        onTap: isFeildFull && enableBtn
                            ? () async {
                                setState(() {
                                  enableBtn = false;
                                });
                                await register(context);
                                setState(() {
                                  enableBtn = true;
                                });
                              }
                            : null,
                        btnText: "Register",
                        type: isFeildFull && enableBtn ? 1 : 0),
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
                            backgroundColor: Color.fromRGBO(255, 215, 64, 1),
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

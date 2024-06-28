import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:bechan/widgets/text_and_highlight.dart';
import 'package:bechan/services/user_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bechan/theme/theme.dart';
import 'package:bechan/config.dart' as config;

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
  bool validEmail = false;

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      setState(() { 
        isFeildFull = emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty;
        if (isFeildFull) {
          validEmail = EmailValidator.validate(emailCtrl.text);
        }
      });
    }
    emailCtrl.addListener(() { setIsFull(); });
    passCtrl.addListener(() { setIsFull(); });
  }

  Future<void> login(context) async {
    dynamic response = await UserService().login({'email': emailCtrl.text, 'password': passCtrl.text});
    String message = response.message;
    print(message);
    if (message == 'Login Success') {
      Navigator.pushReplacementNamed(context, '/mainPage');
      return;
    } else if (response.status == 'error') {
      message = response.message; 
      if (response.message != 'Please verify your email before logging in.'){
        message = "Wrong email or password";
      }
    } else if (response.status == 'ERR_CONNECTION') {
      message = response.message;
    }
    ScaffoldMessenger.of(context).showSnackBar(getSnackBar(message,55,230,false));
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              GestureDetector(
                  onLongPress: () {
                      emailCtrl.text = config.ADMIN_EMAIL;
                      passCtrl.text = config.ADMIN_PASSWD;
                },
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InputTextFeild(
                      controller: emailCtrl,
                      infoText: "Email",
                      hintText: "Enter Email",
                      obscureText: false,
                      errorText: "Enter a valid email address",
                    ),
                    const SizedBox(height: 10),
                    InputTextFeild(
                      controller: passCtrl,
                      infoText: "Password",
                      hintText: "Enter Password",
                      obscureText: true
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgotPasswordPage'),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ],
                )
              ),
              // const SizedBox(height: 200,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SubmitButton(
                      onTap: isFeildFull && enableBtn && validEmail ? () async {
                          setState(() {enableBtn = false;});
                          await login(context);
                          setState(() {enableBtn = true;});
                      } : null,
                      btnText: "Login",
                      type: isFeildFull && enableBtn && validEmail ? 1 : 0
                    ),
                    const SizedBox(height: 20),
                    const TextAndHighlight(text: "Don't have an account? ", highlight: "Register", link: false, onTap: null,),
                    const SizedBox(height: 5),
                    SubmitButton(
                      onTap: () { Navigator.pushNamed(context, '/registerPage'); },
                      btnText: "Register",
                      type: 2
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

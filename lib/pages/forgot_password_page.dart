import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bechan/config.dart' as config;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool enableBtn = true;
  bool isFeildFull = false;
  bool validEmail = false;
  TextEditingController emailCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    void setIsFull() {
        setState(() {
          isFeildFull = emailCtrl.text.isNotEmpty;
          if (isFeildFull) {
            validEmail = EmailValidator.validate(emailCtrl.text);
          }
        }
      );
    }
    emailCtrl.addListener(() { setIsFull(); });
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Text(
                      'Forgot password?',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We\'ll send you reset instructions.',
                      style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: InputTextFeild(
                  controller: emailCtrl,
                  infoText: 'Email',
                  hintText: 'Enter your email',
                  obscureText: false,
                  errorText: "Enter a valid email address",
                ),
              ),
              const SizedBox(height: 20,),
              SubmitButton(
                onTap: isFeildFull && enableBtn && validEmail ? () async {
                  setState(() {enableBtn = false;});
                  dynamic res = await UserService().forgotPassword({'email' : emailCtrl.text});
                  if (res.status == 'error' || res.status == 'ERR_CONNECTION') {
                    ScaffoldMessenger.of(context).showSnackBar(getSnackBar(res.message,55,70,false));
                  } else {
                    config.USER_DATA.email = emailCtrl.text;
                    Navigator.pushReplacementNamed(context, '/enterOtp');
                  }
                  setState(() {enableBtn = true;});
                } : null,
                btnText: 'Reset Password',
                type: isFeildFull && enableBtn && validEmail ? 1 : 0,
              ),
              const SizedBox(height: 40,),
              SizedBox(
                width: 150,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Back to log in',
                        style: GoogleFonts.inter(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                    ]
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
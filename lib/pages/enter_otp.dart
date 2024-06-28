import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/text_and_highlight.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterOtp extends StatefulWidget {
  const EnterOtp({super.key});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  bool enableBtn = true;
  bool isFeildFull = false;
  TextEditingController otpCtrl = TextEditingController();


  @override
  void initState() {
    super.initState();
    void setIsFull() {
        setState(() {
          isFeildFull = otpCtrl.text.isNotEmpty;
        }
      );
    }
    otpCtrl.addListener(() { setIsFull(); });
  }

  void resend() {}

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
                      'Password reset',
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
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: InputTextFeild(
                  controller: otpCtrl,
                  infoText: 'OTP',
                  hintText: 'Enter OTP from email',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 20,),
              SubmitButton(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/setPasswordPage');
                },
                btnText: 'Continue',
                type: isFeildFull && enableBtn ? 1 : 0,
              ),
              const SizedBox(height: 40,),
              TextAndHighlight(
                text: "Didn't recieve the email? ",
                highlight: "Resend",
                link: true,
                onTap: () {
                  resend;
                }
              ),
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
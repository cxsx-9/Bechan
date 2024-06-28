import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bechan/config.dart' as config;

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  bool enableBtn = true;
  bool isFeildFull = false;
  TextEditingController passCtrl = TextEditingController();
  TextEditingController cpassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    void setIsFull() {
        setState(() {
          isFeildFull = passCtrl.text.isNotEmpty && cpassCtrl.text.isNotEmpty;
        }
      );
    }
    passCtrl.addListener(() { setIsFull(); });
    cpassCtrl.addListener(() { setIsFull(); });
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                SizedBox(
                  height: 120,
                  child: Column(
                    children: [
                      Text(
                        'Set new password',
                        style: GoogleFonts.inter(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Must be at least 8 characters.',
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
                  child: Column(
                    children: [
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
                const SizedBox(height: 20,),
                SubmitButton(
                  onTap: isFeildFull && enableBtn ? () async {
                    if (cpassCtrl.text == passCtrl.text) {
                      setState(() {enableBtn = false;});
                      dynamic res = await UserService().setNewPassword({
                        "email": config.USER_DATA.email,
                        "token": config.STATUS.token,
                        "new_password": passCtrl.text
                      });
                      setState(() {enableBtn = true;});
                      if (res.status != 'ERR_CONNECTION' && res.status != 'error') {
                        ScaffoldMessenger.of(context).showSnackBar(getSnackBar('Changing password success!', 55, 70, true));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(getSnackBar(res.message, 55, 70, false));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(getSnackBar('Corfirm password does not match.', 55, 70, false));
                    }
                  } : null,
                  btnText: 'Reset Password',
                  type: isFeildFull && enableBtn ? 1 : 0,
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
      ),
    );
  }
}
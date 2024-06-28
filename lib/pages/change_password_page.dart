import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/custom_snackbar.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool enableBtn = true;
  bool isFeildFull = false;
  TextEditingController passCtrl = TextEditingController();
  TextEditingController opassCtrl = TextEditingController();
  TextEditingController cpassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    void setIsFull() {
        setState(() {
          isFeildFull = passCtrl.text.isNotEmpty && opassCtrl.text.isNotEmpty && cpassCtrl.text.isNotEmpty;
        }
      );
    }
    passCtrl.addListener(() { setIsFull(); });
    opassCtrl.addListener(() { setIsFull(); });
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Text(
                      'Change the password',
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
                        controller: opassCtrl,
                        infoText: "Old Password",
                        hintText: "Enter Old Password",
                        obscureText: true,
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
              const SizedBox(height: 20,),
              SubmitButton(
                onTap: isFeildFull && enableBtn ? () async {
                  if (cpassCtrl.text == passCtrl.text) {
                    setState(() {enableBtn = false;});
                    dynamic res = await UserService().changePassword({
                      "old_password": opassCtrl.text,
                      "new_password": passCtrl.text
                    });
                    passCtrl.text = '';
                    opassCtrl.text = '';
                    cpassCtrl.text = '';
                    setState(() {enableBtn = true;});
                    if (res.status != 'ERR_CONNECTION' && res.status != 'error') {
                      ScaffoldMessenger.of(context).showSnackBar(getSnackBar('Changing password success!', 55, 70, true));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(getSnackBar(res.message, 55, 70, false));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(getSnackBar('Corfirm password does not match.', 55, 70, false));
                  }
                } : null,
                btnText: 'Change Password',
                type: isFeildFull && enableBtn ? 1 : 0,
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}
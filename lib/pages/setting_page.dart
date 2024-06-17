import 'package:bechan/models/secure_storage.dart';
import 'package:bechan/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void logout(context) {
    SecureStorage().deleteToken();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Theme"),
                CupertinoSwitch(value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,onChanged: (value) {Provider.of<ThemeProvider>(context, listen: false).toggleTheme();},
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SubmitButton(
                onTap: () => logout(context), btnText: "Logout", type: 2),
          ],
        ),
      ),
    );
  }
}

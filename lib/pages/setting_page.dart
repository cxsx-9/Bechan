import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/theme/theme.dart';
import 'package:bechan/widgets/text_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:provider/provider.dart';
import 'package:bechan/config.dart' as config;


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User _user = config.USER_DATA;

  Future<void> _reload() async {
    dynamic response = await UserService().fetch();
    if (response.status == "error") {
      UserService().logout(context);
      return;
    }
    setState(() { _user = response; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInfo(topic: 'user id', info: _user.userId),
                  TextInfo(topic: 'email', info: _user.email),
                  TextInfo(topic: 'firstname', info: _user.firstname),
                  TextInfo(topic: 'lastname', info: _user.lastname),
                  TextInfo(topic: 'exp', info: DateTime.fromMillisecondsSinceEpoch(_user.exp * 1000).toString()),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SubmitButton(onTap: () => _reload(), btnText: "Reload", type: 1),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Theme"),
                CupertinoSwitch(value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,onChanged: (value) {Provider.of<ThemeProvider>(context, listen: false).toggleTheme();},
                ),
              ],
            ),
            const SizedBox(height: 180),
            SubmitButton(
                onTap: () =>  UserService().logout(context), btnText: "Logout", type: 2),
          ],
        ),
      ),
    );
  }
}

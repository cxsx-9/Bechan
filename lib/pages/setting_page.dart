import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter_gravatar/flutter_gravatar.dart';


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
    try {
      _user = response;
    } catch (e) {
      UserService().logout(context);
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: cardDecoration(context),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  Gravatar(_user.email).imageUrl(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Text(
                            "${_user.firstname} ${_user.lastname}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            _user.email,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: cardDecoration(context),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/changePasswordPage');
                        // UserService().logout(context);
                      },
                      child: Text(
                        'Change password',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14
                        ),
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: cardDecoration(context),
                    child: TextButton(
                      onPressed: () => UserService().logout(context),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

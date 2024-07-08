import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    // FilePickerResult? result;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () =>  {Navigator.pop(context, false)}, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    Text(
                      'Setting',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.secondary,
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      ),
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
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              _user.email,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                        onPressed: () {
                          CustomDialog().alertDialog(context, () => UserService().logout(context), 'Logout', 'Are you sure you want to Logout?');
                        },
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
      ),
    );
  }
}

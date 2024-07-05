import 'package:bechan/models/user_model.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


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
    // FilePickerResult? result;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
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
                    height: 250,
                    width: double.infinity,
                    decoration: cardDecoration(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                              Text('Import Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
                              Text('Import Your Transactions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.secondary),),
                            ],),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        // result =
                                        // await FilePicker.platform.pickFiles();
                                        // if (result == null) {
                                        //   print("No file selected");
                                        // } else {
                                        //   setState(() {});
                                        //   for (var element in result!.files) {
                                        //     print(element.name);
                                        //   }
                                        // }
                                        // CustomDialog().importDialog(context, '', '');
                                      },
                                      child: const Row(
                                        children: [
                                          Text('Choose file'),
                                          SizedBox(width: 12,),
                                          FaIcon(FontAwesomeIcons.fileImport, size: 15,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(height: 10, color: Theme.of(context).colorScheme.onSecondary,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  SizedBox(width: 40, child: Center(child: FaIcon(FontAwesomeIcons.fileArrowDown, size: 20, color: Colors.deepPurple,))),
                                  Text('Download template file',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
                                ]
                              ),
                              IconButton(
                                onPressed: () async {
                                  dynamic res = await TransactionService().getTemplate(context);
                                  print(res.url);
                                  final Uri url = Uri.parse(res.url);
                                  if (!await launchUrl(url)) {
                                    throw Exception('Could not launch $url');
                                  }
                                },
                                icon: const FaIcon(FontAwesomeIcons.arrowDown, size: 15,),
                              ),
                            ],
                          ),
                        ],
                      ),
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

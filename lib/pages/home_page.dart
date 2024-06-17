import 'package:flutter/material.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/models/secure_storage.dart';
import 'package:bechan/widgets/text_info.dart';
import 'package:bechan/widgets/small_card.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/services/user_service.dart';
import 'package:bechan/config.dart' as config;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user = config.USER_DATA;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    print("[HOME] > Fetch Data !");
    dynamic response = await UserService().callApi('user', null);
    if (response.status == "error") {
      print("[HOME] : Logout :(");
      logout();
      return;
    }
    setState(() {
      _user = response;
    });
    await SecureStorage().saveToken(response.token);
    print("[HOME] > Done !");
  }

  void logout() {
    SecureStorage().deleteToken();
    Navigator.pushReplacementNamed(context, '/loginPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: 90,
                    child: Row(
                      children: [
                        SmallProfileCard(
                            firstname: _user.firstname,
                            greeting: "Welcome back!"),
                        const SizedBox(width: 10),
                        const SmallCard(topic: "Saving", data: "25%")
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 90,
                    child: Row(
                      children: [
                        SmallCard(topic: "Expense", data: "1,250.00"),
                        SizedBox(width: 10),
                        SmallCard(topic: "Income", data: "25,000.00"),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInfo(topic: 'email         : ', info: _user.email),
                  TextInfo(topic: 'firstname : ', info: _user.firstname),
                  TextInfo(topic: 'lastname  : ', info: _user.lastname),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SubmitButton(onTap: () => _fetchUserData(), btnText: "Reload", type: 1),
          ],
        ),
      ),
    );
  }
}

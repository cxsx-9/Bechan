import 'package:bechan/widgets/long_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/small_card.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/config.dart' as config;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formattedDate = DateFormat('MMMM dd, yy').format(DateTime.now());
  final User _user = config.USER_DATA;

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
              // Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmallProfileCard(firstname: _user.firstname,greeting: "Welcome back!"),
                      const SizedBox(width: 10),
                      SmallCard(topic: "Today", data: formattedDate)
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const LongCard(topic: 'Reminder',),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

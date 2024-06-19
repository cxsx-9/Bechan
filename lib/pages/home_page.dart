import 'package:bechan/widgets/date_card.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:bechan/widgets/long_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/config.dart' as config;
import 'package:bechan/services/transaction_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User _user = config.USER_DATA;
  late Future<dynamic> futureApiResponse;
  final DateTime now = DateTime.now();
  String date = DateFormat('MMMM-dd-yy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    futureApiResponse = TransactionService().fethcDate('2024-06-14');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        DateCard(time: now)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const LongCard(topic: 'Reminder',),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 360,
                      height: 505,
                      child: Container(
          
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )]
                        ),
          
                        child: FutureBuilder<dynamic>(
                        future: futureApiResponse,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print('Error : ${snapshot.error}');
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data != null) {
                              return ListTransaction(
                                topic: 'Overall Today',
                                total: (snapshot.data!.summary.totalIncome - snapshot.data!.summary.totalExpense).toString(),
                                data: snapshot.data);
                            } else {
                              return const Center(child: Text('No transactions found.'));
                            }
                          },
                        ),
                      ),
                    )
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

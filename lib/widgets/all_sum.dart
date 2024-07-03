import 'package:bechan/widgets/sum_month.dart';
import 'package:bechan/widgets/sum_year.dart';
import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class AllSum extends StatelessWidget {
  final dynamic snapshot;
  final String type;

  const AllSum({
    super.key,
    required this.snapshot,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final String income = snapshot.data != null ? config.NUM_FORMAT.format(snapshot.data.summary.totalIncome) : '0.00';
    final String expense = snapshot.data != null ? config.NUM_FORMAT.format(snapshot.data.summary.totalExpense) : '0.00';
    final String balance = snapshot.data != null ? config.NUM_FORMAT.format(snapshot.data.summary.balance) : '0.00';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TinyCards(topic: 'Income', data: income),
              TinyCards(topic: 'Expense', data: expense),
              TinyCards(topic: 'Balance',color: Colors.white,backgroundColor: Colors.blue,data: balance),
            ],
          ),
          const SizedBox(height: 10,),
          ( snapshot.connectionState == ConnectionState.waiting )
          ? Container(
              constraints: const BoxConstraints(minHeight: 300),
              child: const Center(child: CircularProgressIndicator())
            )
          : snapshot.hasError
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "offline",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(textAlign: TextAlign.center,'You are Not Connected to the Internet\n${snapshot.error}'),
              ]
            )
          : type == 'month'
          ? SumMonth(data: snapshot.data)
          : SumYear(data: snapshot.data)
        ],
      ),
    );
  }
}
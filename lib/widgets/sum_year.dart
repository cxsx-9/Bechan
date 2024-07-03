import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class SumYear extends StatelessWidget {
  final dynamic data;

  const SumYear({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final String income = config.NUM_FORMAT.format(data.summary.totalIncome);
    final String expense = config.NUM_FORMAT.format(data.summary.totalExpense);
    final String balance = config.NUM_FORMAT.format(data.summary.balance);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TinyCards(topic: 'Income', data: income),
            TinyCards(topic: 'Expense', data: expense),
            TinyCards(topic: 'Balance',color: Colors.white,backgroundColor: Colors.blue,data: balance),
          ],
        ),
      ],
    );
  }
}
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:bechan/widgets/no_transaction.dart';
import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class AllDataCard extends StatelessWidget {
  final dynamic data;
  final bool waiting;
  final VoidCallback onDataChanged;
  const AllDataCard({super.key, required this.data, bool ? waiting, required this.onDataChanged}) : waiting = waiting ?? false;

  @override
  Widget build(BuildContext context) {
    double expense = data != null ? data.summary.totalExpense : 0.00;
    double income = data != null ? data.summary.totalIncome : 0.00;
    double balance = income - expense;
    return Column(
      children: [
        Row(
          children: [
            TinyCards(topic: 'Income', data: config.NUM_FORMAT.format(income)),
            const SizedBox(width: 10,),
            TinyCards(topic: 'Expense', data: config.NUM_FORMAT.format(expense)),
            const SizedBox(width: 10,),
            TinyCards(topic: 'Balance', color: Colors.white, backgroundColor: Colors.blue, data: config.NUM_FORMAT.format(balance)),
          ],
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: 360,
          height: 415,
          child: Container(
            decoration: cardDecoration(context),
            child: waiting
            ? const Center(child: CircularProgressIndicator())
            : data != null
            ? ListTransaction(data: data, onDataChanged: onDataChanged)
            : const NoTransaction()
          ),
        ),
      ],
    );
  }
}
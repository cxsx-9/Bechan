import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:bechan/widgets/no_transaction.dart';
import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class AllDataCard extends StatelessWidget {
  final dynamic data;
  final bool waiting;
  final DateTime start;
  final dynamic snapshot;
  final VoidCallback onDataChanged;
  const AllDataCard({super.key, required this.data, bool ? waiting, dynamic snapshot, required this.onDataChanged, required this.start}) 
  : waiting = waiting ?? false, snapshot = snapshot ?? null;

  @override
  Widget build(BuildContext context) {
    double expense = data != null ? data.summary.totalExpense : 0.00;
    double income = data != null ? data.summary.totalIncome : 0.00;
    double balance = income - expense;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TinyCards(topic: 'Income', data: config.NUM_FORMAT.format(income)),
            TinyCards(topic: 'Expense', data: config.NUM_FORMAT.format(expense)),
            TinyCards(topic: 'Balance', color: Colors.white, backgroundColor: Colors.blue, data: config.NUM_FORMAT.format(balance)),
          ],
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          height: 415,
          child: Container(
            decoration: cardDecoration(context),
            child: waiting
            ? const Center(child: CircularProgressIndicator())
            : data != null && !snapshot.hasError
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.transactions.length,
                    itemBuilder: (context, revIndex) {
                      int itemCount = data.transactions.length ?? 0;
                      int index = itemCount - 1 - revIndex;
                      final transaction = data.transactions[index];
                      return ListTransaction(transaction: transaction, onDataChanged: onDataChanged);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            )
            : NoTransaction(snapshot: snapshot,)
          ),
        ),
      ],
    );
  }
}
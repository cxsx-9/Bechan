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
    List<dynamic> _allData = data != null ? data.transactions : [];

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
          height: 425,
          child: Container(
            decoration: cardDecoration(context),
            child: waiting
            ? const Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: data != null && !snapshot.hasError
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _allData.length,
                        itemBuilder: (context, revIndex) {
                          int itemCount = _allData.length;
                          int index = itemCount - 1 - revIndex;
                          final transaction = _allData[index];
                          return ListTransaction(transaction: transaction, onDataChanged: onDataChanged);
                      },
                    ),
                  ),
                ],
              )
              : NoTransaction(snapshot: snapshot,),
            )
          ),
        ),
      ],
    );
  }
}
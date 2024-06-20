import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTransaction extends StatelessWidget {
  final String topic;
  final dynamic data;

  const ListTransaction({super.key, required this.topic, required this.data});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
            itemCount: data!.transactions.length,
            itemBuilder: (context, index) {
              final transaction = data!.transactions[index];
              return Column(
                children: [
                  TransactionCard(
                    amount: formatter.format(transaction.amount),
                    note: transaction.note,
                    type: transaction.categorieType,
                    date: DateFormat('dd MMMM yyyy').format(transaction.transactionDatetime!),
                  ),
                  const SizedBox(height: 10,)
                ],
              );
            },
          ),
        ),
      ],
    );      
  }
}
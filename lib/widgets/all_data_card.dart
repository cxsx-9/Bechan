import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:bechan/widgets/no_transaction.dart';
import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class AllDataCard extends StatelessWidget {
  final dynamic data;
  final bool waiting;
  final double income;
  final double expense;
  final int totalItem;
  final VoidCallback onDataChanged;
  final dynamic scrollController;
  
  const AllDataCard({
    super.key,
    required this.data,
    required this.income,
    required this.expense,
    required this.totalItem,
    bool ? waiting,
    bool ? hasError,
    required this.onDataChanged,
    required this.scrollController,
  }) 
  : 
  waiting = waiting ?? false
  ;

  @override
  Widget build(BuildContext context) {
    double balance = income - expense;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          width: double.infinity,
          height: 432,
          child: Container(
            decoration: cardDecoration(context),
            child: waiting
            ? const Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              data.length != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          int itemCount = data.length;
                          final transaction = data[index];
                          if (index + 1 == itemCount && itemCount != totalItem){
                            return const Center(child: RefreshProgressIndicator());
                          }
                          return ListTransaction(transaction: transaction, onDataChanged: onDataChanged);
                      },
                    ),
                  ),
                ],
              )
              : const NoTransaction(),
            )
          ),
        ),
      ],
    );
  }
}
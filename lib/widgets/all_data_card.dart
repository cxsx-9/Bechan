import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:bechan/widgets/tiny_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AllDataCard extends StatelessWidget {
  final dynamic data;
  final bool waiting;
  const AllDataCard({super.key, required this.data, bool ? waiting}) : waiting = waiting ?? false;

  @override
  Widget build(BuildContext context) {
    int expense = data != null ? data.summary.totalExpense : 0;
    int income = data != null ? data.summary.totalIncome : 0;
    int balance = income - expense;
    final formatter = NumberFormat('#,###');
    return Column(
      children: [
        Row(
          children: [
            TinyCards(topic: 'Income', data: formatter.format(income)),
            const SizedBox(width: 10,),
            TinyCards(topic: 'Expense', data: formatter.format(expense)),
            const SizedBox(width: 10,),
            TinyCards(topic: 'Balance', color: Colors.white,backgroundColor: Colors.blue , data: formatter.format(balance)),
          ],
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: 360,
          height: 415,
          child: Container(
            decoration: CardDecoration(context),
            child: data == null ? 
             Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/dance.webp',
                    height: 120,
                  ),
                  const Text(
                    "No transactions today?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Text(
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      // color: Theme.of(context).colorScheme.secondary
                    ),
                    textAlign: TextAlign.center,
                    "That's awesome!\nMaybe you're saving like a pro!",
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
            : ( waiting == false ? 
            ListTransaction(
              topic: 'Activity Feed',
              data: data
            )
            : const Center(child: CircularProgressIndicator())
            ),
          ),
        ),
      ],
    );
  }
}
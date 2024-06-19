import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTransaction extends StatelessWidget {
  final String total;
  final String topic;
  final data;

  const ListTransaction({super.key, required this.topic, required this.total, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic,
                    style: GoogleFonts.inter( 
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Container(
                    color: Colors.amber.shade400,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter( 
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Text(
                            total,
                            style: GoogleFonts.inter( 
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
            itemCount: data!.transactions.length,
            itemBuilder: (context, index) {
              final transaction = data!.transactions[index];
              return Column(
                children: [
                  TransactionCard(
                    amount: transaction.amount.toString(),
                    note: transaction.note,
                    type: transaction.categorieType,
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
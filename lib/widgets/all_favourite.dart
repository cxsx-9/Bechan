import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;


class AllFavourite extends StatelessWidget{
  const AllFavourite({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 415,
      child: Container(
        decoration: cardDecoration(context),
        child: FutureBuilder<dynamic>(
          future: TransactionService().fetchFav(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if ( snapshot.connectionState == ConnectionState.waiting ){
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Text(
                        'Favourites',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.favourite.length,
                        itemBuilder: (context, index) {
                          final transaction = snapshot.data.favourite[index];
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: GestureDetector(
                                onTap: () => {Navigator.pop(context, transaction)},
                                child: TransactionCard(
                                  amount: config.NUM_FORMAT.format(transaction.amount),
                                  note: transaction.note,
                                  type: transaction.categorieType,
                                  category: transaction.categorieName,
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
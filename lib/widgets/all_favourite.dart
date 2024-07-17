import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:flutter_slidable/flutter_slidable.dart';


class AllFavourite extends StatelessWidget{
  const AllFavourite({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 415,
      child: Container(
        decoration: cardDecoration(context),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder<dynamic>(
            future: TransactionService().fetchFav(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    "offline",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(textAlign: TextAlign.center,'You are Not Connected to the Internet'),
                ]
              );
              } else if ( snapshot.connectionState == ConnectionState.waiting ){
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 20,),
                            Text(
                              'Favourites',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            ),
                            Text(
                              '(${snapshot.data.favourite.length})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary)
                              )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.favourite.length,
                        itemBuilder: (context, index) {
                          final transaction = snapshot.data.favourite[index];
                          return Slidable(
                            key: ValueKey(transaction.transactionsId),
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                                    onPressed: (_) {
                                      Navigator.pop(context, {'data': transaction, 'edit': true});
                                    },
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    icon: Icons.edit,
                                  ),
                                ],
                              ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: GestureDetector(
                                onTap: () => {Navigator.pop(context, {'data': transaction, 'edit': false})},
                                child: TransactionCard(
                                  amount: config.NUM_FORMAT.format(transaction.amount),
                                  note: transaction.note,
                                  type: transaction.categorieType,
                                  category: transaction.categorieName,
                                  fav: transaction.fav
                                ),
                              ),
                            ),
                          );
                        }
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
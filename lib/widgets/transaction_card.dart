import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String amount;
  final String note;
  final String date;
  final String type;
  final String category;
  const TransactionCard({
    super.key,
    String ? amount,
    String ? note,
    String ? date,
    String ? type,
    String ? category,
  }) : amount = amount ?? '00.00',
    note = note ?? 'nothing',
    date = date ?? '',
    type = type ?? 'none',
    category = category ?? ''
  ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: Theme.of(context).colorScheme.secondary),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: type == 'none' ? Colors.grey.shade300 : type != 'income' ? const Color.fromRGBO(229, 101, 144, 1) : const Color.fromRGBO(0, 189, 174, 1),
                  borderRadius: BorderRadius.circular(15)
                ),
              ),
              const SizedBox(width: 20,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          note,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        ),
                        Text(
                          (type == 'none' ? '?' : type == 'income' ? '+' : '-') + amount,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                        SizedBox(width: date != '' ? 10 : 0,),
                        Text(
                          category, 
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

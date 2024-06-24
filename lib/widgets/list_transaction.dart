import 'package:bechan/pages/add_record.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ListTransaction extends StatefulWidget {
  final dynamic data;
  final VoidCallback onDataChanged;

  const ListTransaction({super.key, required this.data, required this.onDataChanged});

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {

  _delete(dynamic id) async {
    await TransactionService().deleteData({'transactions_id': id});
    widget.onDataChanged();
  }

  _duplicate(transaction) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddRecord(
          amount: transaction.amount.toString(),
          note: transaction.note,
          type: transaction.categorieType,
          date: transaction.transactionDatetime,
        );
      }
    );
    setState(() {
      widget.onDataChanged();
    });
  }

  _edit(transaction) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddRecord(
          isEdit: true,
          transactionsId: transaction.transactionsId,
          amount: transaction.amount.toString(),
          note: transaction.note,
          type: transaction.categorieType,
          date: transaction.transactionDatetime,
        );
      }
    );
    setState(() {
      widget.onDataChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            itemCount: widget.data!.transactions.length,
            itemBuilder: (context, index) {
              final transaction = widget.data!.transactions[index];
              return Slidable(
                key: ValueKey(transaction.transactionsId),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      onPressed: (_) {
                        _duplicate(transaction);
                      },
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      icon: Icons.control_point_duplicate_rounded,
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(
                    onDismissed: () {
                      setState(() {
                        widget.data!.transactions.removeAt(index);
                      });
                      _delete(transaction.transactionsId);
                    },
                  ),
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
                      onPressed: (_) {
                        _edit(transaction);
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                    ),
                    SlidableAction(
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
                      onPressed: (_) {
                        setState(() {
                          widget.data!.transactions.removeAt(index);
                        });
                        _delete(transaction.transactionsId);
                      },
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      icon: Icons.delete_forever_rounded,
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TransactionCard(
                      amount: formatter.format(transaction.amount),
                      note: transaction.note,
                      type: transaction.categorieType,
                      // date: DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.transactionDatetime!),
                      date: DateFormat('dd MMMM yyyy').format(transaction.transactionDatetime!),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
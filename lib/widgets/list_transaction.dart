import 'package:bechan/pages/add_record.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/custom_dialog.dart';
import 'package:bechan/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bechan/config.dart' as config;
import 'package:intl/intl.dart';

class ListTransaction extends StatefulWidget {
  final dynamic transaction;
  final VoidCallback onDataChanged;

  const ListTransaction({super.key, required this.transaction, required this.onDataChanged});

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {

  void onSubmitDelete() async {
    await TransactionService().deleteTransaction({'transactions_id': widget.transaction.transactionsId});
    widget.onDataChanged();
  }

  _duplicate(transaction) async {
    List<int> selectedTags = [];
    if (transaction.tags != []) {
      for (var tag in transaction.tags) {
        selectedTags.add(tag.tagId);
      }
    }
    await TransactionService().addTransaction({
      "categorie_id": transaction.categorieId,
      "amount": transaction.amount,
      "note": transaction.note,
      "transaction_datetime" : DateFormat('yyyy-MM-dd HH:mm:ss').format(transaction.transactionDatetime),
      "fav": 0,
      "tag_id": selectedTags,
    });
    widget.onDataChanged();
  }

  _edit(transaction) async {
    dynamic res = await showModalBottomSheet(
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
          categorieName: transaction.categorieName,
          tags: transaction.tags,
          fav: transaction.fav
        );
      }
    );
    if (res == true) {
      widget.onDataChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.transaction.transactionsId),
      startActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            onPressed: (_) {
              _duplicate(widget.transaction);
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.control_point_duplicate_rounded,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
            onPressed: (_) {
              _edit(widget.transaction);
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(15)),
            onPressed: (_) {
              CustomDialog().alertDialog(context, onSubmitDelete, 'Delete', 'Are you sure you want to delete \nthis data?');
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_forever_rounded,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TransactionCard(
            amount: config.NUM_FORMAT.format(widget.transaction.amount),
            note: widget.transaction.note,
            type: widget.transaction.categorieType,
            date: DateFormat('dd MMMM yyyy').format(widget.transaction.transactionDatetime!),
            category: widget.transaction.categorieName,
            fav: widget.transaction.fav
          ),
        ),
      ),
    );
  }
}

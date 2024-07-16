import 'package:bechan/pages/add_record.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/custom_dialog.dart';
import 'package:bechan/widgets/detail_transaction.dart';
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

  _duplicate() async {
    List<int> selectedTags = [];
    if (widget.transaction.tags != []) {
      for (var tag in widget.transaction.tags) {
        selectedTags.add(tag.tagId);
      }
    }
    await TransactionService().addTransaction({
      "categorie_id": widget.transaction.categorieId,
      "amount": widget.transaction.amount,
      "note": widget.transaction.note,
      "transaction_datetime" : DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.transaction.transactionDatetime),
      "fav": 0,
      "tag_id": selectedTags,
    });
    widget.onDataChanged();
  }

  _edit() async {
    dynamic res = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return AddRecord(
          isEdit: true,
          transactionsId: widget.transaction.transactionsId,
          amount: widget.transaction.amount.toString(),
          note: widget.transaction.note,
          detail: widget.transaction.detail,
          type: widget.transaction.categorieType,
          date: widget.transaction.transactionDatetime,
          categorieName: widget.transaction.categorieName,
          tags: widget.transaction.tags,
          fav: widget.transaction.fav
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
              _duplicate();
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
              _edit();
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
          child: GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return DetailTransaction(transaction: widget.transaction,);
                }
              );
            },
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
      ),
    );
  }
}

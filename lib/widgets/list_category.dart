import 'package:bechan/models/category_model.dart';
import 'package:bechan/services/category_service.dart';
import 'package:bechan/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListCategory extends StatefulWidget {
  final Category item;
  final String type;
  final VoidCallback onDataChanged;

  const ListCategory({
    super.key,
    required this.item,
    required this.type,
    required this.onDataChanged
  });

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  TextEditingController nameCtrl = TextEditingController();

  void onSubmitEdit() async {
    await CategoryService().editCategory(
      {
        "categorie_id": widget.item.categorieId,
        "name": nameCtrl.text,
        "type": widget.type
      }
    );
    widget.onDataChanged();
  }

  void onSubmitDelete() async {
    await CategoryService().deleteCategory({"categorie_id" : widget.item.categorieId});
    widget.onDataChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.item.categorieId),
        endActionPane: widget.item.userId != null ? ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                nameCtrl.text = widget.item.name;
                CustomDialog().inputDialog(context, nameCtrl, onSubmitEdit, 'Edit');
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) async {
                CustomDialog().alertDialog(context, onSubmitDelete, 'Delete', 'Are you sure you want to delete \nthis data?');
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever_rounded,
            ),
          ],
        ) : null,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: ListTile(
            visualDensity: const VisualDensity(vertical: -3),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  widget.item.name,
                  style: TextStyle(
                    color: widget.item.userId != null ? Theme.of(context).colorScheme.primary
                    : Colors.black45,
                    fontSize: 15
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
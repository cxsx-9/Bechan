import 'package:bechan/models/category_model.dart';
import 'package:bechan/services/category_service.dart';
import 'package:bechan/widgets/soft_appear_dialog.dart';
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

  Future<void> editCategory(context) async {
    nameCtrl.text = widget.item.name;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => SoftAppearDialog(
        child: CupertinoAlertDialog(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter new Category name'
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  controller: nameCtrl,
                  placeholder: "Category name",
                ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () async {
                Navigator.pop(context);
                await CategoryService().editCategory(
                  {
                    "categorie_id": widget.item.categorieId,
                    "name": nameCtrl.text,
                    "type": widget.type
                  }
                );
                widget.onDataChanged();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteCategory(context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => SoftAppearDialog(
        child: CupertinoAlertDialog(
          content: const Text('Are you sure you want to delete \nthis data?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () async {
                Navigator.pop(context);
                await CategoryService().deleteCategory({"categorie_id" : widget.item.categorieId});
                widget.onDataChanged();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
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
                await editCategory(context);
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) async {
                await deleteCategory(context);
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
          child: CupertinoListTile(
            title:
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: Text(
                widget.item.name,
                style: TextStyle(
                  color: widget.item.userId != null ? Theme.of(context).colorScheme.primary
                  : Colors.black45,
                  fontSize: 14
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
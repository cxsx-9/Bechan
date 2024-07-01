import 'package:bechan/models/tag_model.dart';
import 'package:bechan/services/tag_service.dart';
import 'package:bechan/widgets/soft_appear_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListTag extends StatefulWidget {
  final Tag item;
  final VoidCallback onDataChanged;

  const ListTag({
    super.key,
    required this.item,
    required this.onDataChanged
  });

  @override
  State<ListTag> createState() => _ListTagState();
}

class _ListTagState extends State<ListTag> {
  TextEditingController nameCtrl = TextEditingController();

  Future<void> editTag(context) async {
    nameCtrl.text = widget.item.name;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => SoftAppearDialog(
        child: CupertinoAlertDialog(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter new Tag name'
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  controller: nameCtrl,
                  placeholder: "Tag name",
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
                await TagService().editTag(
                  {
                    "tag_id": widget.item.tagId,
                    "tag_name": nameCtrl.text,
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

  Future<void> deleteTag(context) async {
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
                await TagService().deleteTag({"tag_id" : widget.item.tagId});
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
      key: ValueKey(widget.item.tagId),
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) async {
                await editTag(context);
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) async {
                await deleteTag(context);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever_rounded,
            ),
          ],
        ),
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
                  color: Theme.of(context).colorScheme.primary,
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

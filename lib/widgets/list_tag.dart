import 'package:bechan/models/tag_model.dart';
import 'package:bechan/services/tag_service.dart';
import 'package:bechan/widgets/custom_dialog.dart';
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

  void onSubmitEdit() async {
    await TagService().editTag(
      {
        "tag_id": widget.item.tagId,
        "tag_name": nameCtrl.text,
      }
    );
    widget.onDataChanged();
  }

  void onSubmitDelete() async {
    await TagService().deleteTag({"tag_id" : widget.item.tagId});
    widget.onDataChanged();
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

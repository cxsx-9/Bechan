import 'package:bechan/services/category_service.dart';
import 'package:bechan/services/tag_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/list_category.dart';
import 'package:bechan/widgets/list_tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  String? _type = 'income';
  dynamic textCtrl = TextEditingController();

  Future<void> _fetchData() async {
    await CategoryService().fetchCategory();
    setState(() {});
  }
  Future<void> _fetchTag() async {
    await TagService().fetchTag();
    setState(() {});
  }

  Future<void> createCategory() async {
    await CategoryService().addCategory(
      {
        "name": textCtrl.text,
        "type": _type
      }
    );
    _fetchData();
    setState(() {
      textCtrl.text = '';
    });
  }

  Future<void> createTag() async {
    await TagService().addTag(
      {
        "tag_name": textCtrl.text,
      }
    );
    _fetchTag();
    setState(() {
      textCtrl.text = '';
    });
  }



  void addNew() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => _SoftAppearDialog(
        child: CupertinoAlertDialog(
          content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter new category name'
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  controller: textCtrl,
                  placeholder: "name",
                ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              // isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            CupertinoDialogAction(
              // isDestructiveAction: false,
              onPressed: () {
                if (textCtrl.text != '') {
                  if (_type == 'tag') {
                    createTag();
                  } else {
                    createCategory();
                  }
                }
                print("Done ? type $_type - ${textCtrl.text}");
                textCtrl.text = '';
                Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
  int count = _type == 'income' ? config.CATEGORY.income.length : _type == 'expenses' ? config.CATEGORY.expenses.length : config.TAG.tags.length;
  final data = _type == 'income' ? config.CATEGORY.income : _type == 'expenses' ? config.CATEGORY.expenses : null;
  final tags = config.TAG.tags;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                    child:
                      Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      ),
                  ),
                  Center(
                    child : CupertinoSlidingSegmentedControl(
                      groupValue: _type,
                      children: const {
                        'income' : SizedBox(width: 80, child: Center(child: Text('Income'))),
                        'expenses' : SizedBox(width: 80, child: Center(child: Text('Expense'))),
                        'tag' : SizedBox(width: 80, child: Center(child: Text('Tags'))),
                      },
                      onValueChanged: (name) {
                        setState(() {
                          _type = name;
                        });
                      },
                    )
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: double.infinity,
                    height: 584,
                    child: Container(
                      decoration: cardDecoration(context),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _type! == 'income' ? 'Income' : _type! == 'expenses' ? 'Expense' : 'Tags',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                                ),
                                TextButton(
                                  onPressed: addNew,
                                  child: const SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text('Add'),
                                      ],
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: count,
                              itemBuilder: (context, index) {
                                if (_type == 'tag') {
                                  return ListTag(item: tags[index], onDataChanged: _fetchTag);
                                } else {
                                  return ListCategory(item: data![index], type : _type!, onDataChanged: _fetchData);
                                }
                              },
                              separatorBuilder: (context, index) {
                                return Divider(
                                  color: Theme.of(context).colorScheme.shadow,
                                  height: 0,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SoftAppearDialog extends StatelessWidget {
  final Widget child;

  const _SoftAppearDialog({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
  }
}
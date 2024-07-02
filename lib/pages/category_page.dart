import 'package:bechan/services/category_service.dart';
import 'package:bechan/services/tag_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_dialog.dart';
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

  void onSubmit() {
    if (_type == 'tag') {
      createTag();
    } else {
      createCategory();
    }
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
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ),
                  const SizedBox(height: 20,),
                  Center(
                    child : CupertinoSlidingSegmentedControl(
                      groupValue: _type,
                      children: const {
                        'income' : SizedBox(width:100, child: Center(child: Text('Income'))),
                        'expenses' : SizedBox(width:100, child: Center(child: Text('Expense'))),
                        'tag' : SizedBox(width:100, child: Center(child: Text('Tags'))),
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
                    height: 70,
                    child: Container(
                      decoration: cardDecoration(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 20),
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
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary
                              ),
                              onPressed: () => {CustomDialog().inputDialog(context, textCtrl, onSubmit, 'Create new')},
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
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    height: 450,
                    decoration: cardDecoration(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
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
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(
                                    color: Theme.of(context).colorScheme.shadow,
                                    height: 0,
                                  ),
                                );
                              },
                            ),
                          ),
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

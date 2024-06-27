import 'package:bechan/services/category_service.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/list_category.dart';
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

  @override
  Widget build(BuildContext context) {
  int count = _type == 'income' ? config.CATEGORY.income.length : _type == 'expense' ? config.CATEGORY.expenses.length : config.CATEGORY.tag.length;
  final data = _type == 'income' ? config.CATEGORY.income : _type == 'expense' ? config.CATEGORY.expenses : config.CATEGORY.tag;
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
                          fontSize: 22,
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
                        'expense' : SizedBox(width: 80, child: Center(child: Text('Expense'))),
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
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InputTextFeild(controller: textCtrl, infoText: '', hintText: 'New Category', obscureText: false, width: 250,),
                                IconButton(
                                  onPressed: textCtrl.text == '' ? null : () async {
                                    await createCategory();
                                  },
                                  icon: const Icon(Icons.add),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: ListView.separated(
                                itemCount: count,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return ListCategory(item: item, type : _type!, onDataChanged: _fetchData);
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Theme.of(context).colorScheme.shadow,
                                    height: 0,
                                  );
                                },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

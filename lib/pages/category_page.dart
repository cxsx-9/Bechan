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
                children: [
                  const SizedBox(height: 25,),
                  Center(
                    child : CupertinoSlidingSegmentedControl(
                      groupValue: _type,
                      children: const {
                        'income' : SizedBox(width: 80, child: Center(child: Text('Income'))),
                        'expense' : SizedBox(width: 80, child: Center(child: Text('Expense'))),
                        'tags' : SizedBox(width: 80, child: Center(child: Text('Tags'))),
                      },
                      onValueChanged: (index) {
                        setState(() {
                          _type = index;
                        });
                      },
                    )
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 360,
                    height: 622,
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
                                  onPressed: (){},
                                  icon: const Icon(Icons.add),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: count,
                              itemBuilder: (context, index) {
                                final item = data[index];
                                return ListCategory(name: item.name, type: 'income');
                              },
                            ),
                          // FutureBuilder<dynamic>(
                          //   future: _categoryRes,
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasError) {
                          //       return Center(child: Text('Error: ${snapshot.error}'));
                          //     } else if (snapshot.connectionState == ConnectionState.waiting) {
                          //       return const CircularProgressIndicator();
                          //     } else if (snapshot.hasData) {
                          //       int count = _type == 'income' ? snapshot.data!.income.length : _type == 'expense' ? snapshot.data!.expenses.length : snapshot.data!.tag.length;
                          //       final data = _type == 'income' ? snapshot.data!.income : _type == 'expense' ? snapshot.data!.expenses : snapshot.data!.tag;
                          //       return Expanded(
                          //         child: ListView.builder(
                          //           itemCount: count,
                          //           itemBuilder: (context, index) {
                          //             final item = data[index];
                          //             return ListCategory(name: item.name, type: 'income');
                          //           },
                          //         ),
                          //       );
                          //     } else {
                          //       return const Text('-');
                          //     }
                          //   },
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

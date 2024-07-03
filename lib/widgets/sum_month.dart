import 'package:bechan/models/sum_month_model.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/doughnut_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;

class SumMonth extends StatelessWidget {
  final dynamic data;

  const SumMonth({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    print('SUM MONTH');
    final List<SumCategory> sumIncome = data != null ? data.getCategories('income') : [];
    final List<SumCategory> sumExpense = data != null ? data.getCategories('expense') : [];
    final String income = data != null ? config.NUM_FORMAT.format(data.summary.totalIncome) : '';
    final String expense = data != null ? config.NUM_FORMAT.format(data.summary.totalExpense) : '';
    return Column(
      children: [
        DoughnutChart(data: sumIncome, topic: 'Income', mid: income),
        const SizedBox(height: 10,),
        DoughnutChart(data: sumExpense, topic: 'Expense', mid: expense),
        const SizedBox(height: 10,),
        Container(
          constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
          decoration: cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tag', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: data.summaryTags.length,
                    itemBuilder: (context, index) {
                      final item = data.summaryTags[index];
                      return Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.name,style: const TextStyle(fontSize: 15),),
                                Text(config.NUM_FORMAT.format(item.income), style: const TextStyle(fontSize: 15),),
                                Text(config.NUM_FORMAT.format(item.expense), style: const TextStyle(fontSize: 15),),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          color: Theme.of(context).colorScheme.shadow,
                          height: 0,
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

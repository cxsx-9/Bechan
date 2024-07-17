import 'dart:math';

import 'package:bechan/models/sum_month_model.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/doughnut_chart.dart';
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
    final List<SumCategory> sumIncome = data != null ? data.getCategories('income') : [];
    final List<SumCategory> sumExpense = data != null ? data.getCategories('expense') : [];
    final String income = data != null ? config.NUM_FORMAT.format(data.summary.totalIncome) : '';
    final String expense = data != null ? config.NUM_FORMAT.format(data.summary.totalExpense) : '';
    final List<SumTags> sumTags = data != null ? data.summaryTags : [];
    return Column(
      children: [
        DoughnutChart(data: sumIncome, topic: 'Income', mid: income),
        const SizedBox(height: 10,),
        DoughnutChart(data: sumExpense, topic: 'Expense', mid: expense),
        const SizedBox(height: 10,),
        Container(
          constraints: BoxConstraints(maxHeight: sumTags.isNotEmpty ? 60 + (45 * min(sumTags.length.toDouble(), 10.0)) : 70, minHeight: 50),
          decoration: cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: sumTags.isNotEmpty ? Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal : 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width:70, child: Text('Tag (${sumTags.length})', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary))),
                        SizedBox(width:80, child: Text('Income', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.end, )),
                        SizedBox(width:80, child: Text('Expense', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.end, )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: sumTags.length,
                    itemBuilder: (context, index) {
                      final item = sumTags[index];
                      return SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -3),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width:90, child: Text(item.name,style: const TextStyle(fontSize: 15),)),
                              SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.income), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
                              SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.expense), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
                            ],
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
            ) : const Center(child: Text('No tags data'),),
          ),
        )
      ],
    );
  }
}

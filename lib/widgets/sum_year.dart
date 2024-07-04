import 'package:bechan/models/sum_year_model.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:syncfusion_flutter_charts/charts.dart';

class SumYear extends StatelessWidget {
  final dynamic data;

  const SumYear({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final List<MonthData> months = data != null ? data.months : [];
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SfCartesianChart(
              series: <CartesianSeries>[
                  ColumnSeries<MonthData, int>(
                      dataSource: months,
                      // splineType: SplineType.cardinal,
                      xValueMapper: (MonthData data, _) => data.month,
                      yValueMapper: (MonthData data, _) => data.totalIncome,
                      color: const Color.fromRGBO(0, 189, 174, 1),
                  ),
                  ColumnSeries<MonthData, int>(
                      dataSource: months,
                      // splineType: SplineType.cardinal,
                      xValueMapper: (MonthData data, _) => data.month,
                      yValueMapper: (MonthData data, _) => data.totalExpense,
                      color: const Color.fromRGBO(229, 101, 144, 1),
                  ),
              ]
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 300, minHeight: 100),
          decoration: cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width:70, child: Text('Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                          SizedBox(width:80, child: Text('Income', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.end,)),
                          SizedBox(width:80, child: Text('Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.end,)),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: months.length,
                    itemBuilder: (context, index) {
                      final item = months[index];
                      return Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width:70, child: Text(item.month.toString(), style: const TextStyle(fontSize: 15),)),
                                SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.totalIncome), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
                                SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.totalExpense), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
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
        ),
      ],
    );
  }
}
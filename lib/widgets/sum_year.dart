import 'package:bechan/models/sum_year_model.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:bechan/config.dart' as config;
import 'package:intl/intl.dart';
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
          height: months.isNotEmpty ? 300 : 200,
          decoration: cardDecoration(context),
          child: months.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10, left: 5),
            child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(
                enable: true,
              ),
              primaryXAxis: CategoryAxis(
                interval: 1,
                labelRotation: 90,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary
                ),
                axisLine: AxisLine(color: Theme.of(context).colorScheme.secondary,),
                majorTickLines: MajorTickLines(color: Theme.of(context).colorScheme.secondary,),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compactCurrency(decimalDigits: 0, symbol: ''),
                labelStyle: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.secondary
                ),
                axisLine: AxisLine(color: Theme.of(context).colorScheme.secondary,),
                majorTickLines: MajorTickLines(color: Theme.of(context).colorScheme.secondary,),
                majorGridLines: MajorGridLines(
                  color: Theme.of(context).colorScheme.secondary
                ),
              ),
              series: <CartesianSeries>[
                  ColumnSeries<MonthData, String>(
                      name: 'Income',
                      dataSource: months,
                      xValueMapper: (MonthData data, _) => DateFormat('MMM').format(DateTime(0, data.month)),
                      yValueMapper: (MonthData data, _) => data.totalIncome,
                      color: const Color.fromRGBO(0, 189, 174, 1),
                  ),
                  ColumnSeries<MonthData, String>(
                      name: 'Expense',
                      dataSource: months,
                      xValueMapper: (MonthData data, _) => DateFormat('MMM').format(DateTime(0, data.month)),
                      yValueMapper: (MonthData data, _) => data.totalExpense,
                      color: const Color.fromRGBO(229, 101, 144, 1),
                  ),
              ]
            ),
          ) : const Center(child: Text('No Year data'),),
        ),
        const SizedBox(height: 10,),
        months.isNotEmpty ? Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 730, minHeight: 100),
          decoration: cardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width:70, child: Text('Month', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary))),
                          SizedBox(width:80, child: Text('Income', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.end, )),
                          SizedBox(width:80, child: Text('Expense', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary), textAlign: TextAlign.end, )),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: months.length,
                    itemBuilder: (context, index) {
                      final item = months[index];
                      return SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          // padding: const EdgeInsets.all(10),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 90, child: Text(DateFormat('MMMM').format(DateTime(0, item.month)), style: const TextStyle(fontSize: 15),textAlign: TextAlign.start )),
                              SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.totalIncome), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
                              SizedBox(width:100, child: Text(config.NUM_FORMAT.format(item.totalExpense), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
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
            ),
          ),
        ) : const SizedBox(),
      ],
    );
  }
}
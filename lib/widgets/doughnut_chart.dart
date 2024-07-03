import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatelessWidget {
  final dynamic data;
  final String topic;
  final String mid;
  const DoughnutChart ({
    super.key,
    required this.data,
    String ? topic,
    String ? mid
  }) : 
  topic = topic ?? '',
  mid = mid ?? ''
  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration(context),
      height: 240,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SfCircularChart(
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Text(
                mid,
                style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 20)
              )
            )
          ],
          title: ChartTitle(
            text: topic,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            alignment: ChartAlignment.near),
          legend: const Legend(
            position: LegendPosition.left,
            isVisible: true,
            alignment: ChartAlignment.near
          ),
          series: <CircularSeries>[
            DoughnutSeries<dynamic, String>(
              dataSource: data,
              pointColorMapper:(dynamic data,  _) => Colors.accents[data.categorieId % Colors.accents.length],
              xValueMapper: (dynamic data, _) => data.name,
              yValueMapper: (dynamic data, _) => data.amount,
              dataLabelSettings: const DataLabelSettings(isVisible : true),
              innerRadius: '70%',
              radius: '100%',
              sortingOrder: SortingOrder.ascending,
            )
          ]
        ),
      ),
    );
  }
}
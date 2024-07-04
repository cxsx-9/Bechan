import 'package:bechan/widgets/card_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:bechan/config.dart' as config;

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
      width: double.infinity,
      height: data.length != 0 ? 460 : 70,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: data.length != 0 ? Column(
          children: [
            SizedBox(
              height: data.length != 0 ? 300 : 80,
              child: SfCircularChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    angle: 270,
                    radius: '8%',
                    widget: Text(
                      mid,
                      style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 0, 1),
                        fontSize: mid.length < 12 ? 30 : 25,
                      )
                    )
                  ),
                  CircularChartAnnotation(
                    angle: 90,
                    radius: '20%',
                    widget: Text(
                      data.length != 0 ? 'total' : '',
                      style: const TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: 18
                      )
                    )
                  )
                ],
                title: ChartTitle(
                  text: topic,
                  textStyle: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  alignment: ChartAlignment.near,
                ),
                // legend: const Legend(
                //   overflowMode: LegendItemOverflowMode.scroll,
                //   position: LegendPosition.bottom,
                //   isVisible: true,
                //   padding: 5
                // ),
                series: <CircularSeries>[
                  DoughnutSeries<dynamic, String>(
                    dataSource: data,
                    xValueMapper: (dynamic data, _) => data.name,
                    yValueMapper: (dynamic data, _) => data.amount,
                    innerRadius: '80%',
                    radius: '100%',
                  )
                ]
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width:120, child: Text(item.name, style: const TextStyle(fontSize: 15,),)),
                            SizedBox(width:120, child: Text(config.NUM_FORMAT.format(item.amount), style: const TextStyle(fontSize: 15), textAlign: TextAlign.end,)),
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
        ) : Center(child:Text('No $topic data')),
      ),
    );
  }
}
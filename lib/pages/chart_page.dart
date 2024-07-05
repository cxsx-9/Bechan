import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/all_sum.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/show_date_picker.dart';
import 'package:bechan/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String selectedYear = DateFormat('yyyy').format(DateTime.now());
  String sendMonth = DateFormat('yyyy-MM').format(DateTime.now());
  String? type = 'month';

  late Future<dynamic> _mres = Future.value(TransactionService().fetchSumM(sendMonth, context));
  late Future<dynamic> _yres = Future.value(TransactionService().fetchSumY(selectedYear, context));

  void onSubmitMonth(Object value) {
    if (value is DateTime) {
      setState(() {
        selectedMonth = DateFormat('MMMM yyyy').format(value);
        if (sendMonth != DateFormat("yyyy-MM").format(value)) {
          sendMonth = DateFormat("yyyy-MM").format(value);
          fetchMSum();
        }
      });
    }
    Navigator.of(context).pop();
  }

  void onSubmitYear(Object value) {
    if (value is DateTime) {
      setState(() {
        if (selectedYear != DateFormat('yyyy').format(value)) {
          selectedYear = DateFormat('yyyy').format(value);
          fetchYSum();
        }
      });
    }
    Navigator.of(context).pop();
  }

  void fetchMSum () async {
    _mres = await Future.value(TransactionService().fetchSumM(sendMonth, context));
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void fetchYSum () async {
    _yres = await Future.value(TransactionService().fetchSumY(selectedYear, context));
    _refreshController.refreshCompleted();
    setState(() {});
  }

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
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
          child: SmartRefresher(
          controller: _refreshController,
          onRefresh: type == 'month' ? fetchMSum : fetchYSum,
          enablePullDown: true,
          enablePullUp: false,
          enableTwoLevel: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => {
                              CustomDialog().importDialog(context, 'Improt file', 'Download template file')
                            },
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Center(
                          child : CupertinoSlidingSegmentedControl(
                            groupValue: type,
                            children: const {
                              'month' : SizedBox(width:160, child: Center(child: Text('Month'))),
                              'year' : SizedBox(width:160, child: Center(child: Text('Year'))),
                            },
                            onValueChanged: (name) {
                              setState(() {
                                type = name;
                              });
                            },
                          )
                        ),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: cardDecoration(context),
                          child: TextButton(
                            onPressed: () => {
                              if ( type! == 'month') {
                                ShowDatePickerFunction().showMonthPicker(context, onSubmitMonth)
                              } else {
                                ShowDatePickerFunction().showYearPicker(context, onSubmitYear)
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_rounded, size: 17),
                                const SizedBox(width: 10,),
                                Text(type! == 'month' ? selectedMonth : selectedYear,),
                                const Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      child: FutureBuilder<dynamic>(
                        future: type == 'month' ? _mres : _yres,
                        builder: (context, snapshot) {
                          return AllSum(snapshot: snapshot, type: type!);
                        },
                      )
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
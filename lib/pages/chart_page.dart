import 'package:bechan/services/filetransfer_service.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/all_sum.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/show_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:url_launcher/url_launcher.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

enum Menu { download }

class _ChartPageState extends State<ChartPage> {
  String selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String selectedYear = DateFormat('yyyy').format(DateTime.now());
  String sendMonth = DateFormat('yyyy-MM').format(DateTime.now());
  String? startDate;
  String? endDate;
  String? type = 'month';
  DateTime selectDate = DateTime.now();

  late Future<dynamic> _mres = Future.value(TransactionService().fetchSumM(sendMonth, context));
  late Future<dynamic> _yres = Future.value(TransactionService().fetchSumY(selectedYear, context));

  void onSubmitMonth(Object value) {
    if (value is DateTime) {
      setState(() {
        selectDate = value;
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
        selectDate = value;
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
                      child: SizedBox(
                        height: 48,
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
                            PopupMenuButton<Menu>(
                              elevation: 5,
                              shadowColor: Theme.of(context).colorScheme.secondary,
                              color: Theme.of(context).colorScheme.onPrimary,
                              icon: const Icon(Icons.more_vert_rounded, size: 20,),
                              onSelected: (Menu item) {},
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                                PopupMenuItem<Menu>(
                                  onTap: () async {
                                    if (type == 'year') {
                                      startDate = DateFormat('yyyy-MM-dd').format(DateTime(selectDate.year, 1, 1));
                                      endDate = DateFormat('yyyy-MM-dd').format(DateTime(selectDate.year + 1, 1, 0));
                                    } else {
                                      startDate = DateFormat('yyyy-MM-dd').format(DateTime(selectDate.year, selectDate.month, 1));
                                      endDate = DateFormat('yyyy-MM-dd').format((selectDate.month < 12) ? DateTime(selectDate.year, selectDate.month + 1, 0) : DateTime(selectDate.year + 1, 1, 0));
                                    }
                                    setState(() {});
                                    dynamic res = await FiletransferService().exportTransaction(startDate!, endDate!);
                                    final Uri url = Uri.parse(res.url);
                                    if (!await launchUrl(url)) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  value: Menu.download,
                                  child: const ListTile(
                                    leading: Icon(Icons.file_download),
                                    title: Text('Export transactions'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                ShowDatePickerFunction().showMonthPicker(context, onSubmitMonth, selectDate)
                              } else {
                                ShowDatePickerFunction().showYearPicker(context, onSubmitYear, selectDate)
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

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     const Row(
//       children: [
//         SizedBox(width: 40, child: Center(child: FaIcon(FontAwesomeIcons.fileArrowDown, size: 20, color: Colors.deepPurple,))),
//         Text('Export all Transactions',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),),
//       ]
//     ),
//     IconButton(
//       onPressed: () async {
//         dynamic res = await TransactionService().getAllTransactoin(context);
//         print(res.url);
//         final Uri url = Uri.parse(res.url);
//         if (!await launchUrl(url)) {
//           throw Exception('Could not launch $url');
//         }
//       },
//       icon: const FaIcon(FontAwesomeIcons.arrowDown, size: 15,),
//     ),
//   ],
// ),
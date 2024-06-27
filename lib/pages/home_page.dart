import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/all_data_card.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/date_card.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/config.dart' as config;
import 'package:bechan/services/transaction_service.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    this.isReload = false
  });

  bool isReload;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User _user = config.USER_DATA;
  final DateTime _now = DateTime.now();
  String _range = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String _startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime? _start;
  DateTime? _end;
  bool _isLoading = true;
  late Future<dynamic> _data = Future.value(TransactionService().fetchTransaction(_startDate, _endDate));

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchData() async {
    setState(() {_isLoading = true;});
    _data = await Future.value(TransactionService().fetchTransaction(_startDate, _endDate));
    setState(() {});
  }

  Future<void> _reload() async {
    print("-- ---  -----   -------    RELOAD");
    setState(() {_isLoading = false;});
    _data = await Future.value(TransactionService().fetchTransaction(_startDate, _endDate));
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onSubmit(Object value) {
    setState(() {
      if (value is PickerDateRange) {
        _range = value.endDate == null || value.endDate == value.startDate
            ? DateFormat('dd MMMM yyyy').format(value.startDate!)
            : '${DateFormat('dd MMMM yyyy').format(value.startDate!)} - ${DateFormat('dd MMMM yyyy').format(value.endDate ?? value.startDate!)}';
        _startDate = DateFormat('yyyy-MM-dd').format(value.startDate!);
        _start = value.startDate;
        _endDate = DateFormat('yyyy-MM-dd').format(value.endDate ?? value.startDate!);
        _end = value.endDate;
      }
    });
    _fetchData();
    Navigator.of(context).pop();
  }

  void showDatePicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Date Range',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 300, // Adjust as needed
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: SfDateRangePicker(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    showActionButtons: true,
                    onSubmit: (value) {
                      _onSubmit(value!);
                    },
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(_start, _end),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReload) {
      setState(() {
        _fetchData();
        widget.isReload = false;
      });
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _reload,
          enablePullDown: true,
          enablePullUp: false,
          enableTwoLevel: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  // Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SmallProfileCard(firstname: _user.firstname, greeting: "Welcome back!"),
                          const SizedBox(width: 10),
                          DateCard(time: _now)
                        ],
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 360,
                        height: 50,
                        child: Container(
                          decoration: cardDecoration(context),
                          child: TextButton(
                            onPressed: () {
                              showDatePicker(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_rounded),
                                const SizedBox(width: 10,),
                                Text(_range),
                                const Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      FutureBuilder<dynamic>(
                        future: _data,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            return AllDataCard(
                              data: snapshot.data,
                              start: _start ?? _now,
                              waiting: (snapshot.connectionState == ConnectionState.waiting) && _isLoading,
                              onDataChanged: _reload,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
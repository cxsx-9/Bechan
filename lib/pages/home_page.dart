import 'package:bechan/widgets/date_card.dart';
import 'package:bechan/widgets/list_transaction.dart';
import 'package:flutter/material.dart';
import 'package:bechan/models/user_model.dart';
import 'package:bechan/widgets/small_profile_card.dart';
import 'package:bechan/config.dart' as config;
import 'package:bechan/services/transaction_service.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User _user = config.USER_DATA;
  late Future<dynamic> futureApiResponse;
  final DateTime now = DateTime.now();
  String date = DateFormat('MMMM-dd-yy').format(DateTime.now());

  String _range = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String _selectedDate = '';
  String _dateCount = '';
  String _startDate = '';
  String _endDate = '';
  String _rangeCount = '';

  @override
  void initState() {
    super.initState();
    futureApiResponse = TransactionService().fethcDate(_startDate, _endDate);
    // futureApiResponse = TransactionService().fethcDate('2024-06-14','2024-06-14');
  }

  @override
  Widget build(BuildContext context) {

    void _onSubmit(Object value) {
      setState(() {
        print(value);
        if (value is PickerDateRange) {
          _range = '${DateFormat('dd MMMM yyyy').format(value.startDate!)} -'
          ' ${DateFormat('dd MMMM yyyy').format(value.endDate ?? value.startDate!)}';
          _startDate = DateFormat('yyyy-MM-dd').format(value.startDate!);
          _endDate = DateFormat('yyyy-MM-dd').format(value.endDate ?? value.startDate!);
        } else if (value is DateTime) {
          _selectedDate = value.toString();
        } else if (value is List<DateTime>) {
          _dateCount = value.length.toString();
        } else if (value is List<PickerDateRange>) {
          _rangeCount = value.length.toString();
        }
      });
      TransactionService().fethcDate(_startDate, _endDate);
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
                    // onSelectionChanged: _onSelectionChanged,
                    headerStyle: DateRangePickerHeaderStyle(
                        backgroundColor: Theme.of(context).colorScheme.onPrimary,
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    onCancel: (){ Navigator.of(context).pop(); },
                    showActionButtons: true,
                    cancelText: 'Cancel',
                    confirmText: 'Done',
                    onSubmit:(value) {_onSubmit(value!);},
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 0)),
                        DateTime.now().add(const Duration(days: 0))),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                // Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmallProfileCard(firstname: _user.firstname,greeting: "Welcome back!"),
                        const SizedBox(width: 10),
                        DateCard(time: now)
                      ],
                    ),
                    const SizedBox(height: 10,),

                    TextButton(
                      onPressed: () { showDatePicker(context); },
                        child: Container(
                          // color: Theme.of(context).colorScheme.onPrimary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_range),
                              const Icon(Icons.arrow_drop_down_rounded),
                            ],
                          ),
                        ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: 360,
                      height: 505,
                      child: Container(
          
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )]
                        ),
          
                        child: FutureBuilder<dynamic>(
                        future: futureApiResponse,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print('Error : ${snapshot.error}');
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.data != null) {
                              return ListTransaction(
                                topic: 'Activity Feed',
                                total: (snapshot.data!.summary.totalIncome - snapshot.data!.summary.totalExpense).toString(),
                                data: snapshot.data);
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Center(child: Text("No transactions today? That's awesome! \nMaybe you're saving like a pro!")),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bechan/widgets/all_data_card.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/date_card.dart';
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
  String _startDate = '';
  String _endDate = '';
  DateTime ? _start;
  DateTime ? _end;

  @override
  void initState() {
    super.initState();
    futureApiResponse = TransactionService().fethcDate(_startDate, _endDate);
  }

  @override
  Widget build(BuildContext context) {

    void _onSubmit(Object value) {
      setState(() {
        print(value);
        if (value is PickerDateRange) {
          _range = value.endDate == null ? DateFormat('dd MMMM yyyy').format(value.startDate!) 
          : '${DateFormat('dd MMMM yyyy').format(value.startDate!)} - ${DateFormat('dd MMMM yyyy').format(value.endDate ?? value.startDate!)}';
          _startDate = DateFormat('yyyy-MM-dd').format(value.startDate!);
          _start = value.startDate;
          _endDate = DateFormat('yyyy-MM-dd').format(value.endDate ?? value.startDate!);
          _end = value.endDate;
        }
      });
      futureApiResponse = TransactionService().fethcDate(_startDate, _endDate);
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
                      )
                    ),
                    onCancel: (){ Navigator.of(context).pop(); },
                    // showTodayButton: true,
                    showActionButtons: true,
                    // cancelText: 'Cancel',
                    // confirmText: 'Done',
                    onSubmit:(value) {_onSubmit(value!);},
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
                    SizedBox(
                      width: 360,
                      height: 50,
                      child: Container(
                        decoration: CardDecoration(context),
                        child: TextButton(
                          onPressed: () { showDatePicker(context); },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_range),
                                const Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    FutureBuilder<dynamic>(
                    future: futureApiResponse,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return AllDataCard(data: snapshot.data, waiting: true,);
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return AllDataCard(data: snapshot.data);
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
    );
  }
}

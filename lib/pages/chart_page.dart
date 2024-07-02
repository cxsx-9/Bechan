import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/show_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  String _selectedYear = DateFormat('yyyy').format(DateTime.now());
  String ? _sendDate;
  String? _type = 'month';

  void onSubmitMonth(Object value) {
    if (value is DateTime) {
      setState(() {
          _selectedMonth = DateFormat('MMMM yyyy').format(value);
          _sendDate = DateFormat("yyyy MM").format(value);
      });
    }
    Navigator.of(context).pop();
  }

  void onSubmitYear(Object value) {
    if (value is DateTime) {
      setState(() {
          _selectedYear = DateFormat('yyyy').format(value);
          _sendDate = DateFormat("yyyy").format(value);
      });
    }
    Navigator.of(context).pop();
  }

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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Center(
                        child : CupertinoSlidingSegmentedControl(
                          groupValue: _type,
                          children: const {
                            'month' : SizedBox(width:160, child: Center(child: Text('Month'))),
                            'year' : SizedBox(width:160, child: Center(child: Text('Year'))),
                          },
                          onValueChanged: (name) {
                            setState(() {
                              _type = name;
                            });
                          },
                        )
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 70,
                        decoration: cardDecoration(context),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _type! == 'month' ? 'Month' : 'Year',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              ),
                              TextButton(
                                onPressed: () => {
                                  if ( _type! == 'month') {
                                    ShowDatePickerFunction().showMonthPicker(context, onSubmitMonth)
                                  } else {
                                    ShowDatePickerFunction().showYearPicker(context, onSubmitYear)
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                       _type! == 'month' ? _selectedMonth : _selectedYear,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down_rounded),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
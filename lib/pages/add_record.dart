import 'package:bechan/models/tag_model.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/input_number.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:bechan/config.dart' as config;

const List<Widget> transactionType = <Widget>[
  Text('Income'),
  Text('Expense')
];

// ignore: must_be_immutable
class AddRecord extends StatefulWidget {
  final bool isEdit;
  final int transactionsId;
  final String categorieName;
  final String amount;
  final String note;
  final String type;
  final DateTime date;
  List<Tag> tags;
 
  AddRecord({
    super.key,
    bool ? isEdit,
    int ? transactionsId,
    String ? categorieName,
    String ? amount,
    String ? note,
    String ? type,
    List<Tag> ? tags,
    required this.date,
  }) : amount = amount ?? '',
    isEdit = isEdit ?? false,
    note = note ?? '',
    type = type ?? 'expense',
    transactionsId = transactionsId ?? 0,
    categorieName = categorieName ?? '',
    tags = tags ?? []
  ;
  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  List<bool> _selectedType = <bool>[false, true];
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  bool isFeildFull = false;
  bool isSending = false;
  String _selectedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String ? _sendDate;
  late dynamic categoryData = _selectedType[0] ? config.CATEGORY.income : config.CATEGORY.expenses;
  late int selectedCategory = widget.categorieName == '' ? 0 : categoryData.indexWhere((category) => category.name == widget.categorieName) ;

  List<int> selectedTags = [];

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      isFeildFull = amountCtrl.text.isNotEmpty && noteCtrl.text.isNotEmpty;
    }
    _sendDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.date);
    _selectedDate = DateFormat('dd MMMM yyyy').format(widget.date);
    amountCtrl.addListener(() { setIsFull();});
    noteCtrl.addListener(() { setIsFull();});
    if (widget.type == 'income') {
      _selectedType = [true, false];
    }
    if (widget.tags != []) {
      widget.tags.forEach((tag) => selectedTags.add(tag.tagId));
    }
  }

  void showDatePicker(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Date',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: 300,
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
                    showActionButtons: true,
                    onSubmit:(value) {
                      if (value != null) { _onSubmit(value); }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  Future<void> _edit() async {
    setState(() {isSending = true;});
    await TransactionService().editTransaction({
      "transactions_id": widget.transactionsId,
      "categorie_id": categoryData[selectedCategory].categorieId,
      "amount": double.parse(amountCtrl.text),
      "note": noteCtrl.text,
      "transaction_datetime" : _sendDate,
      "fav": '0',
      "tag_id" : selectedTags
      }
    );
    setState(() {isSending = false;});
  }

  Future<void> _create() async {
    setState(() {isSending = true;});
    await TransactionService().addTransaction({
      "categorie_id": categoryData[selectedCategory].categorieId,
      "amount": double.parse(amountCtrl.text),
      "note": noteCtrl.text,
      "transaction_datetime" : _sendDate,
      "fav": 0,
      "tag_id" : selectedTags
      }
    );
    setState(() {isSending = false;});
  }

  void _onSubmit(Object value) {
    if (value is DateTime) {
      setState(() {
          _selectedDate = DateFormat('dd MMMM yyyy').format(value);
          _sendDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(value);
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(onPressed: () =>  {Navigator.pop(context, false)}, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedType.length; i++) {
                              _selectedType[i] = i == index;
                            }
                            categoryData = _selectedType[0] ? config.CATEGORY.income : config.CATEGORY.expenses;
                            selectedCategory = 0;
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderColor: Theme.of(context).colorScheme.secondary,
                        selectedBorderColor: _selectedType[1] ? Colors.red[700] : Colors.green[700],
                        selectedColor: Colors.white,
                        fillColor: _selectedType[1] ? Colors.red[200] : Colors.green[200],
                        color: _selectedType[1] ? Colors.red[400] : Colors.green[400],
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 140.0,
                        ),
                        isSelected: _selectedType,
                        children: transactionType,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        onPressed: () {showDatePicker(context);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.date_range_rounded),
                            const SizedBox(width: 10,),
                            Text(
                              _selectedDate,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputTextFeild(
                      initialValue: widget.note,
                      controller: noteCtrl,
                      infoText: "Name",
                      hintText: "name",
                      obscureText: false
                    ),
                    const SizedBox(height: 10),
                    InputNumber(
                      initialValue: widget.amount,
                      controller: amountCtrl,
                      hintText: '00.00',
                      infoText: 'Amount',
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CupertinoButton(child: 
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 180,
                                  height: 30,
                                  child: Center(child: Text(categoryData[selectedCategory].name))
                                ),
                              )
                            ),
                            onPressed: () => _showDialog(
                              CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 32.0,
                                scrollController: FixedExtentScrollController(
                                  initialItem: selectedCategory,
                                ),
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    selectedCategory = selectedItem;
                                  });
                                },
                                children:
                                  List<Widget>.generate(categoryData.length, (int index) {
                                  return Center(child: Text(categoryData[index].name));
                                }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: config.TAG.tags.map((Tag tag) {
                    return ChoiceChip(
                      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(color: Colors.transparent),
                      ),
                      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
                      selectedColor: Colors.blue.shade300,
                      labelPadding: const EdgeInsets.all(1),
                      label: Text(
                        tag.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      selected: selectedTags.contains(tag.tagId),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTags.add(tag.tagId);
                          } else {
                            selectedTags.remove(tag.tagId);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SubmitButton(
                      btnText: widget.isEdit
                        ? 'Edit'
                        : 'Create',
                      type: isFeildFull && noteCtrl.text.length <= 18 && !isSending ? 1 : 0,
                      onTap: isFeildFull && noteCtrl.text.length <= 18 && !isSending ? () async {
                        widget.isEdit ? await _edit() : await _create();
                        Navigator.pop(context, true);
                      } : null,
                    ),
                    const SizedBox(height: 40,),
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
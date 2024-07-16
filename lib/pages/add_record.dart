import 'package:bechan/models/favourite_transaction_model.dart';
import 'package:bechan/models/tag_model.dart';
import 'package:bechan/services/transaction_service.dart';
import 'package:bechan/widgets/all_favourite.dart';
import 'package:bechan/widgets/card_decoration.dart';
import 'package:bechan/widgets/custom_chip.dart';
import 'package:bechan/widgets/input_number.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:bechan/widgets/show_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bechan/config.dart' as config;

const List<Widget> transactionType = <Widget>[
  Text('Income'),
  Text('Expense')
];

// ignore: must_be_immutable
class AddRecord extends StatefulWidget {
  bool isEdit;
  final int transactionsId;
  final String categorieName;
  final String amount;
  final String note;
  final String detail;
  final String type;
  final DateTime date;
  final int fav;
  List<Tag> tags;
 
  AddRecord({
    super.key,
    bool ? isEdit,
    int ? transactionsId,
    int ? fav,
    String ? categorieName,
    String ? amount,
    String ? note,
    String ? detail,
    String ? type,
    List<Tag> ? tags,
    required this.date,
  }) : amount = amount ?? '',
    isEdit = isEdit ?? false,
    note = note ?? '',
    detail = detail ?? '',
    type = type ?? 'expense',
    transactionsId = transactionsId ?? 0,
    fav = fav ?? 0,
    categorieName = categorieName ?? '',
    tags = tags ?? []
  ;
  @override
  State<AddRecord> createState() => _AddRecordState();
}

enum Menu { upload }

class _AddRecordState extends State<AddRecord> {
  List<bool> _selectedType = <bool>[false, true];
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  TextEditingController detailCtrl = TextEditingController();
  bool isFeildFull = false;
  bool isSending = false;
  String _selectedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  String ? _sendDate;
  late dynamic categoryData = _selectedType[0] ? config.CATEGORY.income : config.CATEGORY.expenses;
  late int selectedCategory = widget.categorieName == '' ? 0 : categoryData.indexWhere((category) => category.name == widget.categorieName) ;
  bool _isShowTags = true;
  bool isFromFav = false;
  List<int> selectedTags = [];
  bool _fav = false;
  final DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      isFeildFull = amountCtrl.text.isNotEmpty;
    }
    amountCtrl.addListener(() { setIsFull();});
    noteCtrl.addListener(() { setIsFull();});
  
    _sendDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.date);
    _selectedDate = DateFormat('dd MMMM yyyy').format(widget.date);
    _fav = widget.fav == 1;
    _isShowTags = !widget.isEdit;
    bool t = widget.type == 'income';
    _selectedType = [t, !t];
    if (widget.tags != []) {
      for (var tag in widget.tags) {
        selectedTags.add(tag.tagId);
      }
    }
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

  void _showTag() {
    setState(() {
    _isShowTags = !_isShowTags;
    });
  }

  Future<void> _edit() async {
    setState(() {isSending = true;});
    await TransactionService().editTransaction({
      "transactions_id": widget.transactionsId,
      "categorie_id": categoryData[selectedCategory].categorieId,
      "amount": double.parse(amountCtrl.text),
      "note": noteCtrl.text,
      "detail": detailCtrl.text,
      "transaction_datetime" : _sendDate,
      "fav": _fav ? 1 : 0,
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
      "detail": detailCtrl.text,
      "transaction_datetime" : _sendDate,
      "fav": _fav ? 1 : 0,
      "tag_id" : selectedTags
      }
    );
    setState(() {isSending = false;});
  }

  void _onSubmit(Object value) {
    if (value is DateTime) {
      setState(() {
          _selectedDate = DateFormat('dd MMMM yyyy').format(value);
          _sendDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(
            DateTime(
              value.year,
              value.month,
              value.day,
              _now.hour,
              _now.minute,
              _now.second,
            )
          );
      });
    }
    Navigator.of(context).pop();
  }

  void _setFavourite(Favourite favouritItem) {
    setState(() {
      isFromFav = true;
      amountCtrl.text = favouritItem.amount.toString();
      bool isIncome = favouritItem.categorieType == 'income';
      _selectedType = [isIncome, !isIncome];
      categoryData = _selectedType[0] ? config.CATEGORY.income : config.CATEGORY.expenses;
      selectedCategory = categoryData.indexWhere((category) => category.categorieId == favouritItem.categorieId) ;
      if (favouritItem.tags != []) {
        for (var tag in favouritItem.tags) {
          selectedTags.add(tag.tagId);
        }
        noteCtrl.text = favouritItem.note;
      }
    });
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // HEAD
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(onPressed: () =>  {Navigator.pop(context, false)}, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                          Text(
                            'Transaction',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          ),
                        ],
                      ),
                      PopupMenuButton<Menu>(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
                        elevation: 5,
                        shadowColor: Theme.of(context).colorScheme.secondary,
                        color: Theme.of(context).colorScheme.onPrimary,
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (Menu item) {},
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            onTap: () => { Navigator.pushNamed(context, '/morePage') },
                            value: Menu.upload,
                            child: const ListTile(
                              leading: Icon(Icons.upload_file_rounded),
                              title: Text('Upload .xlsx file'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          
                // ALL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                
                      // Type
                      Container(
                        decoration: cardDecoration(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
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
                                  color: Theme.of(context).colorScheme.secondary,
                                  // color: _selectedType[1] ? Colors.red[400] : Colors.green[400],
                                  constraints: const BoxConstraints(
                                    minHeight: 35.0,
                                    minWidth: 160.0,
                                  ),
                                  isSelected: _selectedType,
                                  children: transactionType,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                width: 250,
                                child: TextButton(
                                  onPressed: () async {
                                    ShowDatePickerFunction().showDatePicker(context, _onSubmit);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.date_range_rounded, size: 20,),
                                      const SizedBox(width: 10,),
                                      Text(
                                        _selectedDate,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const Icon(Icons.arrow_drop_down_rounded),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Amount
                              InputNumber(
                                initialValue: widget.amount,
                                controller: amountCtrl,
                                hintText: '00.00',
                                infoText: '* Amount',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: cardDecoration(context),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              InputTextFeild(
                                initialValue: widget.note,
                                controller: noteCtrl,
                                infoText: "* Name",
                                hintText: "name",
                                obscureText: false
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: cardDecoration(context),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                          child: Column(
                            children: [
                              CupertinoButton(
                                child: 
                                Container(
                                  height: 35,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Row(
                                      children: [
                                        Expanded(child: Center(child: Text(categoryData[selectedCategory].name))),
                                        SizedBox(
                                          width: 50,
                                          child: Icon(
                                            Icons.arrow_drop_down_rounded,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
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
                              ),
                              // TAG
                              SizedBox(
                                height: 40,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    children: config.TAG.tags.map((Tag tag) {
                                      return _isShowTags || selectedTags.contains(tag.tagId) ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (selectedTags.contains(tag.tagId)) {
                                                selectedTags.remove(tag.tagId);
                                              } else {
                                                selectedTags.add(tag.tagId);
                                              }
                                            });
                                          },
                                          child: CustomChip(
                                            text: tag.name,
                                            selected: selectedTags.contains(tag.tagId),
                                            backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                                            selectedColor: Colors.grey.shade600,
                                          )
                                        ),
                                      ) : const SizedBox();
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                              widget.isEdit || isFromFav ? GestureDetector(onTap: _showTag, child: _isShowTags ? const Text('show less') : const Text('show more')) : const SizedBox(),
                              InputTextFeild(
                                initialValue: widget.detail,
                                controller: detailCtrl,
                                infoText: "Note",
                                hintText: "note",
                                obscureText: false
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      SizedBox(
                        width: 135,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _fav = !_fav;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Favourite'),
                              const SizedBox(width: 10,),
                              Icon(_fav ? Icons.favorite_rounded : Icons.favorite_border_rounded)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
          
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 35,
                      child:
                    !widget.isEdit ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () async {
                              dynamic favouritItem = await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return const AllFavourite();
                                }
                              );
                              if (favouritItem != null) {
                                _setFavourite(favouritItem);
                              }
                            },
                            child: Row(
                              children : [
                                Text ('from your favourite bill', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                Icon(Icons.arrow_drop_down_rounded, color: Theme.of(context).colorScheme.secondary),
                              ]
                            )
                          ),
                        ],
                      ) : const SizedBox(),
                    ),
                      SizedBox(
                        height: 50,
                        width: 320,
                        child: FilledButton(
                          onPressed: isFeildFull && noteCtrl.text.length <= 18 && !isSending ? () async {
                            widget.isEdit ? await _edit() : await _create();
                            Navigator.pop(context, true);
                          } : null,
                          child: Text(
                            widget.isEdit ? 'Edit' : 'Create',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 40,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
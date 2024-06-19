import 'package:bechan/widgets/input_number.dart';
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:flutter/material.dart';

const List<Widget> transactionType = <Widget>[
  Text('income'),
  Text('expense')
];

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final List<bool> _selectedType = <bool>[false, true];
  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();
  bool isFeildFull = false;

  @override
  void initState() {
    super.initState();
    void setIsFull() {
      setState(() { 
        isFeildFull = amountCtrl.text.isNotEmpty && noteCtrl.text.isNotEmpty;
      });
    }
    amountCtrl.addListener(() { setIsFull();});
    noteCtrl.addListener(() { setIsFull();});
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30,),
                Center(
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedType.length; i++) {
                          _selectedType[i] = i == index;
                        }
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
                const SizedBox(height: 30,),
                InputTextFeild(controller: noteCtrl, infoText: "Name", hintText: "name", obscureText: false),
                const SizedBox(height: 30,),
                InputNumber(controller: amountCtrl, hintText: '00.00', infoText: 'Amount',),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          elevation: isFeildFull ? 5 : 0,
          backgroundColor: isFeildFull ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: isFeildFull ? () {
            Navigator.pop(context);
          } : null,
          icon: const Icon(Icons.add),
          label: const Text('Create'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const BottomAppBar(
          padding: EdgeInsets.all(0),
          height: 50,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
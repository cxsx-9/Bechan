import 'package:bechan/widgets/input_textfeild.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  void inputDialog (dynamic context, dynamic textCtrl, Function onSubmit, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: SizedBox(
            height: 50,
              child: InputTextFeild(
                controller: textCtrl,
                infoText: '',
                hintText: 'category',
                obscureText: false),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
              child: const Text('Submit'),
              onPressed: () {
                if (textCtrl.text != '') {
                  onSubmit();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      }
    );
  }

  void alertDialog (dynamic context, Function onSubmit, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
              child: const Text('Submit'),
              onPressed: () {
                onSubmit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void importDialog (dynamic context, String title, String content){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: Text(content),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // onSubmit();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}
import 'package:bechan/widgets/input_textfeild.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  void inputDialog ({dynamic context, dynamic controller, required Function onSubmit, required String title, required String hint}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, textAlign: TextAlign.center,),
          content: SizedBox(
            height: 50,
              child: InputTextFeild(
                controller: controller,
                infoText: '',
                hintText: hint,
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
                if (controller.text != '') {
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
                Navigator.of(context).pop();
                onSubmit();
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
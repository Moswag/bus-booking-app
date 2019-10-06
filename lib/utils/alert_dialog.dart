import 'package:flutter/material.dart';

class MyAlertDialog {
  static void showAlertDialog(
      {String title, String message, BuildContext myContext}) {
    AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  new FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Theme.of(myContext).primaryColorDark,
                    textColor: Theme.of(myContext).primaryColorLight,
                    child: Text('Ok', textScaleFactor: 1.5),
                    onPressed: () {
                      Navigator.pop(myContext);
                    },
                  ),
                ],
              ))
        ]);

    showDialog(context: myContext, builder: (_) => alertDialog);
  }
}

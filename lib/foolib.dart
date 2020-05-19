import 'package:flutter/material.dart';

showAlertDialog({BuildContext context,header,message}) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(header,style: TextStyle(fontSize: 30 ,color: Colors.deepOrange),),
    content: Text(message,style: TextStyle(fontSize: 25,fontStyle: FontStyle.italic,fontWeight: FontWeight.w500)),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
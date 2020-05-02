

import 'package:usb_serial/usb_serial.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';



class Settings extends StatefulWidget {

  Settings({this.udevice,this.uport});
  final UsbDevice udevice;
  final UsbPort uport;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool connected = false;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Center(
              child: Column(children: <Widget>[
                Text( widget.uport != null ? 'Status:${widget.udevice.productName} \n' :" null"),
                ListTile(
                  title: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text To Send',
                    ),
                  ),
                  trailing: RaisedButton(
                    child: Text("Send"),
                    onPressed: widget.uport == null
                        ? null
                        : () async {
                      if (widget.uport == null) {
                        return;
                      }
                      String data = _textController.text + "\r\n";
                      await widget.uport.write(Uint8List.fromList(data.codeUnits));
                      _textController.text = "";
                    },
                  ),
                ),
                Text("Result Data", style: Theme.of(context).textTheme.title),
                ..._serialData,
              ])),
        ));
  }
}



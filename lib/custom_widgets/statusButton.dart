import 'package:flutter/material.dart';

class StatusButton extends StatefulWidget{
  final IconData icon;
  final String text;
  final myfunction;

  StatusButton({this.icon, this.text, this.myfunction});

  @override
  _StatusButtonState createState() => _StatusButtonState();
}

class _StatusButtonState extends State<StatusButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueAccent,
      child: Column(
        children: <Widget>[
          Text(
            "${widget.text}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          IconButton(
            icon: Icon(
              widget.icon,
              color: Colors.white,
            ),
            iconSize: 50.0,
            onPressed: widget.myfunction,
          ),
        ],
      ),
    );
  }
}

/*

import 'package:usb_serial/usb_serial.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';



class UsbService extends StatefulWidget {
  @override
  _UsbServiceState createState() => _UsbServiceState();
}

class _UsbServiceState extends State<UsbService> {
  bool connected = false;
  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();

    if (!await _port.open()) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    print("_getports");
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);

    devices.forEach((device) {
      _ports.add(ListTile(
          leading: Icon(Icons.usb),
          title: Text(device.productName),
          subtitle: Text(device.manufacturerName),
          trailing: RaisedButton(
            child:
            Text(_deviceId == device.deviceId ? "Disconnect" : "Connect"),
            onPressed: () {
              _connectTo(devices[1]).then((res) {
                _getPorts();
              });
            },
          )));
    });

    setState(() {
      print(_ports);
    });
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _status = ("Usb Event $event");
      setState(() {
        var _lastEvent = event;
        _connectTo(event.device);
      });
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('USB Serial Plugin example app'),
          ),
          body: Center(
              child: Column(children: <Widget>[
                Text(
                    _ports.length > 0
                        ? "Available Serial Ports"
                        : "No serial devices available",
                    style: Theme.of(context).textTheme.title),
                ..._ports,
                Text('Status: $_status\n'),
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
                    onPressed: _port == null
                        ? null
                        : () async {
                      if (_port == null) {
                        return;
                      }
                      String data = _textController.text + "\r\n";
                      await _port.write(Uint8List.fromList(data.codeUnits));
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

*/

import 'package:flutter/material.dart';
import '../custom_widgets/controlButton.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool connected = false;
  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();

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
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Table(children: [
            TableRow(children: [
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.arrow_back_ios,
                      text: "FULL OPEN",
                      myfunction: () {
                        print("fafad");
                      })
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.chevron_left,
                      text: "HALF OPEN",
                      myfunction: () {
                        print("fafad");
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.stop,
                      text: "STOP",
                      myfunction: () {
                        print("fafad");
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.chevron_right,
                      text: "HALF CLOSE",
                      myfunction: () {
                        print("fafad");
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                    icon: Icons.arrow_forward_ios,
                    text: "FULL CLOSE",
                    myfunction: _port == null
                        ? null
                        : () async {
                            if (_port == null) {
                              return;
                            }
                            String data = "on" + "\n";
                            await _port
                                .write(Uint8List.fromList(data.codeUnits));
                            _textController.text = "";
                          },
                  )
                ],
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
/*

class UsbService extends StatefulWidget {
  @override
  _UsbServiceState createState() => _UsbServiceState();
}

class _UsbServiceState extends State<UsbService> {
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

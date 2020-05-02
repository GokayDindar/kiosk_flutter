import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'userpage.dart';
import 'settings.dart';
import 'control.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MaterialColor radColor = Colors.lightGreen;
  String data;
  String radiationStatus = "NO RADIATION SAFE";
  bool connected = false;
  UsbPort uport;
  UsbDevice udevice;
  String _status = "Idle";
  List<Widget> uports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

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
        udevice = event.device;
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

    if (uport != null) {
      uport.close();
      uport = null;
    }

    if (device == null) {
      _deviceId = null;
      setState(() {
        _status = "Disconnected";
      });
      return true;
    }

    uport = await device.create();

    if (!await uport.open()) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }

    _deviceId = device.deviceId;
    await uport.setDTR(true);
    await uport.setRTS(true);
    await uport.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        uport.inputStream, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {

      setState(() {
        if (line == "R10"){
          radiationStatus = "WARNING RADIATION ACTIVE";
          radColor = Colors.red;
        }
        else if( line == "R00"){
          radiationStatus = "NO RADIATION SAFE";
          radColor = Colors.lightGreen;
        }
        _serialData.add(Text(line));
        if (_serialData.length > 1) {
          _serialData.clear();
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
    uports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
    setState(() {
      print(uports);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: radColor,
            ),
            Center(
              child: Text( radiationStatus,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 75.0,
        items: <Widget>[
          Icon(Icons.people_outline, size: 55),
          Icon(Icons.settings_ethernet, size: 55),
          Icon(Icons.settings, size: 55),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 350),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: pageLoad(),
    );
  }

  pageLoad() {
    switch (_page) {
      case 0:
        return UserPage();
      case 1:
        return ControlPage(
          port: uport,
        );
      case 2:
        return Settings(
          uport: uport,
          udevice: udevice,
        );
      default:
        return ControlPage();
    }
  }

}




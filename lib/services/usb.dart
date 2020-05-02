import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';
// not using at the moment

class UsbService {
  bool connected = false;
  UsbPort uport;
  UsbDevice udevice;
  String _status = "Idle";
  List<Widget> uports = [];
  List<Widget> serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;

  Future<bool> _connectTo(device) async {
    serialData.clear();

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

      return true;
    }

    uport = await device.create();

    if (!await uport.open()) {
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
      serialData.add(Text(line));
      if (serialData.length > 20) {
        serialData.removeAt(0);
      }
    });
    return true;
  }

  void _getPorts() async {
    print("_getports");
    uports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
  }

  void startConnection() {
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _status = ("Usb Event $event");
      var _lastEvent = event;
      _connectTo(event.device);
    });

    _getPorts();
  }
}

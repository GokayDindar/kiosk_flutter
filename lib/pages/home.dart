import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'userpage.dart';
import 'settings.dart';
import 'control.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';
import '../custom_widgets/statusButton.dart';
import '../foolib.dart';
import '../services/sign.dart';
import '../services/provider.dart';
import '../pages/lock.dart';
import 'package:provider/provider.dart';

String lockstatus = " CONTROL UNLOCKED TAP TO LOCK";
String radiationStatus = "NO RADIATION SAFE";
IconData lockIcon = Icons.lock_open;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MaterialColor radColor = Colors.lightGreen;
  String data;
  bool connected = false, passStatus;
  UsbPort uport;
  UsbDevice udevice;
  String _status = "Idle";
  List<Widget> uports = [];
  List<Widget> _serialData = [];
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  int _deviceId;
  TextEditingController _textController = TextEditingController();
  int _page = 1, bottomNavbarIndex = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int passStatusVisibility = 0;

  @override
  void initState() {
    super.initState();
    print("inited");
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _status = ("Usb Event $event");
      setState(() {
        var _lastEvent = event;
        udevice = event.device;
        _connectTo(event.device);
        connected = true;
      });
    });
    _getPorts();
    _passStatusChecker();
    _lockStatusChecker();
  }

  void _passStatusChecker() {
    Sign().isSignedBefore(UserPage().userName).then((onValue) {
        if (onValue) {
          Provider.of<AllProvider>(context).changePassStatus(1);
        } else {
          Provider.of<AllProvider>(context).changePassStatus(0);
        }
      print("_passStatusChecker triggered");
    });

  }
  void _lockStatusChecker() {
    Sign().getSharedPrefs("lockStatus").then((onValue){
      if (onValue == "locked") {
        Provider.of<AllProvider>(context).changeLockStatus(1);
        Provider.of<AllProvider>(context).changeLockedText("LOCKED! WRITE PIN TO UNLOCK");
        Provider.of<AllProvider>(context).changePageIndex(3);
        Provider.of<AllProvider>(context).changeBarIndex(1);
      } else if(onValue == null){
        Sign().putSharedPref("lockStatus", "unlocked");

      }
    });
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
        if (line == "R10") {
          radiationStatus = "WARNING RADIATION ACTIVE";
          radColor = Colors.red;
        } else if (line == "R00") {
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
    //gets ports also connecting
    print("_getports");
    uports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    print(devices);
    if (devices.length > 0 && !connected) {
      for (int i = 0; i < devices.length; i++) {
        if (devices[i].productName == "USB2.0-Serial") _connectTo(devices[0]);
      }
    }
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
                child: Text(radiationStatus,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            Consumer<AllProvider>(builder: (context, provider, child) {
          return Container(
            color: Colors.blueAccent,
            child: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: provider.bottomBarIndex,
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
                if (Provider.of<AllProvider>(context).lockStatus == 0) {
                  Provider.of<AllProvider>(context).changePageIndex(index);
                  Provider.of<AllProvider>(context).changeBarIndex(index);
                }
              },
            ),
          );
        }),
        body: Container(
          color: Colors.blueAccent,
          child: Consumer<AllProvider>(builder: (context, provider, child) {
            return Column(
              children: <Widget>[
                LockStatus(),
                Expanded(
                  child: pageLoad(provider.pageIndex),
                ),
              ],
            );
          }),
        ));
  }

  pageLoad(i) {
    switch (i) {
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
      case 3:
        return LockPage();
      default:
        return ControlPage();
    }
  }
}

class LockStatus extends StatefulWidget {
  @override
  _LockStatusState createState() => _LockStatusState();
}

class _LockStatusState extends State<LockStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(children: <Widget>[
              IndexedStack(
                  index: Provider.of<AllProvider>(context).lockStatus,
                  children: <Widget>[
                    StatusButton(
                      icon: lockIcon,
                      text: lockstatus,
                      myfunction: () {
                        Sign().isSignedBefore("suser01").then((onValue) {
                          if (onValue != true) {
                            _showAlert(context, "WARNING",
                                "PASSWORD HAS NOT CREATED YET\nGO USER PAGE AND SET IT");
                          } else {
                            Provider.of<AllProvider>(context).changePageIndex(3);
                            Provider.of<AllProvider>(context).changeBarIndex(1);
                          }
                        });
                      },
                    ),
                    Container(),
                  ]),
            ]),
            Column(
              children: <Widget>[
                IndexedStack(
                    index: Provider.of<AllProvider>(context).passStatus,
                    children: <Widget>[
                      Container(
                          child: StatusButton(
                              icon: Icons.vpn_key,
                              text: "PSSWD ISN'T CREATED",
                              myfunction: () {_showAlert(context, "WARNING PASSWORD HAS NOT CREATED YET", "GO TO USER PAGE");})),
                      Container(),
                    ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showAlert(BuildContext context, alert0, alert1) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              alert0,
              style: TextStyle(fontSize: 25),
            ),
            content: Text(
              alert1,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ));
}

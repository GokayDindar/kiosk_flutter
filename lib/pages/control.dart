import 'package:flutter/material.dart';
import '../custom_widgets/controlButton.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:usb_serial/transaction.dart';

class ControlPage extends StatefulWidget {
  final UsbPort port;
  final UsbDevice udevice;

  ControlPage({this.port,this.udevice});
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
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
                        String data = "off" + "\n";
                        widget.port.write(Uint8List.fromList(data.codeUnits));
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                    icon: Icons.arrow_forward_ios,
                    text: "FULL CLOSE",
                    myfunction:() {
                      String data = "on" + "\n";
                      widget.port.write(Uint8List.fromList(data.codeUnits));
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
import 'package:flutter/material.dart';
import '../custom_widgets/controlButton.dart';
import 'package:usb_serial/usb_serial.dart';
import 'dart:typed_data';
import '../services/provider.dart';

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
          margin: EdgeInsets.fromLTRB(50, 50, 50, 150),
          child: Table(children: [
            TableRow(children: [
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.arrow_back_ios,
                      text: "FULL OPEN",
                      myfunction: () {
                        String data = "open" + "\n";
                        widget.port.write(Uint8List.fromList(data.codeUnits));
                      })
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.chevron_left,
                      text: "HALF OPEN",
                      myfunction: () {
                        String data = "halfopen" + "\n";
                        widget.port.write(Uint8List.fromList(data.codeUnits));
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.stop,
                      text: "STOP",
                      myfunction: () {
                        String data = "stop" + "\n";
                        widget.port.write(Uint8List.fromList(data.codeUnits));
                      }),
                ],
              ),
              Column(
                children: <Widget>[
                  new ControlButton(
                      icon: Icons.chevron_right,
                      text: "HALF CLOSE",
                      myfunction: () {
                        String data = "halfclose" + "\n";
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
                      String data = "close" + "\n";
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


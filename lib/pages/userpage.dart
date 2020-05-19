import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';

String label ="";


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();

}

class _UserPageState extends State<UserPage> {
  final NumpadController _numpadController = NumpadController(format: NumpadFormat.NONE);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(190, 50, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                NumpadText(
                  style: TextStyle(fontSize: 40,color: Colors.white),
                  controller: _numpadController,
                  errorColor: Colors.red,
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: Numpad(
                    parentState: this,
                    buttonColor: Colors.white,
                    width: 450,
                    innerPadding: 7,
                    height: 330,
                    controller: _numpadController,
                    buttonTextSize: 40,
                  ),
                ),
                Text(label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

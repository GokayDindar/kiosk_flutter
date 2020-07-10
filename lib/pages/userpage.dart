import 'package:flutter/cupertino.dart';
import '../custom_widgets/controlButton.dart';
import '../custom_widgets/statusButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
  String isLogged = "";
  bool masterPass = false;

  putSharedPref(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}

class _UserPageState extends State<UserPage> {
  NumpadController _numpadController = NumpadController(
    format: NumpadFormat.NONE,
  );

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _isLogged = prefs.getString("UserPassword") ??
        "User Password havent created yet,\nTo Create,\nWrite Master Password First!";
    setState(() {
      widget.isLogged = _isLogged;
    });
  }

  @override
  void initState() {
    widget.isLogged = "";
    getSharedPrefs();
    this._numpadController.addListener(listener);
  }

  Future<String> _showAlert(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("WARNING",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              content: Text(
                "\"${_numpadController.rawString}\" \nWILL BE USER PASS \nOK?\nIF NO PRESS NO AND REWRITE\n",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("ok");
                  },
                ),
                MaterialButton(
                  child: Text(
                    "NO",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop("no");
                  },
                ),
              ],
            ));
  }

  listener() {
    print(_numpadController.rawString);
    if (_numpadController.rawString == "2020" && widget.masterPass == false) {
      print("godsake");
      _numpadController.clear();
      setState(() {
        widget.isLogged =
            "MASTER PASSWORD CORRECT!\nYOU ARE ABOUT TO SET USER PASSWORD\nPLEASE WRITE 4 DIGIT PASS TO CREATE!";
        widget.masterPass = true;
      });
    } else if (widget.masterPass == true &&
        _numpadController.rawString?.length == 4) {
      setState(() {
        _showAlert(context).then((onValue){
          print("YES WE DİD İT$onValue");
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 45),
      child: Container(
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    NumpadText(
                      // top of the numpad
                      style: TextStyle(fontSize: 35, color: Colors.white),
                      controller: _numpadController,
                      errorColor: Colors.red,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Numpad(
                      buttonColor: Colors.white,
                      width: 450,
                      innerPadding: 7,
                      height: 330,
                      controller: _numpadController,
                      buttonTextSize: 40,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(50.0),
                        color: Colors.deepOrange,
                        child: Text(
                          widget.isLogged,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
import '../services/sign.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
  String infoLabel = "",
      topMenuLabel = "",
      userName = "suser01",
      bufferedPassword = "";

      int decisionIndex = 1, topMenu = 1, topMenuLabelStack = 1;

      bool masterPass = false,
      signed = false,
      logged = false,
      passRemovePhase = false,
      passRemoveFlag = false;
      Color topMenuLabelColor = Colors.red;
}

class _UserPageState extends State<UserPage> {
  NumpadController _numpadController = NumpadController(
    format: NumpadFormat.NONE,
  );

  @override
  void initState() {
    super.initState();
  }

  listener() {
    print(widget.masterPass);

    if (_numpadController.rawString == "2020" && widget.masterPass) {
      print("godsake");
      _numpadController.clear();
      setState(() {
        widget.infoLabel =
            "MASTER PASSWORD CORRECT!\nYOU ARE ABOUT TO SET USER PASSWORD\nPLEASE WRITE 4 DIGIT PASS TO CREATE!";
        widget.masterPass = false;
        widget.decisionIndex = 1;
        _numpadController.clear();
      });
    } else if (!widget.masterPass && _numpadController.rawString?.length == 4) {
      setState(() {
        widget.decisionIndex = 0;
        widget.infoLabel =
            "\"${_numpadController.rawString}\" WILL BE USER PASSWORD ? \n IF NOT YOU CAN EDIT NOW";
        widget.masterPass = false;
      });
    }if (!widget.masterPass && widget.passRemovePhase && widget.bufferedPassword == _numpadController.rawString && !widget.passRemoveFlag) {
      setState(() {
        widget.infoLabel = "WRITE AGAIN TO REMOVE ";
        _numpadController.clear();
        widget.passRemoveFlag = true;
      });
    }else if (!widget.masterPass && widget.passRemovePhase && widget.bufferedPassword == _numpadController.rawString && widget.passRemoveFlag) {
      print("clear babe");
      Sign().clearSharedPred().then((onValue) {
        setState(() {
          widget.infoLabel = "         SUCCED         ";
          _numpadController.clear();
          widget.passRemoveFlag = false;
          widget.passRemovePhase = false;
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
        child: IndexedStack(index: widget.topMenu, children: <Widget>[
          Container(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IndexedStack(index: 0, children: <Widget>[
                          Card(
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    widget.infoLabel,
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        IndexedStack(index: widget.decisionIndex, children: <
                            Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 20, 0),
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        try {
                                          Sign().doSign(widget.userName,
                                              _numpadController.rawString);
                                        } catch (e) {
                                          print(e);
                                          widget.infoLabel =
                                              "AN ERROR OCCURED DURING SIGN";
                                        } finally {
                                          widget.infoLabel =
                                              "         SUCCED         ";
                                          widget.decisionIndex = 1;
                                          _numpadController.clear();
                                        }
                                      });
                                    },
                                    child: Text(
                                      "SAVE",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.decisionIndex = 2;
                                          widget.topMenu = 1;
                                          _numpadController.clear();
                                          widget.masterPass = false;
                                        });
                                      },
                                      child: Text(
                                        "EXIT",
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(70, 10, 0, 0),
                                  child: FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        widget.decisionIndex = 2;
                                        widget.topMenu = 1;
                                        widget.masterPass = false;
                                        _numpadController.clear();
                                      });
                                    },
                                    child: Text(
                                      "EXIT",
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox()
                        ])
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              IndexedStack(index: widget.topMenuLabelStack, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: widget.topMenuLabelColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "      ${widget.topMenuLabel}      ",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container()
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.border_color),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            Sign()
                                .isSignedBefore(widget.userName)
                                .then((onValue) {
                                  widget.masterPass = true;
                              if (!onValue) {
                                widget.topMenu = 0;
                                widget.decisionIndex = 1;
                                this._numpadController.addListener(listener);
                                widget.infoLabel =
                                    "FIRST WRITE MASTER PASSWORD!\nIF YOU DONT KNOW, ASK SUPERVISER FOR HELP \nOR CALL MODEDOOR +905386896503\nDevice id:7821";
                              } else {
                                setState(() {
                                  widget.topMenuLabel = "SIGNED BEFORE !!!";
                                  widget.topMenuLabelColor = Colors.red;
                                  widget.topMenuLabelStack = 0;
                                });
                                print("signed before");
                              }
                            });
                          });
                          //Sign().doSign("d123", "userPassword");
                        },
                        iconSize: 90,
                      ),
                      Text(
                        "SIGN IN ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.assignment_ind),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            widget.topMenuLabel = "";
                            widget.topMenuLabelColor = Colors.blueGrey;
                          });
                        },
                        iconSize: 90,
                      ),
                      Text(
                        "LOGIN ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            widget.topMenuLabel = "";
                            widget.topMenuLabelColor = Colors.blueGrey;
                            Sign()
                                .isSignedBefore(widget.userName)
                                .then((onValue) {
                              if (onValue) {
                                widget.topMenu = 0;
                                widget.decisionIndex = 1;
                                this._numpadController.addListener(listener);
                                widget.infoLabel = "FIRST WRITE USER PASSWORD!";
                                Sign()
                                    .getSharedPrefs(widget.userName)
                                    .then((onValue) {
                                  widget.bufferedPassword = onValue;
                                });
                                widget.passRemovePhase = true;
                              } else {
                                setState(() {
                                  widget.topMenuLabel = "NOT SIGNED BEFORE !!!";
                                  widget.topMenuLabelStack = 0;
                                });
                                print("not signed before");
                              }
                            });
                          });
                        },
                        iconSize: 90,
                      ),
                      Text(
                        "REMOVE\nPASSWORD ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}

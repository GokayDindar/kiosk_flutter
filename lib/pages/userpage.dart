import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
import 'package:provider/provider.dart';
import '../services/sign.dart';
import '../pages/home.dart';
import '../services/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();

  String infoLabel = "",
      topMenuLabel = "",
      userName = "suser01",
      bufferedPassword = "";

  int decisionIndex = 1, topMenu = 1, topMenuLabelStack = 1;
  int action = -1;

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
    _numpadController.clear();
  }

  listener() {
    print(widget.masterPass);
    switch(widget.action){
      case 0:{
        if (_numpadController.rawString == "2020") {
          print("godsake");
          _numpadController.clear();
          setState(() {
            widget.infoLabel =
            "MASTER PASSWORD CORRECT!\nYOU ARE ABOUT TO SET USER PASSWORD\nPLEASE WRITE 4 DIGIT PASS TO CREATE!";
            widget.masterPass = true;
            widget.decisionIndex = 1;
            _numpadController.clear();
          });
        } else if ( _numpadController.rawString?.length == 4 && widget.masterPass) {
          setState(() {
            widget.decisionIndex = 0;
            widget.infoLabel =
            "\"${_numpadController.rawString}\" WILL BE USER PASSWORD ? \n IF NOT YOU CAN EDIT NOW";
            widget.masterPass = false;
          });
        }
      }break;
      case 1:{

      }break;
      case 2:{
        if (widget.passRemovePhase && widget.bufferedPassword == _numpadController.rawString && !widget.passRemoveFlag) {
          setState(() {
            widget.infoLabel = "WRITE AGAIN TO REMOVE ";
            _numpadController.clear();
            widget.passRemoveFlag = true;
          });
        } else if (widget.passRemovePhase && widget.bufferedPassword == _numpadController.rawString && widget.passRemoveFlag) {
          Sign().clearSharedPred().then((onValue) {
            setState(() {
              widget.infoLabel = "         SUCCED         ";
              _numpadController.clear();
              widget.passRemoveFlag = false;
              Provider.of<AllProvider>(context).changePassStatus(0);
            });
          });
      }
    }
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
                                          Provider.of<AllProvider>(context).changePassStatus(1);
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
                            _numpadController.clear();
                            widget.action = 0;
                            Sign().isSignedBefore(widget.userName).then((onValue) {
                              if (!onValue) {
                                widget.topMenu = 0;
                                widget.decisionIndex = 1;
                                this._numpadController.addListener(listener);
                                widget.infoLabel =
                                    "FIRST WRITE MASTER PASSWORD!\nIF YOU DONT KNOW, ASK SUPERVISER FOR HELP \nOR CALL MODEDOOR +905386896503\nDevice id:7821";
                              } else {
                                setState(() { //TODO : SET STATE ERROR
                                  widget.topMenuLabel = "SIGNED BEFORE !!!";
                                  widget.topMenuLabelStack = 0;
                                });
                                print("signed before");
                              }
                            });
                          });
                          //Sign().doSign("d123", "userPassword");
                        },
                        iconSize: 80,
                      ),
                      Text(
                        "              CREATE\nOPERATION PASSWORD",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                /*  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.assignment_ind),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _numpadController.clear();
                            widget.topMenuLabelStack = 0;
                            Sign().isSignedBefore(widget.userName).then((onValue) {
                              if(onValue){

                              }
                              else{
                                  widget.topMenuLabelStack = 0;
                                  widget.topMenuLabel = "NOT SIGNED BEFORE !";
                              }
                            });
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
                  ),*/
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _numpadController.clear();
                            widget.topMenuLabelStack = 1;
                            Sign().isSignedBefore(widget.userName).then((onValue) {
                              if (onValue) {
                                widget.action = 2;
                                widget.topMenu = 0;
                                widget.decisionIndex = 1;
                                this._numpadController.addListener(listener);
                                widget.infoLabel = "FIRST WRITE USER PASSWORD!";
                                Sign().getSharedPrefs(widget.userName).then((onValue) {
                                  widget.bufferedPassword = onValue;
                                });
                                widget.passRemovePhase = true;
                              } else {
                                setState(() {
                                  widget.topMenuLabel = "NOT CREATED BEFORE !!!";
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
                        "REMOVE\nCURRENT PASSWORD ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
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

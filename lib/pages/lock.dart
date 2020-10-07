import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_numpad_widget/flutter_numpad_widget.dart';
import 'package:provider/provider.dart';
import '../services/sign.dart';
import '../pages/home.dart';
import '../services/provider.dart';

class LockPage extends StatefulWidget {
  @override
  _LockPageState createState() => _LockPageState();

  static String infoLabel = "ENTER USER PIN TO LOCK!",
      topMenuLabel = "",
      userName = "suser01",
      bufferedPassword = "",
      _pass = "";

  int decisionIndex = 1, topMenu = 1, topMenuLabelStack = 1;
  int action = -1;
  int cancelButtonHide = 0;

  bool masterPass = false,
      signed = false,
      logged = false,
      passRemovePhase = false,
      passRemoveFlag = false;
  Color topMenuLabelColor = Colors.red;
}

class _LockPageState extends State<LockPage> {
  NumpadController _numpadController = NumpadController(
    format: NumpadFormat.NONE,
  );

  @override
  void initState() {
    super.initState();
    print("inside init");
    _numpadController.clear();
    _numpadController.addListener(listener);
    Sign().getSharedPrefs(LockPage.userName).then((onValue) {
      LockPage._pass = onValue;
    });
  }

  listener() {
    print(LockPage._pass);

    if (_numpadController.rawString == LockPage._pass) {
      Sign().getSharedPrefs("lockStatus").then((onValue) {
        print(onValue);
        if (onValue == "unlocked") {
          Provider.of<AllProvider>(context).changeLockStatus(1);
          Provider.of<AllProvider>(context).changeLockedText("LOCKED! WRITE PIN TO UNLOCK");
          _numpadController.clear();
          Sign().putSharedPref("lockStatus", "locked");
        } else if (onValue == "locked") {
          Provider.of<AllProvider>(context).changeLockStatus(0);
          Provider.of<AllProvider>(context).changeLockedText("UNLOCKED! WRITE PIN TO LOCK");
          _numpadController.clear();
          Sign().putSharedPref("lockStatus", "unlocked");
          Provider.of<AllProvider>(context).changePageIndex(1);
          Provider.of<AllProvider>(context).changeBarIndex(1);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 45),
        child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('lib/assets/blur2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(163, 0, 0, 50),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              Provider.of<AllProvider>(context).lockedStatus,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 33,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            NumpadText(
                              // top of the numpad
                              style:
                                  TextStyle(fontSize: 35, color: Colors.white),
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
                    IndexedStack(
                      index: Provider.of<AllProvider>(context).lockStatus,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 362, 0, 0),
                          child: FlatButton(
                            splashColor: Colors.red,
                            onPressed: () {
                              Provider.of<AllProvider>(context)
                                  .changePageIndex(1);
                            },
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.white,
                          ),
                        ),
                        Container(),
                      ],
                    )
                  ]),
            )));
  }
}

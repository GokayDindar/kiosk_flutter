import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'userpage.dart';
import 'settings.dart';
import 'control.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
              color: Colors.lightGreen,
            ),
            Center(
              child: Text("NO RADIATION SAFE",
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
      body: sayfaGetir(),
    );
  }

  sayfaGetir() {
    switch (_page) {
      case 0:
        return UserPage();
      case 1:
        return ControlPage();
      case 2:
        return UsbService();
      default:
        return ControlPage();
    }
  }
}


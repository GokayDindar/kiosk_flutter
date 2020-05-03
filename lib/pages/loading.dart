import 'package:flutter/material.dart';
import '../main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/time.dart';
import 'package:http/http.dart';
import '../services/usb.dart';


class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}


class _LoadingState extends State<Loading> {

  splash()async{
    await Future.delayed(Duration(seconds: 1),(){
      setState(() {
        Navigator.pushReplacementNamed(context, '/pages/home');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "MODEDOOR RADIATION PROTECTION EXPERT", style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60,),
              SpinKitFoldingCube(
                color: Colors.blue,
                size: 70.0,
              ),
            ],
          )),
    );
  }
}







import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';



class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();

  static void getTime (country) async{

    var url = 'http://worldtimeapi.org/timezone/Europe/$country';
    Response response =  await get(url);
    Map map = jsonDecode(response.body);
    print(map['datetime']);

  }
}

class _TimeState extends State<Time> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

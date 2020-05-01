import 'package:flutter/material.dart';
import 'pages/loading.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/pages/loading',
    routes: {
      '/pages/home': (context) => Home(),
      '/pages/loading': (context) => Loading(),
    },
    home: Home(),
  ));
}

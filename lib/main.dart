import 'package:flutter/material.dart';
import 'pages/loading.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(Builder(builder: (context) {
    return ChangeNotifierProvider<AllProvider>(
      create: (context) => AllProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/pages/loading',
        routes: {
          '/pages/home': (context) => Home(),
          '/pages/loading': (context) => Loading(),
        },
        home: Home(),
      ),
    );
  }));
}

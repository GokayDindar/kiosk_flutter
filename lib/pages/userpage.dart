import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.android, size: 160.0, color: Colors.white),
            Text("Users", style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}

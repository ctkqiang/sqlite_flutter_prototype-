import 'package:flutter/material.dart';

class AboutDeveloper extends StatefulWidget {
  @override
  _AboutDeveloperState createState() {
    return _AboutDeveloperState();
  }
}

class _AboutDeveloperState extends State<AboutDeveloper> {
  @override
  Widget build(Object context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://flutter.cn/favicon.ico',
              height: 80,
              width: 80,
            ),
            Text(
              '\n 此軟件是與 "John Melody Me" 開發',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

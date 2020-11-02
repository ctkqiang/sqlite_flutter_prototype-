// * Copyright 2020 John Melody Me
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
//
// * http://www.apache.org/licenses/LICENSE-2.0
//
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/about.dart';
import 'package:sqlite_search_engine/core/permission.dart';
import 'package:sqlite_search_engine/savedata.dart';
import 'package:sqlite_search_engine/search.dart';
import 'package:url_launcher/url_launcher.dart';

class SqliteApplication extends StatefulWidget {
  SqliteApplication({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SqliteApplicationState createState() {
    return _SqliteApplicationState();
  }
}

class _SqliteApplicationState extends State<SqliteApplication> {
  String url = 'https://github.com/johnmelodyme/sqlite_flutter_prototype-.git';

  int _currentIndex = 0;

  final List<Widget> _children = [
    SqliteDemo(),
    SearchDatabase(),
  ];

  @override
  void initState() {
    super.initState();

    requestUserPermission();
  }

  void requestUserPermission() {
    if (Platform.isAndroid) {
      OperatingSystemPermission().requestAndroidUserPermission();
    } else if (Platform.isIOS) {
      OperatingSystemPermission().requestIOSUserPermission();
    } else {
      throw (' -> 此操作系统不支持此軟件');
    }
  }

  void aboutDeveloper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AboutDeveloper();
      }),
    );
  }

  void gotoSource() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw (' -> 未能打開網址');
    }
  }

  AppBar appBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      backgroundColor: Colors.red,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.code),
          onPressed: gotoSource,
        ),
        IconButton(
          tooltip: '關於此軟件開發人員',
          color: Colors.white,
          icon: Icon(Icons.info_outline),
          onPressed: aboutDeveloper,
        ),
      ],
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    BottomNavigationBarItem mainpage = BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '主頁',
    );
    BottomNavigationBarItem searchpage = BottomNavigationBarItem(
      icon: Icon(Icons.search_rounded),
      label: '搜索頁面',
    );
    List<BottomNavigationBarItem> bottombaritems = <BottomNavigationBarItem>[
      mainpage,
      searchpage,
    ];
    BottomNavigationBar bottomNavigationBar = BottomNavigationBar(
      onTap: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black87,
      selectedItemColor: Colors.red,
      currentIndex: _currentIndex,
      items: bottombaritems,
    );
    return bottomNavigationBar;
  }

  @override
  Widget build(BuildContext context) {
    BottomNavigationBar _bottomNavigationBar = bottomNavigationBar();
    Widget bodyLogic = (() {
      if (_currentIndex != 0) {
        return _children[1];
      }
      return _children[0];
    }());
    Scaffold scaffold = Scaffold(
      appBar: appBar(),
      body: bodyLogic,
      bottomNavigationBar: _bottomNavigationBar,
    );
    return scaffold;
  }
}

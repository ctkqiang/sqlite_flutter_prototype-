import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/about.dart';
import 'package:sqlite_search_engine/core/permission.dart';
import 'package:sqlite_search_engine/savedata.dart';
import 'package:sqlite_search_engine/showdata.dart';
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
  int _currentIndex = 0;

  String url = 'https://github.com/johnmelodyme/sqlite_flutter_prototype-.git';

  List<StatefulWidget> _pages = <StatefulWidget>[
    SqliteDemo(),
    ShowData(),
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
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Colors.red),
      currentIndex: _currentIndex,
      showSelectedLabels: true,
      fixedColor: Colors.red,
      selectedLabelStyle: TextStyle(color: Colors.red),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.storage),
          label: '輸入數據',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: '查看資料',
        ),
      ],
    );
  }

  PageView body() {
    return PageView(
      allowImplicitScrolling: true,
      children: <Widget>[
        _pages[_currentIndex],
      ],
    );
  }

  Container floatBtn() {
    return Container(
      child: bottomNavigationBar(),
      padding: EdgeInsets.fromLTRB(
        32,
        0,
        32,
        0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      floatingActionButton: floatBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

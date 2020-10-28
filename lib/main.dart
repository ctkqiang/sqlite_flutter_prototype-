import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/app.dart';

// * https://github.com/johnmelodyme/sqlite_flutter_prototype-.git

void main() {
  DemoSQLLite demoSQLLite = DemoSQLLite();
  runApp(demoSQLLite);
}

class DemoSQLLite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(accentColor: Colors.red,);
    SqliteApplication sqliteApplication = SqliteApplication(title: 'SQLITE 搜索引擎示范');
    MaterialApp main = MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: !!!true,
      title: 'SQL lite demo',
      home: sqliteApplication,
    );
    return main;
  }
}

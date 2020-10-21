import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/app.dart';

void main() {
  runApp(DemoSQLLite());
}

class DemoSQLLite extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: !true,
      title: 'SQL lite demo',
      home: SqliteApplication(title: 'SQLITE 搜索引擎示范'),
    );
  }
}
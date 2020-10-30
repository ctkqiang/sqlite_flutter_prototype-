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
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlite_search_engine/Database/databasehelper.dart';
import 'package:sqlite_search_engine/app.dart';

// * Comment: This prototype , I am using 3 tier architecture and separately distinct  Logic Layer ,
// * UI Component and Database Layer. Which Flutter failed to provide.
// *********************************************************
// * 評論：這個原型，我使用的是3層架構和獨立的邏輯層，
// * UI 組件和數據庫層。哪個Flutter無法提供。
// * Reference 參考URL:  https://github.com/johnmelodyme/sqlite_flutter_prototype-.git

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseHelper.instance.initDatabase();

  DemoSQLLite demoSQLLite = DemoSQLLite();

  runApp(demoSQLLite);
}

class DemoSQLLite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      accentColor: Colors.red,
    );

    SqliteApplication sqliteApplication =
        SqliteApplication(title: 'SQLITE 搜索引擎示范');

    MaterialApp main = MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: !!!true,
      title: 'SQL lite demo',
      home: sqliteApplication,
    );
    return main;
  }
}

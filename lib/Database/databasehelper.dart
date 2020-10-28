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
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class DatabaseHelper {
  DatabaseHelper._();

  // ignore: non_constant_identifier_names
  static String DATABASE_NAME = 'sqldemojohn.db';

  // ignore: non_constant_identifier_names
  static String TABLE_NAME = 'Data';

  // ignore: non_constant_identifier_names
  static String COLUMN_ID = 'id';

  // ignore: non_constant_identifier_names
  static String COLUMN_DATA = 'data';

  static String item;

  // ignore: non_constant_identifier_names
  static int DATABASE_VERSION = 1;

  static DatabaseHelper instance = DatabaseHelper._();

  static Database _database;

  Future<Database> get getDatabase async {
    // * Singleton
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();

    return _database;
  }

  // * 在本地目录中创建数据库
  Future<Database> initDatabase() async {
    Directory dbsDirectory = await getApplicationDocumentsDirectory();
    String path = join(dbsDirectory.path, DATABASE_NAME);
    return await openDatabase(path, version: DATABASE_VERSION, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE $TABLE_NAME("
        "$COLUMN_ID INTEGER PRIMARY KEY,"
        "$COLUMN_DATA TEXT"
        ")",
      );

      print('制造數據庫創建表完畢');
    });
  }

  newData(Data data) async {
    Database db = await getDatabase;
    var table = await db.rawQuery("SELECT MAX(ID)+1 AS ID FROM DATA");
    int id = table.first['id'];
    int raw = await db.rawInsert(
        "INSERT Into Data (id, data)"
        "VALUES (?, ?)",
        [id, data.data]);
    return raw;
  }

  // * 搜數據庫創建表
  getData(int id) async {
    Database db = await getDatabase;

    var res = await db.query("Data", where: "id = ?", whereArgs: [id]);

    return res.isNotEmpty ? Data.fromMap(res.first) : null;
  }

  // * 將數據插入數據庫
  Future<Data> insert(Data data) async {
    Database database = await instance.getDatabase;

    data.id = await database.insert(TABLE_NAME, data.toMap());

    return data;
  }

  // * 查詢數據庫中的所有記錄
  Future<List<Data>> queryAllRecords() async {
    Database database = await instance.getDatabase;

    var result = await database.query("Data");

    List<Data> list = result.isNotEmpty
        ? result.map((d) {
            return Data.fromMap(d);
          }).toList()
        : [];

    return list;
  }

  // * 從數據庫中刪除記錄
  // * @param id get item.id from user input
  Future<int> delete(int id) async {
    Database database = await instance.getDatabase;

    return await database.delete(
      TABLE_NAME,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // * 從表中刪除記錄
  Future<void> clearTable() async {
    Database database = await instance.getDatabase;

    return await database.rawQuery('''DELETE FROM $TABLE_NAME''');
  }

  deleteAll() async {
    Database db = await getDatabase;
    db.rawDelete("Delete * from Data");
  }

  // * 參考 : https://bit.ly/3odxGdV
  // * 問題 : `Unhandled Exception: DatabaseException`
  // * 解法 :  `INSERT INTO Data(data) VALUES(?)', [data.data]`
  // * 引起 : `INSERT INTO Data(data) VALUES(data.data)`
  // * 錯誤 ->  "(1299) SQLITE_CONSTRAINT_NOTNULL
  // * The SQLITE_CONSTRAINT_NOTNULL error code is an extended error code for
  // * SQLITE_CONSTRAINT indicating that a NOT NULL constraint failed."
  // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  // * 保存數據
  void saveData(Data data) async {
    Database databaseClient = await getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction
          .rawInsert("""INSERT INTO $TABLE_NAME(data, id) VALUES(${data.data}, ${data.id});""");
    }).then((value) {
      print('saveDataValue: ---> $value');
    });
  }

  searchData(Data data) async {
    Database databaseClient = await getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction.rawInsert('''
      SELECT * FROM $TABLE_NAME WHERE $COLUMN_DATA LIKE '$data';
      ''');
    }).then((value) {
      print('searchDataValue: ---> $value');
    });
  }
}

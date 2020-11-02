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
  // __init__
  DatabaseHelper._();

  static DatabaseHelper _databaseHelper;

  // ignore: non_constant_identifier_names
  static String DATABASE_NAME = 'johnsqldemo.db';

  // ignore: non_constant_identifier_names
  static String TABLE_NAME = 'Data';

  // ignore: non_constant_identifier_names
  static String COLUMN_ID = 'id';

  // ignore: non_constant_identifier_names
  static String COLUMN_DATA = 'data';

  static String item;

  // ignore: non_constant_identifier_names
  static int DATABASE_VERSION = 2;

  static Database _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.instance;
    }
    return _databaseHelper;
  }

  Future<Database> get _getDatabase async {
    // * Singleton
    if (_database == null) {
      return _database = await initDatabase();
    }

    return _database;
  }

  // * 在本地目录中创建数据库
  initDatabase() async {
    Directory dbsDirectory = await getApplicationDocumentsDirectory();

    String path = join(dbsDirectory.path, '${DATABASE_NAME.toString()}');

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: onCreateDatabase,
      onUpgrade: onUpgradeDatabase,
    );
  }

  void onCreateDatabase(Database db, int version) {
    print('正在制造數據庫創建表.......');
    // * DROP TABLE IF EXISTS `$TABLE_NAME`;
    db.execute(
      """
      CREATE TABLE $TABLE_NAME(
        $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        $COLUMN_DATA TEXT)
      """,
    );
  }

  void onUpgradeDatabase(Database database, int oldVersion, int newVersion) {
    // Migration from old to new ...
  }

  // * 將數據插入數據庫
  Future<int> insert(Data data) async {
    var insertedData = await _getDatabase;

    int _insertData = await insertedData.insert(
      '$TABLE_NAME',
      data.toDataMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return _insertData;
  }

  // * 查詢數據庫中的所有記錄
  Future<Data> fetchData(int id) async {
    var _db = await _getDatabase;
    final Future<List<Map<String, dynamic>>> futureMaps = _db.query(
      '$TABLE_NAME',
      where: 'id = ?',
      whereArgs: [id],
    );

    List<Map<String, dynamic>> fetchedData = await futureMaps;

    if (fetchedData.length != 0) {
      Data _data = Data.fromMap(fetchedData.first);
      return _data;
    }

    return null;
  }

  // * 從數據庫中刪除記錄
  // * @param id get item.id from user input
  Future<int> delete(int id) async {
    Database database = await _getDatabase;

    return await database.delete(
      '$TABLE_NAME',
      where: '$id = ?',
      whereArgs: [id],
    );
  }

  deleteAll() async {
    Database database = await _getDatabase;
    int _deleteAllData = await database.rawDelete('Delete * from Data');

    return _deleteAllData;
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
    Database databaseClient = await _getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction.rawInsert('''
          INSERT INTO $TABLE_NAME(data, id) VALUES(${data.data}, ${data.id});
          ''');
    }).then((value) {
      print('saveDataValue: ---> $value');
    });
  }

  Future<List<Data>> fetchAllData() async {
    Database database = await _getDatabase;
    List<Map<String, dynamic>> response = await database.query('$TABLE_NAME');

    if (response.isNotEmpty) {
      List<Data> datae = response.map((dataMap) {
        return Data.fromMap(dataMap);
      }).toList(growable: true);

      return datae;
    } else {
      return [];
    }
  }

  searchData(Data data) async {
    Database databaseClient = await _getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction.rawInsert('''
      SELECT * FROM $TABLE_NAME WHERE $COLUMN_DATA LIKE '$data';
      ''');
    }).then((value) {
      print('searchDataValue: ---> $value');
    });
  }

  Future closeDatabase() async {
    Database database = await _getDatabase;
    database.close();
  }
}

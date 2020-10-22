import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class DatabaseHelper {
  static Database _database;
  int databseVersion = 2;

  Future<Database> get getDatabase async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();

    return _database;
  }

  // * 在本地目录中创建数据库
  initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'testingsqldemo.db');

    Database theDatabase =
        await openDatabase(path, version: databseVersion, onCreate: _onCreate);

    return theDatabase;
  }

  // * 制造數據庫創建表
  void _onCreate(Database db, int version) async {
    print('正在制造數據庫創建表...');

    await db.execute('CREATE TABLE Data(data TEXT)');

    print('制造數據庫創建表完畢');
  }

  // * 检索数据库数据
  Future<List<Data>> getData() async {
    Database databaseClient = await getDatabase;

    List<Map> list = await databaseClient.rawQuery('SELECT * FROM Data');

    List<Data> data = List();

    int listLength = list.length;

    for (int i = 0; i < listLength; i++) {
      data.add(Data(list[i]['data']));
    }

    print('長度 -> ${listLength.toString()} 個數據已保存');

    return data;
  }

  void saveData(Data data) async {
    Database databaseClient = await getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction.rawInsert(
          'INSERT INTO Data(data) VALUES(?)', [data.data]);
    });
  }
}

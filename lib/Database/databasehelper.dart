import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static String databaseName = 'sqldemojohn.db';
  static String table = 'Data';
  static String columnId = 'id';
  static String columnData = 'data';
  static String item;
  static int databaseVersion = 1;
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

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

    String path = join(documentsDirectory.path, databaseName);

    Database theDatabase =
        await openDatabase(path, version: databaseVersion, onCreate: _onCreate);

    return theDatabase;
  }

  // * 制造數據庫創建表
  void _onCreate(Database db, int version) async {
    print('正在制造數據庫創建表...' +
        '''
        \n
        CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnData FLOAT NOT NULL
        ''');

    await db.execute('''
    CREATE TABLE $table(
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnData FLOAT NOT NULL
    )
    ''');

    print('制造數據庫創建表完畢');
  }

  // * 將數據插入數據庫
  Future<int> insert(Data data) async {
    Database database = await instance.getDatabase;

    int result = await database.insert(table, data.toMap());

    return result;
  }

  // * 查詢數據庫中的所有記錄
  Future<List<Map<String, dynamic>>> queryAllRecords() async {
    Database database = await instance.getDatabase;
    var result = await database.query(table, orderBy: "$columnId DESC");
    return result;
  }

  // * 從數據庫中刪除記錄
  Future<int> delete(int id) async {
    Database database = await instance.getDatabase;
    return await database
        .delete(table, where: '$columnData = ?', whereArgs: [id]);
  }

  // * 從表中刪除記錄
  Future<void> clearTable() async {
    Database database = await instance.getDatabase;
    return await database.rawQuery('''DELETE FROM $table''');
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
          .rawInsert('''INSERT INTO Data(data) VALUES(${data.data})''');
    });
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  
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

  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

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
    String dbsDirectory = await getDatabasesPath();
    return await openDatabase(
      join(dbsDirectory, DATABASE_NAME),
      version: DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  // * 制造數據庫創建表
  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $TABLE_NAME("
      "$COLUMN_ID INTEGER PRIMARY KEY,"
      "$COLUMN_DATA TEXT"
      ")",
    );

    print('制造數據庫創建表完畢');
  }

  Future<List<Data>> getData() async {
    Database db = await getDatabase;

    var data = await db.query(TABLE_NAME, columns: [COLUMN_ID, COLUMN_DATA]);

    List<Data> datalist = List<Data>();

    data.forEach((currentData) {
      Data data = Data.fromMap(currentData);

      datalist.add(data);
    });

    return datalist;
  }

  // * 將數據插入數據庫
  Future<Data> insert(Data data) async {
    Database database = await instance.getDatabase;

    data.id = await database.insert(TABLE_NAME, data.toMap());

    return data;
  }

  // * 查詢數據庫中的所有記錄
  Future<List<Map<String, dynamic>>> queryAllRecords() async {
    Database database = await instance.getDatabase;

    var result = await database.query(TABLE_NAME, orderBy: "$COLUMN_ID DESC");

    return result;
  }

  // * 從數據庫中刪除記錄
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
          .rawInsert('''INSERT INTO Data(data) VALUES(${data.data});''');
    });
  }

  searchData(Data data) async {
    Database databaseClient = await getDatabase;

    await databaseClient.transaction((Transaction transaction) {
      return transaction.rawInsert('''
      SELECT * FROM $TABLE_NAME WHERE $COLUMN_DATA LIKE '$data';
      ''');
    }).then((value) {
      print('Value: ---> $value');
    });
  }
}

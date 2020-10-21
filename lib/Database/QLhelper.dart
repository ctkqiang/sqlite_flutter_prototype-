class SqlHelper {
  static const String _dataname = 'sqlite_demo.db';
  static const int _databaseVersion = 1;

  // * Singleton Class: 
  SqlHelper._();
  static final SqlHelper instance = SqlHelper._();
}
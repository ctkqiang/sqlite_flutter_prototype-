import 'package:sqlite_search_engine/Database/databasehelper.dart';

class Data {
  int id;
  String data;

  Data({this.id, this.data});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      DatabaseHelper.COLUMN_ID: id,
      DatabaseHelper.COLUMN_DATA: data
    };

    if (id != null) {
      map[DatabaseHelper.COLUMN_ID] = id;
    }

    return map;
  }

  Data.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.COLUMN_ID];
    data = map[DatabaseHelper.COLUMN_DATA];
  }
}

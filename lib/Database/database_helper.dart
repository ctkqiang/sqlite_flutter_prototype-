// * https://www.youtube.com/watch?v=tj7Lj9a3fyM&t=2618s
class DatabaseHelper {
  int id;
  String data;

  static const ddata = 'data';
  static const did = 'id';

  DatabaseHelper({this.id, this.data});

  DatabaseHelper.fromMap(Map<String, dynamic> map) {
    id = map[did];
    data = map[ddata];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      ddata: data,
    };

    if (id != null) {
      map[did] = id;
    }

    return map;
  }
}

// * Sample Data ::
DatabaseHelper x = DatabaseHelper(id: 0, data: 'testing');

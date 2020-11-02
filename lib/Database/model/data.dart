class Data {
  int id;
  String data;

  Data({this.id, this.data});

  Map<String, dynamic> toDataMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = id;
    map['data'] = data;

    return map;
  }

  Data.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        data = map['data'];
}

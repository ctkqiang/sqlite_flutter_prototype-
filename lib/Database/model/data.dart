class Data {
  int id;
  String data;

  Data({this.id, this.data});

  Map<String, dynamic> toMap() {
    return {'id': id, 'data': data};
  }
}

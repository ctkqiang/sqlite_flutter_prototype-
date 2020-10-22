import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/databasehelper.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class SqliteDemo extends StatefulWidget {
  SqliteDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SqliteDemoState createState() {
    return _SqliteDemoState();
  }
}

class _SqliteDemoState extends State<SqliteDemo> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();

  String thedata;

  int increment = 0;

  String valid(value) {
    if (value.isEmpty) {
      return '此字段不應留空';
    }

    return null;
  }

  void _saveData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState..save();

      for (int i = 0; i < 1; i++) {
        print('數據已添加 -> ${_nameController.text}');
      }
    }

    Data data = Data(thedata);

    DatabaseHelper databaseHelper = DatabaseHelper();

    print(data.toString());

    print('储存资料中.....');

    databaseHelper.saveData(data);

    if (databaseHelper.getData() == null) {
      throw ('数据为空 NULL');
    }

    print('数据成功保存在数据库成功');
  }

  Container appBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22.0 * 2,
        98.2 * 2,
        22.0 * 2,
        23.2 * 2,
      ),
      child: Form(
        key: _formKey,
        child: inputData(),
      ),
    );
  }

  Column inputData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.network(
          'https://flutter.cn/favicon.ico',
          height: 80,
          width: 80,
        ),
        Divider(
          color: Colors.transparent,
          height: 23.3 * 2.1,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: name(),
        ),
        Text('\n\n'),
        saveData(),
      ],
    );
  }

  RaisedButton saveData() {
    return RaisedButton(
      padding: EdgeInsets.all(10),
      animationDuration: Duration(microseconds: 1),
      color: Colors.red,
      onPressed: _saveData,
      child: Text(
        '保存數據',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  TextFormField name() {
    return TextFormField(
      onSaved: (value) {
        this.thedata = value;
      },
      controller: _nameController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.storage, color: Colors.red),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        hintText: '輸入數據',
      ),
      validator: valid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBody(),
    );
  }
}

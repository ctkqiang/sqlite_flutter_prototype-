import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/database_helper.dart';

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
  DatabaseHelper databaseHelper = DatabaseHelper();

  String valid(value) {
    if (value.isEmpty) {
      return '此字段不應留空';
    }

    return null;
  }

  void _saveData() {
    if (_formKey.currentState.validate()) {
      for (int i = 0; i < 2; i++) {
        print('數據已添加 -> ${_nameController.text}');
        print(databaseHelper.data);
      }
    }
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

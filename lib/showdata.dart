import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/database_helper.dart';

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() {
    return _ShowDataState();
  }
}

class _ShowDataState extends State<ShowData> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  Expanded body() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          0,
        ),
        itemBuilder: (context, int index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.storage_outlined,
                  size: 20.0 * 2,
                ),
                title: Text(_databaseHelper.data),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}

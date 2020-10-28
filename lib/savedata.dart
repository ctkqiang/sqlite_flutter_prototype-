import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/databasehelper.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

// https://www.youtube.com/watch?v=E4yRzqChFxY
// https://github.com/Rahiche/sqlite_demo/blob/master/lib/main.dart
//
// *   this is a prototype of flutter sqflite
// *

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

  TextEditingController _searchController = TextEditingController();

  String thedata;

  int increment = 0;

  bool isChecked = false;

  List<Data> dataArray = List();

  List<Data> dummyData = [
    Data(data: "doraemon"),
    Data(data: "DDadasda"),
    Data(data: "sdfsdfsd"),
    Data(data: "doraemon"),
    Data(data: "DDadasda"),
    Data(data: "sdfsdfsd"),
    Data(data: "doraemon"),
    Data(data: "DDadasda"),
    Data(data: "sdfsdfsd"),
    Data(data: "doraemon"),
    Data(data: "DDadasda"),
    Data(data: "sdfsdfsd"),
  ];

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.getDatabase.then((datalist) {
      print(datalist.toString());
    });
  }

  String valid(value) {
    if (value.isEmpty) {
      return '此字段不應留空';
    }

    return null;
  }

  String validSearch(value) {
    if (value.isEmpty) {
      return '此字段不應留空';
    }

    return null;
  }

  deleteData(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      dataArray.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  FutureBuilder<List<Data>> listData() {
    FutureBuilder dataFutureBuilder = FutureBuilder<List<Data>>(
      future: DatabaseHelper.instance.queryAllRecords(),
      builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
        if (snapshot.hasData) {
          ListView listView = ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Data item = snapshot.data[index];
              Checkbox checkbox = Checkbox(
                value: isChecked,
                onChanged: (bool value) {
                  setState(() {
                    isChecked = true;
                    if (isChecked = true) {
                      DatabaseHelper.instance.delete(item.id);
                    }
                  });
                },
              );
              Dismissible dismissible = Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.white),
                onDismissed: (direction) {
                  print(direction.toString());
                  DatabaseHelper.instance.delete(item.id);
                },
                child: ListTile(
                  title: Text(item.data),
                  leading: Text(item.id.toString()),
                  trailing: checkbox,
                ),
              );
              return dismissible;
            },
          );
          return listView;
        } else {
          Center loading = Center(child: CircularProgressIndicator());
          return loading;
        }
      },
    );
    return dataFutureBuilder;
  }

  FloatingActionButton addButton() {
    FloatingActionButton actionButton = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        Data rnd = dummyData[math.Random().nextInt(dummyData.length)];
        await DatabaseHelper.instance.newData(rnd);
        setState(() {});
      },
    );
    return actionButton;
  }

  Column appBody() {
    Expanded appbodyexpanded = Expanded(
      child: listData(),
    );
    List<Widget> appbodychildren = <Widget>[
      appbodyexpanded,
    ];
    return Column(
      children: appbodychildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    Scaffold mainpage = Scaffold(
      body: appBody(),
      floatingActionButton: addButton(),
    );
    return mainpage;
  }
}

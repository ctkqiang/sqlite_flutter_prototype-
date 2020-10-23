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

  List<Data> dataArray = List();

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.queryAllRecords().then((value) {
      setState(() {
        value.forEach((element) {
          dataArray.add(Data(id: element['id'], data: element['data']));
        });
      });
    }).catchError((error) {
      assert(error != null);
      print(error.toString());
    });
  }

  String valid(value) {
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

  _saveData() async {
    String input = _nameController.text;
    int id = await DatabaseHelper.instance.insert(Data(data: input));

    if (_formKey.currentState.validate()) {
      _formKey.currentState..save();

      for (int i = 0; i < 1; i++) {
        print('數據已添加 -> $input');
      }

      setState(() {
        dataArray.insert(0, Data(id: id, data: input));
      });
    }
  }

  Container appBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        22.0 * 2,
        10.3 * 1,
        22.0 * 2,
        23.2 * 2,
      ),
      child: Form(
        key: _formKey,
        child: inputData(),
      ),
    );
  }

  SizedBox sizedbox() {
    return SizedBox(
      height: 20,
    );
  }

  Container showData() {
    return Container(
      child: (() {
        if (dataArray.isEmpty) {
          return nodata();
        } else {
          return Flexible(
            child: listview(),
          );
        }
      }()),
    );
  }

  ListView listview() {
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == dataArray.length) {
            return null;
          }
          return ListTile(
            title: Text(
              dataArray[index].data,
              style: TextStyle(color: Colors.black),
            ),
            leading: Text(dataArray[index].id.toString()),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  return deleteData(dataArray[index].id);
                }),
          );
        });
  }

  Text nodata() {
    return Text(
      '數據庫中沒有數據',
      style: TextStyle(
        color: Colors.red,
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
        // sizedbox(),
        showData(),
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

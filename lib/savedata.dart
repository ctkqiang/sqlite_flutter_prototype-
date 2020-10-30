// * Copyright 2020 John Melody Me
// * Licensed under the Apache License, Version 2.0 (the "License");
// * you may not use this file except in compliance with the License.
// * You may obtain a copy of the License at
//
// * http://www.apache.org/licenses/LICENSE-2.0
//
// * Unless required by applicable law or agreed to in writing, software
// * distributed under the License is distributed on an "AS IS" BASIS,
// * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// * See the License for the specific language governing permissions and
// * limitations under the License.
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/databasehelper.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

class SqliteDemo extends StatefulWidget {
  SqliteDemo({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _SqliteDemoState createState() {
    return _SqliteDemoState();
  }
}

class _SqliteDemoState extends State<SqliteDemo> {
  // * Declarations :
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _searchController = TextEditingController();

  TextEditingController _inputController = TextEditingController();

  String thedata;

  String hintInput = '在此处插入数据';

  String hintSearch = '在此处搜索现有数据';

  String searchResult = '';

  int increment = 0;

  bool isChecked = false;

  List<Data> dataArray;

  List<Data> dummyData = [
    Data(data: "I love you"),
    Data(data: "you love me"),
    Data(data: "we are happy"),
    Data(data: "family"),
  ];

  // * Logic Layers * //

  @override
  void initState() {
    super.initState();

    DatabaseHelper.instance.initDatabase().then((value) {
      print('制造數據庫創建表完畢');
    });

    DatabaseHelper.instance.getDatabase.then((datalist) {
      print(datalist.toString());
    });
  }

  deleteData(int id) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      dataArray.removeWhere((element) {
        print('Element -> $element');
        return element.id == id;
      });
    });
  }

  saveData() async {
    String _data = _inputController.text;
    int length = math.Random().nextInt(_data.length);
    DatabaseHelper.instance.newData(Data(data: _data, id: length));
    setState(() {});
  }

  searchData() async {
    Data data;
    String _data = _searchController.text;
    int length = math.Random().nextInt(_data.length);
    if (_formKey.currentState.validate()) {
      DatabaseHelper.instance.searchData(Data(data: _data, id: length));
      print(DatabaseHelper.instance
          .searchData(Data(data: _data, id: length))
          .toString());
    }
  }

  // * UI Component * //

  ListView searchResultDialogue() {
    List<Widget> listViewChildren = <Widget>[
      /// Something here
    ];
    ListView listView = ListView(
      children: listViewChildren,
    );
    return listView;
  }

  Future<dynamic> showDialogue() {
    Future dialogue = showDialog(
        context: context,
        builder: (BuildContext context) {
          ListView resultDialogue = searchResultDialogue();
          AlertDialog alertDialogue = AlertDialog(
            title: Text(''),
            content: resultDialogue,
          );
          return alertDialogue;
        });
    return dialogue;
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
              ListTile listTile = ListTile(
                title: Text(item.data),
                leading: Text(item.id.toString()),
                trailing: checkbox,
              );
              Dismissible dismissible = Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.white),
                onDismissed: (direction) {
                  print(direction.toString());
                  DatabaseHelper.instance.delete(item.id);
                },
                child: listTile,
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
    String tooltip = 'Add Dummy Data From Existing Source?';
    FloatingActionButton actionButton = FloatingActionButton(
      elevation: null,
      tooltip: tooltip,
      child: Icon(Icons.add),
      onPressed: () async {
        Data rnd = dummyData[math.Random().nextInt(dummyData.length)];
        await DatabaseHelper.instance.newData(rnd);
        setState(() {});
      },
    );
    return actionButton;
  }

  TextFormField inputDataTextField() {
    BorderRadius borderRadius = BorderRadius.circular(15.0);
    BorderSide borderSide = BorderSide(color: Colors.red);
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    InputDecoration inputDecoration = InputDecoration(
      focusedBorder: outlineInputBorder,
      fillColor: Colors.red,
      hoverColor: Colors.red,
      border: outlineInputBorder,
      hintText: hintInput,
    );
    TextFormField inputTextFormField = TextFormField(
      cursorColor: Colors.red,
      decoration: inputDecoration,
      controller: _inputController,
    );
    return inputTextFormField;
  }

  TextFormField searchBarTextField() {
    BorderRadius borderRadius = BorderRadius.circular(15.0);
    BorderSide borderSide = BorderSide(color: Colors.red);
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
    );
    InputDecoration inputDecoration = InputDecoration(
      focusedBorder: outlineInputBorder,
      fillColor: Colors.red,
      hoverColor: Colors.red,
      border: outlineInputBorder,
      hintText: hintSearch,
    );
    TextFormField searchTextFormField = TextFormField(
      controller: _searchController,
      cursorColor: Colors.red,
      decoration: inputDecoration,
    );
    return searchTextFormField;
  }

  RaisedButton save() {
    TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 17.823);
    Text save = Text(
      '保存',
      style: textStyle,
    );
    return RaisedButton(
      elevation: 6,
      child: save,
      color: Colors.red,
      onPressed: saveData,
    );
  }

  RaisedButton search() {
    TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 17.823);
    Text search = Text('搜索', style: textStyle);
    return RaisedButton(
      elevation: 6,
      child: search,
      color: Colors.red,
      onPressed: searchData,
    );
  }

  Row buttons() {
    RaisedButton savebtn = save();
    RaisedButton searchbtn = search();
    MainAxisAlignment center = MainAxisAlignment.center;
    Text hDivider = Text('\t\t\t\t\t\t\t');
    Text vDivider = Text('\n\n\n\n\n');
    List<Widget> rowChildren = <Widget>[
      vDivider,
      savebtn,
      hDivider,
      searchbtn,
    ];
    Row buttonsRow = Row(
      mainAxisAlignment: center,
      children: rowChildren,
    );
    return buttonsRow;
  }

  Form searchEngine() {
    TextFormField searchEngineInputDataTextField = inputDataTextField();
    TextFormField searchEngineSearchDataTextField = searchBarTextField();
    Divider searchEngineDivider = Divider(
      height: 20,
      color: Colors.transparent,
    );
    Row searchEngineActionButtons = buttons();
    List<Widget> searchEngineColumnChildren = <Widget>[
      searchEngineInputDataTextField,
      searchEngineDivider,
      searchEngineSearchDataTextField,
      searchEngineActionButtons,
    ];
    Column searchEngineColumn = Column(
      children: searchEngineColumnChildren,
    );
    EdgeInsets containerEdgeInsets = EdgeInsets.fromLTRB(30, 40, 30, 0);
    Container searchEngineContainer = Container(
      padding: containerEdgeInsets,
      child: searchEngineColumn,
    );
    Form form = Form(
      key: _formKey,
      child: searchEngineContainer,
    );
    return form;
  }

  Column appBody() {
    Expanded appbodyexpanded = Expanded(
      child: listData(),
    );
    Form appBodySearchEngine = searchEngine();
    Divider appbodydivider = Divider(
      height: 10.122235,
      color: Colors.transparent,
    );
    List<Widget> appbodychildren = <Widget>[
      appBodySearchEngine,
      appbodydivider,
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

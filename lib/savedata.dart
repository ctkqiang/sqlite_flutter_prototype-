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

  TextEditingController _inputController = TextEditingController();

  GlobalKey<RefreshIndicatorState> refreshkey =
      GlobalKey<RefreshIndicatorState>();

  DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  String thedata;

  String hintInput = '在此处插入数据';

  String hintSearch = '在此处搜索现有数据';

  String searchResult = '';

  bool isChecked = false;

  int _increment = 0;

  Data data = Data();

  List<Data> dataArray = [];

  List<Data> dummyData = [
    Data(data: "I love you"),
    Data(data: "you love me"),
    Data(data: "we are happy"),
    Data(data: "family"),
  ];

  // * Logic Layers * //

  void insertData() async {
    String _insertedData = _inputController.text;

    _databaseHelper.insert(Data(
      id: _increment++,
      data: _insertedData,
    ));
    setupList();
  }

  void setupList() async {
    List<Data> datalist = await _databaseHelper.fetchAllData();

    List<Data> _data = datalist;
    print(_data);

    setState(() {
      dataArray = _data;
    });
  }

  void deleteData(int id) async {
    await _databaseHelper.delete(id);

    setState(() {
      _databaseHelper.fetchAllData().then((currentData) {
        return dataArray = currentData;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setupList();
  }

  Future<Null> refreshList() async {
    refreshkey.currentState?.show(atTop: false);
    setState(() {
      setupList();
    });
  }

  // * UI Component * //

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
      onPressed: insertData,
    );
  }

  Widget _buildDataList(List<Data> datalist) {
    ListView datalistView = ListView.builder(
      itemCount: datalist.length,
      itemBuilder: (BuildContext context, int index) {
        Text content = Text(
          '${datalist[index].id.toString()} \n '
          '${datalist[index].data.toString()} \n',
        );

        IconButton deleteContent = IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteData(datalist[index].id);
          },
        );

        List<Widget> listViewBody = <Widget>[
          content,
          deleteContent,
        ];

        Row row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: listViewBody,
        );
        return RefreshIndicator(
          child: row,
          onRefresh: refreshList,
        );
      },
    );
    return Expanded(
      child: datalistView,
    );
  }

  Form searchEngine() {
    TextFormField searchEngineInputDataTextField = inputDataTextField();

    Divider searchEngineDivider = Divider(
      height: 20,
      color: Colors.transparent,
    );
    RaisedButton searchEngineActionButtons = save();
    List<Widget> searchEngineColumnChildren = <Widget>[
      searchEngineInputDataTextField,
      searchEngineDivider,
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
    Form appBodySearchEngine = searchEngine();
    Widget searchEngineListShowData = _buildDataList(dataArray);
    Divider appbodydivider = Divider(
      height: 10.122235,
      color: Colors.transparent,
    );
    List<Widget> appbodychildren = <Widget>[
      appBodySearchEngine,
      appbodydivider,
      searchEngineListShowData,
    ];
    return Column(
      children: appbodychildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    Scaffold mainpage = Scaffold(
      body: appBody(),
    );
    return mainpage;
  }
}

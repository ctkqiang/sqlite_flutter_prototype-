import 'package:flutter/material.dart';

class SearchDatabase extends StatefulWidget {
  @override
  _SearchDatabaseState createState() {
    return _SearchDatabaseState();
  }
}

class _SearchDatabaseState extends State<SearchDatabase> {
  String hintInput = '搜索';

  Form form() {
    TextFormField _searchBar = searchBar();
    Form form = Form(
      child: _searchBar,
    );
    return form;
  }

  TextFormField searchBar() {
    InputDecoration inputDecoration = InputDecoration(
      fillColor: Colors.red,
      hoverColor: Colors.red,
      hintText: hintInput,
    );
    TextFormField searchBarTextFormField = TextFormField(
      decoration: inputDecoration,
    );
    return searchBarTextFormField;
  }

  Column appBody() {
    Form searchBar = form();
    List<Widget> _appBodyChildren = <Widget>[
      searchBar,
    ];

    Column _appBody = Column(
      children: _appBodyChildren,
    );
    return _appBody;
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
      body: appBody(),
    );
    return scaffold;
  }
}

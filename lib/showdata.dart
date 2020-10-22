import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqlite_search_engine/Database/databasehelper.dart';
import 'package:sqlite_search_engine/Database/model/data.dart';

// * 從本地數據庫獲取數據
Future<List<Data>> fetchDataFromLocalDatabase() async {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Data>> data = databaseHelper.getData();

  return data;
}

class ShowData extends StatefulWidget {
  @override
  _ShowDataState createState() {
    return _ShowDataState();
  }
}

class _ShowDataState extends State<ShowData> {
  Container appBody() {
    return Container(
      child: SingleChildScrollView(
        child: component(),
      ),
    );
  }

  Column component() {
    return Column(
      children: <Widget>[
        // * 本地數據庫搜索數據

        // * 顯示數據庫列表
        FutureBuilder<List<Data>>(
          future: fetchDataFromLocalDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot != null) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data[index].data,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.6 * 0.2,
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                      ),
                    ],
                  );
                },
              );
            } else if (snapshot.data.length == 0) {
              return nodata();
            } else {
              return loading();
            }
          },
        ),
      ],
    );
  }

  Container loading() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: CircularProgressIndicator(
        semanticsLabel: '載入中...',
      ),
    );
  }

  Center nodata() {
    return Center(
      child: Text('沒有數據'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO change this
      body: SingleChildScrollView(
        child: Container(
          child: Text('${DatabaseHelper.item}'),
          padding: EdgeInsets.fromLTRB(
            40,
            20,
            40,
            1,
          ),
        ),
      ),
    );
  }
}

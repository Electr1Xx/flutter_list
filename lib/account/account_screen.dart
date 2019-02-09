import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_list_app/account/avatar_upload.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'package:flutter_list_app/routes.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State {
  List data;
  String selected;

  Future getCountryList() async {
    var response = await rootBundle.loadString('assets/countries.json');

    this.setState(() {
      data = json.decode(response);
    });
  }

  @override
  void initState() {
    this.getCountryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(children: [
          AvatarUpload(),
          Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  data != null
                      ? DropdownButton(
                          items: data.map((val) {
                            return DropdownMenuItem(
                              value: val['code'],
                              child: Text(val['name']),
                            );
                          }).toList(),
                          value: selected,
                          hint: Text("Please choose a country"),
                          onChanged: (newVal) {
                            this.setState(() {
                              selected = newVal;
                            });
                          })
                      : LoadingIndicator(),
                  SizedBox(height: 20.0),
                  Container(
                    width: 200,
                    child: RaisedButton(
                        onPressed: () async {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.home, (Route<dynamic> route) {
                            return false;
                          });
                        },
                        child: Text('Save'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                  )
                ],
              ))
        ]),
      )),);
  }
}

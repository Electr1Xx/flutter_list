import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_list_app/account/avatar_upload.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State {
  final _formKey = GlobalKey<FormState>();
  List data;
  String selected;
  String email;
  String name;
  String photoUrl;
  String uid;
  bool isLoading = true;
  bool progressUpload = false;
  bool progressSaveData = false;

  Future getCountryList() async {
    var response = await rootBundle.loadString('assets/countries.json');

    this.setState(() {
      data = json.decode(response);
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('Email');
      name = prefs.getString('name');
      selected = prefs.getString('country');
      photoUrl = prefs.getString('photoUrl');
      uid = prefs.getString('uid');
      isLoading = false;
    });
  }

  void saveUserData() async {
    if (_validateAndSave()) {
      setState(() {
        progressSaveData = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Firestore.instance
          .collection('users')
          .document(uid)
          .updateData({'email': email, 'name': name, 'country': selected});
      await prefs.setString('Email', email);
      await prefs.setString('name', name);
      await prefs.setString('country', selected);
      setState(() {
        progressSaveData = false;
      });
    }
  }

  void uploadFile(image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('avatar-$uid.jpg');
    StorageUploadTask uploadTask = ref.putFile(image);
    if (uploadTask.isInProgress) {
      setState(() {
        progressUpload = true;
      });
    }
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'photoUrl': url});
    await prefs.setString('photoUrl', url);
    await getUserData();
    setState(() {
      progressUpload = false;
    });
  }

  @override
  void initState() {
    this.getCountryList();
    this.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: isLoading
          ? LoadingIndicator()
          : SingleChildScrollView(
              child: Container(
              child: Column(children: [
                !progressUpload
                    ? AvatarUpload(photoUrl: photoUrl, uploadFile: uploadFile)
                    : Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          height: 150.0,
                          width: 150.0,
                        )),
                Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              initialValue: email,
                              onSaved: (value) => email = value,
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                              ),
                              initialValue: name,
                              onSaved: (value) => name = value,
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
                              child: progressSaveData
                                  ? LoadingIndicator()
                                  : RaisedButton(
                                      onPressed: () {
                                        saveUserData();
                                      },
                                      child: Text('Save'),
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                            )
                          ],
                        )))
              ]),
            )),
    );
  }
}

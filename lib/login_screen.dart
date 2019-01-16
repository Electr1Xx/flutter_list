import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'dart:async';

import 'package:flutter_list_app/routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FormState();
}

class FormState extends State {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  Container LoginButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      width: 200,
      child: RaisedButton(
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            await Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                isLoading = false;
              });
            });
            Navigator.pushNamedAndRemoveUntil(context, Routes.sports,
                (Route<dynamic> route) {
              return false;
            });
          },
          child: Text('Login'),
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'http://autodoktor.com.ua/wp-content/uploads/Logo/Total-logo-earth.png',
                          width: 200,
                          height: 200,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                color: _obscureText
                                    ? Colors.black38
                                    : Colors.blue[400],
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                          obscureText: _obscureText,
                        ),
                        isLoading
                            ? Container(
                                padding:
                                    EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 12),
                                child: LoadingIndicator())
                            : LoginButton(),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 35,
                                child: FlatButton(
                                  child: Text('Forgot password?'),
                                  textColor: Colors.blue,
                                  onPressed: () {},
                                ),
                              ),
                              Container(
                                  height: 35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Don't have an account?"),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: FlatButton(
                                            child: Text('Sign up'),
                                            textColor: Colors.blue,
                                            onPressed: () {},
                                          ))
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    )))));
  }
}

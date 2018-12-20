import 'package:flutter/material.dart';
import 'package:flutter_list_app/home_screen.dart';
import 'package:flutter_list_app/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/': (BuildContext context) => HomeScreen()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_list_app/account/account_screen.dart';
import 'package:flutter_list_app/sports_screen.dart';
import 'package:flutter_list_app/login_screen.dart';
import 'package:flutter_list_app/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.login,
      routes: {
        Routes.login: (BuildContext context) => LoginScreen(),
        Routes.home: (BuildContext context) => SportsScreen(),
        Routes.account: (BuildContext context) => AccountScreen()
      },
    );
  }
}

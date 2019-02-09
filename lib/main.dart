import 'package:flutter/material.dart';
import 'package:flutter_list_app/account/account_screen.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/authPage.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:flutter_list_app/about_us.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.auth,
      routes: {
        Routes.auth: (BuildContext context) => AuthPage(auth: Auth(),),
        Routes.account: (BuildContext context) => AccountScreen(),
        Routes.aboutUs: (BuildContext context) => AboutUsScreen(),
      },
    );
  }
}

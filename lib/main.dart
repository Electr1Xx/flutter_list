import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_app/account/account_screen.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/authPage.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:flutter_list_app/about_us.dart';

void main() async {
  final Firestore firestore = Firestore();
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
}

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
        Routes.auth: (BuildContext context) => AuthPage(
              auth: Auth(),
            ),
        Routes.account: (BuildContext context) => AccountScreen(),
        Routes.aboutUs: (BuildContext context) => AboutUsScreen(),
      },
    );
  }
}

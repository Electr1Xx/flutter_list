import 'package:flutter/material.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_list_app/auth.dart';


class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key, this.onSignedOutDrawer})
      : super(key: key);

  final VoidCallback onSignedOutDrawer;

  @override
  State<StatefulWidget> createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {

  String email;

  void initState () {
    getEmail();
  }

  void getEmail () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('Email');
    });
  }
  @override
  Drawer build(BuildContext context) {
     return Drawer(
      child:  ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(email ?? ''),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('About us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.aboutUs);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {Navigator.pop(context); widget.onSignedOutDrawer(); },
          ),
        ],
      )
    );
  }

  void onTabTapped() {

  }
}


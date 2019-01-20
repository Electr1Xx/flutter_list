import 'package:flutter/material.dart';
import 'package:flutter_list_app/routes.dart';

class DrawerWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State {

  @override
  Drawer build(BuildContext context) {
     return Drawer(
      child:  ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('About us'),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
        ],
      )
    );
  }

  void onTabTapped() {

  }
}


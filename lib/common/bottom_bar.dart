import 'package:flutter/material.dart';
import 'package:flutter_list_app/routes.dart';

class BottomBar extends StatefulWidget {
  final currentIndex;

  BottomBar(this.currentIndex);

  @override
  State<StatefulWidget> createState() => BottomBarState(this.currentIndex);
}

class BottomBarState extends State {
  final currentIndex;

  BottomBarState(this.currentIndex);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.list),
          title: new Text('Sports'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.list),
          title: new Text('Leagues'),
        )
      ],
    );
  }

  void onTabTapped(index) {
    if (currentIndex != index) {
      index == 0
          ? Navigator.pushNamedAndRemoveUntil(context, Routes.home,
              (Route<dynamic> route) {
              return false;
            })
          : Navigator.pushNamedAndRemoveUntil(context, Routes.home,
              (Route<dynamic> route) {
              return false;
            });
    }
  }
}

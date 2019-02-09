
import 'package:flutter/material.dart';
import 'package:flutter_list_app/auth.dart';
import 'package:flutter_list_app/common/drawer.dart';
import 'package:flutter_list_app/leagues/leagues_screen.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:flutter_list_app/sports/sports_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomePage> {
  bool isLoading = true;
  int currentIndex = 0;

  List routes = [SportsScreen(),LeaguesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Leagues'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => {},
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: logout,
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () => Navigator.pushNamed(context, Routes.account),
            )
          ],
        ),
        body: routes[currentIndex],
        drawer: DrawerWidget(onSignedOutDrawer: logout,),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon:  Icon(Icons.list),
              title:  Text('Sports'),
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.list),
              title:  Text('Leagues'),
            )
          ],
        ));
  }

  void logout  () async {
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  void onTabTapped(index) {
    setState(() {
      currentIndex = index;
    });
  }




}

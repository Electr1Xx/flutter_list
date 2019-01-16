import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/bottom_bar.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'package:flutter_list_app/leagues/leagues_teams_screen.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:flutter_list_app/sports/sports_item_screen.dart';
import 'package:http/http.dart' as http;

class LeaguesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaguesScreenState();
}

class LeaguesScreenState extends State {
  bool isLoading = true;
  int currentIndex = 1;
  String url = 'https://www.thesportsdb.com/api/v1/json/1/all_leagues.php';
  List data;

  Future<List> getList() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var res = json.decode(response.body);
        data = res['leagues'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load list');
    }
  }

  @override
  void initState() {
    this.getList();
  }

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
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, Routes.login, (Route<dynamic> route) {
                    return false;
                  }),
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, Routes.account, (Route<dynamic> route) {
                    return false;
                  }),
            )
          ],
        ),
        body: isLoading
            ? LoadingIndicator()
            : ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, index) {
                  bool last = data.length == (index + 1);
                  return ListItem(data[index], last);
                },
              ),
        bottomNavigationBar: BottomBar(currentIndex));
  }
}

class ListItem extends StatelessWidget {
  ListItem(this.data, this.last);

  final data, last;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        color: Colors.white30,
        child: ListTile(
            title: Text(data['strLeague']),
            subtitle: Text(data['strSport']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaguesTeamsScreen(data['strLeague']),
                ),
              );
            }),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/bottom_bar.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'package:flutter_list_app/leagues/leagues_team_screen.dart';
import 'package:flutter_list_app/routes.dart';
import 'package:http/http.dart' as http;

class LeaguesTeamsScreen extends StatefulWidget {
  final leagueName;

  LeaguesTeamsScreen(this.leagueName);

  @override
  State<StatefulWidget> createState() =>
      LeaguesTeamsScreenState(this.leagueName);
}

class LeaguesTeamsScreenState extends State {
  final leagueName;

  LeaguesTeamsScreenState(this.leagueName);

  bool isLoading = true;
  List data;
  String url;

  @override
  void initState() {
    url =
        'https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=$leagueName';
    this.getList();
  }

  Future<List> getList() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var res = json.decode(response.body);
        data = res['teams'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Teams'),
        ),
        body: isLoading ? LoadingIndicator() : _buildCarousel());
  }

  Widget _buildCarousel() {
    return data == null
        ? Center(
            child: Text('No teams'),
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 400.0,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.8),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return _buildCarouselItem(
                        context, itemIndex, data[itemIndex]);
                  },
                ),
              )
            ],
          );
  }

  Widget _buildCarouselItem(BuildContext context, int itemIndex, data) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Hero(
            tag: data['strTeam'],
            child: SingleChildScrollView(
                child: Container(
              height: 400,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(children: [
                data['strTeamBadge'] != null
                    ? Image.network(
                        data['strTeamBadge'],
                        height: 280,
                      )
                    : Text('No image'),
                SizedBox(height: 20),
                Text(
                  data['strTeam'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                )
              ]),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 5.0,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ))),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaguesTeamScreen(data),
            ));
      },
    );
  }
}

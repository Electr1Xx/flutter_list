import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_app/common/bottom_bar.dart';
import 'package:flutter_list_app/common/drawer.dart';
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
  String selectedSport = 'All';
  String selectedCountry = 'All';
  String url = 'https://www.thesportsdb.com/api/v1/json/1/all_leagues.php';
  String urlSports = 'https://www.thesportsdb.com/api/v1/json/1/all_sports.php';
  List data;
  List sportsList;
  List countryList;

  Future<List> getList() async {
    final response = await http.get(url);
    final responseSports = await http.get(urlSports);
    if (response.statusCode == 200 && responseSports.statusCode == 200) {
      setState(() {
        var res = json.decode(response.body);
        var resSports = json.decode(responseSports.body);
        data = res['leagues'];
        sportsList = resSports['sports'];
        sportsList.insert(0,{'strSport': "All"});
      });
      isLoading = false;

    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<List> getCountryList() async {
    var response = await rootBundle.loadString('assets/countries.json');

    this.setState(() {
      countryList = json.decode(response);
      countryList.insert(0,{'name': 'All'});
    });
  }

  @override
  void initState() {
    this.getList();
    this.getCountryList();
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
              onPressed: () => Navigator.pushNamed(
                      context, Routes.account),
            )
          ],
        ),
        body: isLoading
            ? LoadingIndicator()
            : Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    sportsList != null && countryList != null
                        ? Column(children: <Widget>[
                            Container(
                                width: 350.0,
                                height: 50,
                                child: DropdownButton(
                                    items: sportsList.map((val) {
                                      return DropdownMenuItem(
                                        value: val['strSport'],
                                        child: val['strSport'] == 'All' ? Text('All sports') : Text(val['strSport']),
                                      );
                                    }).toList(),
                                    value: selectedSport,
                                    hint: Text("Sport"),
                                    isExpanded: true,
                                    onChanged: (newVal) {
                                      this.setState(() {
                                        selectedSport = newVal;
                                        this.updateLeagues();
                                      });
                                    })),
                            Container(
                                width: 350.0,
                                height: 50,
                                child: DropdownButton(
                                    items: countryList.map((val) {
                                      return DropdownMenuItem(
                                        value: val['name'],
                                        child: val['name'] == 'All' ? Text('All countries') : Text(val['name']),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    value: selectedCountry,
                                    hint: Text("Country"),
                                    onChanged: (newVal) {
                                      this.setState(() {
                                        selectedCountry = newVal;
                                        this.updateLeagues();
                                      });
                                    }))
                          ])
                        : LoadingIndicator(),
                  ],
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
                Flexible(
                    child: data == null
                        ? Center(
                            child: Text("No leagues"),
                          )
                        : ListView.builder(
                            itemCount: data == null ? 0 : data.length,
                            itemBuilder: (context, index) {
                              bool last = data.length == (index + 1);
                              return ListItem(data[index], last);
                            },
                          )),
              ]),
        bottomNavigationBar: BottomBar(currentIndex));

  }

  Future updateLeagues() async {
    String urlCountry =
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$selectedCountry';
    String urlSport =
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?s=$selectedSport';
    String urlCountryAndSport =
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$selectedCountry&s=$selectedSport';
    var response;
    var key;
    isLoading = true;

    if (selectedSport == 'All' && selectedCountry == 'All') {
      response = await http.get(url);
      key = 'leagues';
    } else {
      if (selectedSport != 'All' && selectedCountry != 'All') {
        response = await http.get(urlCountryAndSport);
      } else if (selectedSport != 'All' && selectedCountry == 'All') {
        response = await http.get(urlSport);
      } else {
        response = await http.get(urlCountry);
      }
      key = 'countrys';
    }

    if (response.statusCode == 200) {
      setState(() {
        var res = json.decode(response.body);
        data = res[key];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load list');
    }
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

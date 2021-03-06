import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/loading_indicator.dart';
import 'package:flutter_list_app/sports/sports_item_screen.dart';
import 'package:http/http.dart' as http;

class SportsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SportsScreenState();
}

class SportsScreenState extends State {
  bool isLoading = true;
  String url = 'https://www.thesportsdb.com/api/v1/json/1/all_sports.php';
  List data;

  Future<List> getList() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var res = json.decode(response.body);
        data = res['sports'];
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
    return isLoading
            ? LoadingIndicator()
            : ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, index) {
                  bool last = data.length == (index + 1);
                  return ListItem(data[index], last);
                },
              );
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
              leading: CircleAvatar(backgroundImage: NetworkImage(
                data['strSportThumb'],
              ),radius: 23,),
              title: Text(data['strSport']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportsItemScreen(data),
                  ),
                );
              }),
        ));
  }
}

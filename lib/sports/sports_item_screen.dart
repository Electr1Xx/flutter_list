import 'package:flutter/material.dart';

class SportsItemScreen extends StatelessWidget {
  SportsItemScreen(this.sport);

  final sport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sport['strSport'])),
      body: SingleChildScrollView(
        child: Container(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              SizedBox(height: 20.0),
              Center(
                child: Image.network(
                  sport['strSportThumb'],
                ),
              ),
              SizedBox(height: 20.0),
              Text(sport['strSport'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(sport['strSportDescription']),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LeaguesTeamScreen extends StatelessWidget {
  LeaguesTeamScreen(this.team);

  final team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(team['strTeam'])),
        body: Hero(
          tag: team['strTeam'],
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.blueGrey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: team['strTeamBadge'] != null
                        ? Image.network(
                            team['strTeamBadge'],
                            height: 250,
                          )
                        : Text('No image'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(team['strTeam'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  SizedBox(
                    height: 20,
                  ),
                  teamTable(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('About team',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(team['strDescriptionEN']),
                ],
              ),
            ),
          ),
        ));
  }

  Table teamTable() {
    return Table(border: TableBorder.all(), children: [
      tableRow('Short name', team['strTeamShort']),
      tableRow('Formed', team['intFormedYear']),
      tableRow('Sport', team['strSport']),
      tableRow('League', team['strLeague']),
      tableRow('Manager', team['strManager']),
      tableRow('Alternate', team['strAlternate']),
    ]);
  }

  TableRow tableRow(name, desc) {
    return TableRow(
      children: [
        TableCell(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              name != null && name != '' ? Text(name) : Text('Empty'),
              desc != null && desc != '' ? Text(desc) : Text('Empty'),
            ],
          ),
        ))
      ],
    );
  }
}

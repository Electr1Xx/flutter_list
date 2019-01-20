import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_pro/carousel_pro.dart';


class LeaguesTeamScreen extends StatefulWidget {
  LeaguesTeamScreen(this.team);

  final team;

  @override
  State<StatefulWidget> createState() => LeaguesTeamScreenState(this.team);
}

class LeaguesTeamScreenState extends State {
  LeaguesTeamScreenState(this.team);


  var countSocialLinks = 0;
  final team;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(team['strTeam'])),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blueGrey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Hero(
                  tag: team['strTeam'],
                  child: Center(
                    child: team['strTeamBadge'] != null
                        ? Image.network(
                            team['strTeamBadge'],
                            height: 250,
                          )
                        : Text('No image'),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(team['strTeam'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(
                height: 20,
              ),
              teamTable(),
              SizedBox(
                height: 20,
              ),
              Text('About team',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              team['strDescriptionEN'] != null && team['strDescriptionEN'] != ''
                  ? Text(team['strDescriptionEN'])
                  : Text('No description'),
              SizedBox(
                height: 20,
              ),
              Text('Stadium',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Center(
                child: team['strStadiumThumb'] != null
                    ? Image.network(
                        team['strStadiumThumb'],
                        height: 250,
                      )
                    : Text('No image'),
              ),
              SizedBox(
                height: 10,
              ),
              team['strStadium'] != null
                  ? Text(team['strStadium'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                  : Text(''),
              SizedBox(
                height: 20,
              ),
              stadiumTable(),
              SizedBox(
                height: 20,
              ),
              team['strStadiumDescription'] != null
                  ? Text(team['strStadiumDescription'])
                  : Text(''),
              SizedBox(
                height: 20,
              ),
              imagesTeam.length != 0
                  ? photosTeam()
                  : SizedBox(
                      height: 1,
                    ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  socialImage('assets/images/rss.png', team['strRSS'], 'false'),
                  socialImage('assets/images/facebook.png', team['strFacebook'],
                      'true'),
                  socialImage(
                      'assets/images/insta.png', team['strInstagram'], 'true'),
                  socialImage(
                      'assets/images/twitter.png', team['strTwitter'], 'true'),
                  socialImage(
                      'assets/images/youtube.png', team['strYoutube'], 'true'),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
              )
            ],
          ),
        ),
      ));
  }

  socialImage(img, url, httpNeed) {
    if (url != null && url != '') {
      return Padding(
        child: InkWell(
            child: Image.asset(img, scale: 2.0, width: 48.0, height: 48.0),
            onTap: () {
              _launchURLSocial(url, httpNeed);
            }),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      );
    } else {
      return Container();
    }
  }

  Table teamTable() {
    return Table(border: TableBorder.all(), children: [
      tableRow('Short name', team['strTeamShort']),
      tableRow('Formed', team['intFormedYear']),
      tableRow('Sport', team['strSport']),
      tableRow('League', team['strLeague']),
      tableRow('Manager', team['strManager']),
      tableRow('Alternate', team['strAlternate']),
      TableRow(
        children: [
          TableCell(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Website'),
                InkWell(
                  child: team['strWebsite'] != null && team['strWebsite'] != ''
                      ? Text(
                          team['strWebsite'],
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.lightBlueAccent),
                        )
                      : Text('Empty'),
                  onTap: () {
                    if (team['strWebsite'] != null &&
                        team['strWebsite'] != '') {
                      _launchURL(team['strWebsite']);
                    }
                  },
                )
              ],
            ),
          ))
        ],
      )
    ]);
  }

  _launchURL(url) async {
    await launch('http://$url');
  }

  _launchURLSocial(url, httpTrue) async {
    if (httpTrue == 'true') {
      await launch('http://$url');
    } else {
      await launch(url);
    }
  }

  Table stadiumTable() {
    return Table(border: TableBorder.all(), children: [
      tableRow('Location', team['strStadiumLocation']),
      tableRow('Capacity', team['intStadiumCapacity']),
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
              Text(name),
              desc != null && desc != '' ? Text(desc) : Text('Empty'),
            ],
          ),
        ))
      ],
    );
  }

  SizedBox photosTeam() {
    return SizedBox(
      height: 250.0,
      width: 390,
      child: Carousel(
        images: imagesTeam,
        boxFit: BoxFit.fill,
      ),
    );
  }

  List imagesTeam = List();

  void initState() {
    networkImage(team['strTeamBadge']);
    networkImage(team['strTeamJersey']);
    networkImage(team['strTeamLogo']);
    networkImage(team['strTeamFanart1']);
    networkImage(team['strTeamFanart2']);
    networkImage(team['strTeamFanart3']);
    networkImage(team['strTeamFanart4']);
  }

  networkImage(photo) {
    if (photo != null && photo != '') {
      imagesTeam.add(NetworkImage(photo));
    }
  }
}

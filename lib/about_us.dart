import 'package:flutter/material.dart';
import 'package:flutter_list_app/common/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_pro/carousel_pro.dart';


class AboutUsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutUsState();
}

class AboutUsState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('About us')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

              ],
            ),
          ),
        ));
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

}

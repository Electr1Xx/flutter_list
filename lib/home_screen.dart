import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (Route<dynamic> route) {
                  return false;
                }),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListItem();
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('Test')),
      title: Text('Something'),
      subtitle: Text('Something'),
      trailing: Icon(Icons.arrow_right),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUpload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AvatarUploadState();
}

class AvatarUploadState extends State {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: IconButton(
          iconSize: 150,
          icon: _image == null
              ? Icon(Icons.account_circle, color: Colors.blue)
              : CircleAvatar(
                  backgroundImage: AssetImage(_image.path),
                  radius: 150,
                ),
          onPressed: uploadAvatarDialog),
    ));
  }

  Future uploadAvatarDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload avatar"),
            content: Text("Take photo or choose image from gallery"),
            actions: <Widget>[
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("Camera"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.camera);

                  setState(() {
                    _image = image;
                  });
                },
              ),
              FlatButton(
                child: new Text("Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);

                  setState(() {
                    _image = image;
                  });
                },
              ),
            ],
          );
        });
  }
}

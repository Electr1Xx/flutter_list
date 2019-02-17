import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUpload extends StatefulWidget {
  AvatarUpload({Key key, this.photoUrl, this.uploadFile}) : super(key: key);
  final String photoUrl;
  final Function uploadFile;

  @override
  State<StatefulWidget> createState() => AvatarUploadState();
}

class AvatarUploadState extends State<AvatarUpload> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: IconButton(
          iconSize: 150,
          icon: widget.photoUrl == ''
              ? Icon(Icons.account_circle, color: Colors.blue)
              : CircleAvatar(
                  backgroundImage: widget.photoUrl != '' && _image == null
                      ? NetworkImage(widget.photoUrl)
                      : AssetImage(_image.path),
                  radius: 150,
                  backgroundColor: Colors.transparent,
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
                  widget.uploadFile(image);
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
                  widget.uploadFile(image);
                },
              ),
            ],
          );
        });
  }
}

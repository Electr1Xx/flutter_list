import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutUsState();
}

class AboutUsState extends State {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('About us')),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                          child: Text("Play Video"),
                          onPressed: playYoutubeVideo),
                      RaisedButton(
                          child: const Text('Set marker'),
                          onPressed: mapController == null
                              ? null
                              : () {
                                  mapController.addMarker(
                                    MarkerOptions(
                                      position: LatLng(50.019257, 36.221960),
                                    ),
                                  );
                                }),
                    ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,10.0, 0, 0),
                  child: Center(
                    child: SizedBox(
                      height: 500.0,
                      child: GoogleMap(
                        options: GoogleMapOptions(
                          myLocationEnabled: true,
                          cameraPosition: CameraPosition(
                            target: const LatLng(50.019257, 36.217460),
                            zoom: 15.0,
                          ),
                        ),
                        onMapCreated: _onMapCreated,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
        apiKey: "<API_KEY>",
        videoUrl: "https://www.youtube.com/watch?v=fq4N0hgOWzU",
        autoPlay: true);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}

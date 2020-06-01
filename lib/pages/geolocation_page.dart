import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class GeolocationPage extends StatelessWidget {

  final dynamic data;
  GeolocationPage({
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Geolocation'),
        titleSpacing: -1.0,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(data.latitude, data.longitude),
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                height: 45.0,
                width: 45.0,
                point: LatLng(data.latitude, data.longitude),
                builder: (context) => Container(
                  child: IconButton(
                    tooltip: data.name,
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {}
                  ),
                )
              )
            ]
          )
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(
                0.0,
                0.0,
              ),
            )
          ],
        ),
        width: double.infinity,
        height: 180.0,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(data.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),

            SizedBox(height: 15.0),

            Text.rich(
              TextSpan(
                text: "Timings: ",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: data.timings,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.0),

            Text.rich(
              TextSpan(
                text: "Rating: ",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: "${data.rating}⭐    (${data.votes})",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
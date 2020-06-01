import 'dart:convert';
import 'package:foodspace/shared/constants.dart';
import 'package:foodspace/widgets/carousel_template.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  final dynamic cityId, cityName;
  HomePage({
    this.cityId,
    this.cityName
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<dynamic>> _getCityCollectionIds() async {
    var reqData = await http.get("https://developers.zomato.com/api/v2.1/collections?city_id=${widget.cityId}",
    headers: {"user-key": YOUR_ZOMATO_API_KEY});
    var jsonData = json.decode(reqData.body)['collections'];

    int len = jsonData.length < 7 ? jsonData.length : 7;

    List<dynamic> _cityCollectionDetails = [];

    for(int i=0; i<len; i++) {
      _cityCollectionDetails.add(jsonData[i]['collection']['collection_id']);
    }

    for(int i=0; i<len; i++) {
      _cityCollectionDetails.add(jsonData[i]['collection']['title']);
    }

    return _cityCollectionDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget> [
            SliverAppBar(
              pinned: true,
              elevation: 0.0,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Foodspace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.location_on, color: Colors.black45),
                  label: Text(widget.cityName, style: TextStyle(color: Colors.black54)),
                  padding: EdgeInsets.all(0.0),
                ),
              ),

              //SizedBox(height: 20.0),
              Divider(),

              Expanded(
                child: FutureBuilder(
                  future: _getCityCollectionIds(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data == null) {
                      return Container();
                    }
                    else {
                      return ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: (snapshot.data.length / 2).toInt(),
                        itemBuilder: (BuildContext context, int index) {
                          return CarouselTemplate(cityId: widget.cityId, collectionName: snapshot.data[index + (snapshot.data.length / 2).toInt()], cityCollectionId: snapshot.data[index]);
                        }
                      );
                    }
                  }
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:foodspace/models/api_models.dart';
import 'package:foodspace/pages/tab_monitor_page.dart';
import 'package:foodspace/shared/constants.dart';
import 'package:foodspace/shared/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectCityPage extends StatelessWidget {

  Future<List<City>>_getCities() async {
    dynamic reqData = await http.get("https://developers.zomato.com/api/v2.1/cities?city_ids=1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C9%2C10%2C11%2C12%2C13%2C14%2C15%2C16",
    headers: {"user-key": YOUR_ZOMATO_API_KEY});
    dynamic jsonData = json.decode(reqData.body)['location_suggestions'];


    List<City> cities = [];

    for(var c in jsonData) {
      City city = City(cityId: c["id"], name: c["name"]);

      cities.add(city);
    }

    return cities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Select your City', style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder(
          future: _getCities(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == null) {
              return LoadingAlt();
            }
            else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text(snapshot.data[index].name),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TabMonitorPage(cityId: snapshot.data[index].cityId, cityName: snapshot.data[index].name)));
                      },
                    ),
                  );
                }
              );
            }
          }
        ),
      ),
    );
  }
}
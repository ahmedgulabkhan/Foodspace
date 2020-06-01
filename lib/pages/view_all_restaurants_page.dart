import 'dart:convert';
import 'package:foodspace/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:foodspace/models/api_models.dart';
import 'package:foodspace/widgets/restaurant_card_alt.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllRestaurantsPage extends StatelessWidget {

  final dynamic cityId;
  final dynamic collectionName;
  final dynamic cityCollectionId;
  ViewAllRestaurantsPage({
    this.cityId,
    this.collectionName,
    this.cityCollectionId
  });

  Future<List<RestaurantSearch>> _getCollectionRestaurants() async {
    var reqData = await http.get("https://developers.zomato.com/api/v2.1/search?entity_id=${cityId}&entity_type=city&collection_id=${cityCollectionId}",
    headers: {"user-key": YOUR_ZOMATO_API_KEY});
    var jsonData = json.decode(reqData.body)['restaurants'];

    List<RestaurantSearch> restaurants = [];

    for(var r in jsonData) {
      RestaurantSearch restaurant = RestaurantSearch(restaurantId: r['restaurant']['id'],
        name: r['restaurant']['name'],
        //establishment: r['restaurant']['establishment'],
        location: r['restaurant']['location']['address'],
        latitude: double.parse(r['restaurant']['location']['latitude']),
        longitude: double.parse(r['restaurant']['location']['longitude']),
        timings: r['restaurant']['timings'],
        featuredImageUrl: r['restaurant']['featured_image'], 
        rating: r['restaurant']['user_rating']['aggregate_rating'],
        ratingText: r['restaurant']['user_rating']['rating_text'],
        votes: r['restaurant']['user_rating']['votes'], phoneNumber: r['restaurant']['phone_numbers'],
        cuisines: r['restaurant']['cuisines']
      );

      restaurants.add(restaurant);
    }

    return restaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(collectionName, style: TextStyle(fontSize: 24.0)),
        titleSpacing: -1.0,
      ),
      body: FutureBuilder(
        future: _getCollectionRestaurants(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.data == null) {
            // return LoadingAlt();
            return ListView(
              children: <Widget>[
                Shimmer.fromColors(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                    height: 180.0,
                    width: double.infinity,
                  ),
                  baseColor: Colors.grey[500],
                  highlightColor: Colors.white
                ),

                Shimmer.fromColors(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                    height: 180.0,
                    width: double.infinity,
                  ),
                  baseColor: Colors.grey[500],
                  highlightColor: Colors.white
                ),

                Shimmer.fromColors(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
                    height: 180.0,
                    width: double.infinity,
                  ),
                  baseColor: Colors.grey[500],
                  highlightColor: Colors.white
                ),
              ],
            );
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if(index == snapshot.data.length-1) {
                  return Column(
                    children: <Widget>[
                      RestaurantCardAlt(data: snapshot.data[index], collectionName: collectionName),
                      SizedBox(height: 100),
                    ],
                  );
                }
                else {
                  return RestaurantCardAlt(data: snapshot.data[index], collectionName: collectionName);
                }
              }
            );
          }
        }
      ),
    );
  }
}
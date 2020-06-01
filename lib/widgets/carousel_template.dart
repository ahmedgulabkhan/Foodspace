import 'dart:convert';
import 'package:foodspace/pages/view_all_restaurants_page.dart';
import 'package:foodspace/shared/constants.dart';
import 'package:foodspace/widgets/restaurant_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:foodspace/models/api_models.dart';
import 'package:shimmer/shimmer.dart';

class CarouselTemplate extends StatelessWidget {

  final dynamic cityId;
  final dynamic collectionName;
  final dynamic cityCollectionId;
  CarouselTemplate({
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(collectionName, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w900)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => 
                    ViewAllRestaurantsPage(collectionName: collectionName, cityCollectionId: cityCollectionId, cityId: cityId))
                  );
                },
                child: Text('View All', style: TextStyle(fontSize: 15.0, color: Colors.blue))
              )
            ],
          ),

          SizedBox(height: 10.0),
          
          Container(
            height: 180.0,
            width: double.infinity,
            child: FutureBuilder(
              future: _getCollectionRestaurants(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data == null) {
                  // return LoadingAlt();
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Shimmer.fromColors(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 180.0,
                          width: 210.0,
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),

                      Shimmer.fromColors(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 180.0,
                          width: 210.0,
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),

                      Shimmer.fromColors(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          height: 180.0,
                          width: 210.0,
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),
                    ],
                  );
                }
                else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length <= 8 ? snapshot.data.length : 8,
                    itemBuilder: (BuildContext context, int index) {
                      return RestaurantCard(data: snapshot.data[index], collectionName: collectionName);
                    }
                  );
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
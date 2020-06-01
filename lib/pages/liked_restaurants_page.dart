import 'dart:convert';
import 'package:foodspace/models/api_models.dart';
import 'package:foodspace/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodspace/widgets/restaurant_card_alt.dart';

class LikedRestaurantsPage extends StatefulWidget {

  @override
  _LikedRestaurantsPageState createState() => _LikedRestaurantsPageState();
}

class _LikedRestaurantsPageState extends State<LikedRestaurantsPage> {

  int likesLength;
  FirebaseUser _user;


  Future<List<RestaurantSearch>> _customFutureFunction() async {
    _user = await FirebaseAuth.instance.currentUser();

    DocumentReference docRef = Firestore.instance.collection('users').document(_user.uid);
    DocumentSnapshot doc = await docRef.get();
    List<dynamic> likes = await doc.data['likes'];
    if(this.mounted) {
      setState(() {
        likesLength = likes.length;
      });
    }

    List<RestaurantSearch> likedRestaurants = [];

    for(int i=0; i<likesLength; i++) {
      dynamic reqData = await http.get("https://developers.zomato.com/api/v2.1/restaurant?res_id=${likes[i]}",
      headers: {"user-key": YOUR_ZOMATO_API_KEY});
      dynamic jsonData = json.decode(reqData.body);

      RestaurantSearch likedRestaurant = RestaurantSearch(restaurantId: jsonData['id'],
        name: jsonData['name'],
        location: jsonData['location']['address'],
        latitude: double.parse(jsonData['location']['latitude']),
        longitude: double.parse(jsonData['location']['longitude']),
        timings: jsonData['timings'],
        featuredImageUrl: jsonData['featured_image'], 
        rating: jsonData['user_rating']['aggregate_rating'],
        ratingText: jsonData['user_rating']['rating_text'],
        votes: jsonData['user_rating']['votes'], phoneNumber: jsonData['phone_numbers'],
        cuisines: jsonData['cuisines']
      );

      likedRestaurants.add(likedRestaurant);
    }
    return likedRestaurants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Liked Restaurants'),
        titleSpacing: -1.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 150.0),

            SizedBox(height: 20.0),

            Text('Liked Restaurants', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),

            Divider(),

            Expanded(
              child: FutureBuilder(
                future: _customFutureFunction(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.data == null) {
                    return Container();
                  }
                  else {
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 50.0),
                      itemCount: likesLength,
                      itemBuilder: (BuildContext context, int index) {
                        return RestaurantCardAlt(data: snapshot.data[index], collectionName: 'LikedRestaurants');
                      }
                    );
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
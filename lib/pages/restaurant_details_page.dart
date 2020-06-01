import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodspace/pages/geolocation_page.dart';
import 'package:foodspace/services/database_service.dart';
import 'package:foodspace/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodspace/models/api_models.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantDetailsPage extends StatefulWidget {

  final dynamic data;
  final String tag;
  RestaurantDetailsPage({
    this.data,
    this.tag
  });

  @override
  _RestaurantDetailsPageState createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {

  FirebaseUser _user;

  bool isLiked;

  @override
  void initState() {
    super.initState();
    _getCurrentUserAndIsLiked();
  }

  void _getCurrentUserAndIsLiked() async {
    _user = await FirebaseAuth.instance.currentUser();
    DocumentReference docRef = Firestore.instance.collection('users').document(_user.uid);
    DocumentSnapshot doc = await docRef.get();
    List<dynamic> likes = doc.data['likes'];
    if(likes.contains(widget.data.restaurantId)) {
      setState(() {
        isLiked = true;
      });
    }
    else {
      setState(() {
        isLiked = false;
      });
    }
  }

  Future<List<RestaurantReviews>> _getReviews() async {
    var reqData = await http.get("https://developers.zomato.com/api/v2.1/reviews?res_id=${widget.data.restaurantId}&count=0",
    headers: {"user-key": YOUR_ZOMATO_API_KEY});
    var jsonData = json.decode(reqData.body)['user_reviews'];
    //print(jsonData.length);


    List<RestaurantReviews> restaurantReviews = [];

    for(var r in jsonData) {
      RestaurantReviews restaurantReview = RestaurantReviews(reviewId: r['review']['id'],
        rating: r['review']['rating'], reviewText: r['review']['review_text'],
        ratingText: r['review']['rating_text'], userName: r['review']['user']['name'],
        profileImageUrl: r['review']['user']['profile_image'], reviewTime: r['review']['review_time_friendly']
      );

      restaurantReviews.add(restaurantReview);
    }

    return restaurantReviews;
  }

  void _popupDialog(BuildContext context, res) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(res.profileImageUrl),
              ),

              SizedBox(height: 10.0),

              Text(res.userName),

              SizedBox(height: 10.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("${res.rating}⭐", style: TextStyle(fontSize: 15.0)),
                  Text(res.reviewTime, style: TextStyle(fontSize: 12.0))
                ],
              ),

              Divider(),

              Text(res.ratingText, style: TextStyle(fontSize: 15.0)),
            ],
          ),
          content: res.reviewText == '' ? Text('- - -') : Text(
            res.reviewText, style: TextStyle(fontSize: 14.0),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 30.0,
          onPressed: () => Navigator.pop(context)
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GeolocationPage(data: widget.data)));
            },
            icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: Colors.white),
            color: Colors.transparent,
            label: Text("Geolocation", style: TextStyle(color: Colors.white))
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                tag: widget.tag,
                child: ClipRRect(
                  child: Image(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    colorBlendMode: BlendMode.darken,
                    height: MediaQuery.of(context).size.width - 100,
                    width: MediaQuery.of(context).size.width,
                    image: NetworkImage(widget.data.featuredImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                height: MediaQuery.of(context).size.width - 100,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.data.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),

                    SizedBox(height: 10.0),

                    Row(
                      children: <Widget>[
                        Text(widget.data.rating, style: TextStyle(color: Colors.white, fontSize: 16.0)),
                        Text('⭐', style: TextStyle(fontSize: 16.0)),
                        Text("  (${widget.data.votes})", style: TextStyle(color: Colors.white, fontSize: 16.0))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.data.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
                    // (data.establishment[0] == '' ? Text('', style: TextStyle(color: Colors.grey, fontSize: 14.0)) :
                    // Text(data.establishment[0], style: TextStyle(color: Colors.grey, fontSize: 14.0))),
                  ],
                ),

                IconButton(
                  icon: isLiked != null ? (isLiked ? Icon(FontAwesomeIcons.solidHeart, color: Colors.red) : Icon(FontAwesomeIcons.heart, color: Colors.red)) : Text(''),
                  onPressed: () async {
                    await DatabaseService(uid: _user.uid).togglingLikes(widget.data.restaurantId);
                    setState(() {
                      isLiked = !isLiked;
                    });
                  }
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider()
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Location', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(widget.data.location, style: TextStyle(color: Colors.black)),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider()
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Cuisines', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(widget.data.cuisines, style: TextStyle(color: Colors.black)),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider()
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text('Reviews', style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)),
          ),

          Expanded(
            child: FutureBuilder(
              future: _getReviews(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.data == null) {
                  return ListView(
                    padding: EdgeInsets.all(0.0),
                    children: <Widget>[
                      Shimmer.fromColors(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.grey,
                          ),
                          title: Container(height: 50.0, width: double.infinity, color: Colors.grey),
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),

                      Shimmer.fromColors(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.grey,
                          ),
                          title: Container(height: 50.0, width: double.infinity, color: Colors.grey),
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),

                      Shimmer.fromColors(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.grey,
                          ),
                          title: Container(height: 50.0, width: double.infinity, color: Colors.grey),
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),

                      Shimmer.fromColors(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.grey,
                          ),
                          title: Container(height: 50.0, width: double.infinity, color: Colors.grey),
                        ),
                        baseColor: Colors.grey[500],
                        highlightColor: Colors.white
                      ),
                    ],
                  );
                }
                else {
                  return ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length <= 15 ? snapshot.data.length : 15,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () => _popupDialog(context, snapshot.data[index]),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(snapshot.data[index].profileImageUrl),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(snapshot.data[index].ratingText),
                            Text(snapshot.data[index].reviewTime, style: TextStyle(color: Colors.grey, fontSize: 12.0))
                          ],
                        ),
                        subtitle: snapshot.data[index].reviewText == '' ? Text('- - -') : Text(
                          snapshot.data[index].reviewText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        trailing: Text('${snapshot.data[index].rating}⭐'),
                      );
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
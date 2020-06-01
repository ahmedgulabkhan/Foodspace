import 'package:flutter/material.dart';
import 'package:foodspace/pages/restaurant_details_page.dart';

class RestaurantCardAlt extends StatelessWidget {

  final dynamic data;
  final dynamic collectionName;
  RestaurantCardAlt({
    this.data,
    this.collectionName,
  });
  
  @override
  Widget build(BuildContext context) {
    final String tag = data.featuredImageUrl.toString() + collectionName.toString() + "2";
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailsPage(data: data, tag: tag))),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            child: Hero(
              tag: tag,
              child: Image(
                // color: Color.fromRGBO(0, 0, 0, 0.4),
                // colorBlendMode: BlendMode.darken,
                height: 180.0,
                width: double.infinity,
                image: NetworkImage(data.featuredImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color.fromRGBO(0, 0, 0, 0.65), Color.fromRGBO(0, 0, 0, 0.1)]
              )
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            height: 180.0,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.name, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),

                SizedBox(height: 10.0),

                Row(
                  children: <Widget>[
                    Text(data.rating, style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    Text('⭐'),
                    Text("  (${data.votes})", style: TextStyle(color: Colors.white, fontSize: 16.0))
                   ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
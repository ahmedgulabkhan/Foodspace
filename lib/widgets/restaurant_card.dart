import 'package:flutter/material.dart';
import 'package:foodspace/pages/restaurant_details_page.dart';

class RestaurantCard extends StatelessWidget {

  final dynamic data;
  final dynamic collectionName;
  RestaurantCard({
    this.data,
    this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    final String tag = data.featuredImageUrl.toString() + collectionName.toString() + "1";
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetailsPage(data: data, tag: tag))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: tag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  colorBlendMode: BlendMode.darken,
                  height: 180.0,
                  width: 210.0,
                  image: NetworkImage(data.featuredImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              height: 180.0,
              width: 210.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.name, style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.white)),

                  SizedBox(height: 7.0),

                  Row(
                    children: <Widget>[
                      Text(data.rating, style: TextStyle(color: Colors.white)),
                      Text('⭐'),
                      Text("  (${data.votes})", style: TextStyle(color: Colors.white))
                     ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
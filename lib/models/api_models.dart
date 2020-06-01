// City model
class City {
  final dynamic cityId;
  final String name;

  City({
    this.cityId,
    this.name,
  });
}

// RestaurantSearch model
class RestaurantSearch {
  final dynamic restaurantId;
  final String name;
  final List<dynamic> establishment;
  final String location;
  final double latitude;
  final double longitude;
  final String timings;
  final String featuredImageUrl;
  final dynamic rating;
  final String ratingText;
  final String votes;
  final String phoneNumber;
  final String cuisines;

  RestaurantSearch({
    this.restaurantId,
    this.name,
    this.establishment,
    this.location,
    this.latitude,
    this.longitude,
    this.timings,
    this.featuredImageUrl,
    this.rating,
    this.ratingText,
    this.votes,
    this.phoneNumber,
    this.cuisines,
  });
}

// Restaurant reviews model
class RestaurantReviews {
  final dynamic reviewId;
  final dynamic rating;
  final String reviewText;
  final String ratingText;
  final String userName;
  final String profileImageUrl;
  final String reviewTime;

  RestaurantReviews({
    this.reviewId,
    this.rating,
    this.reviewText,
    this.ratingText,
    this.userName,
    this.profileImageUrl,
    this.reviewTime,
  });
}
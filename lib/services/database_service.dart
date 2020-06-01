import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'likes': []
    });
  }


  // get if liked restaurants
  Future togglingLikes(dynamic restaurantId) async {
    DocumentReference docRef = userCollection.document(uid);
    DocumentSnapshot doc = await docRef.get();

    List<dynamic> likes = await doc.data['likes'];

    if(likes.contains(restaurantId)) {
      docRef.updateData(
        {
          'likes': FieldValue.arrayRemove([restaurantId])
        }
      );
    }
    else {
      docRef.updateData(
        {
          'likes': FieldValue.arrayUnion([restaurantId])
        }
      );
    }
  }


  // get user data
  Future getUserData(String email) async {

    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }
}
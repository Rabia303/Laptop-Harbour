import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future adminAddProducts(
      Map<String, dynamic> userInfoMap, String categoryName) async {
    return await FirebaseFirestore.instance
        .collection(categoryName)
        .add(userInfoMap);
  }

  // Get products
  Stream<QuerySnapshot> getProducts(String category) {
    return FirebaseFirestore.instance.collection(category).snapshots();
  }

  // Get all products
  Stream<QuerySnapshot> getAllProducts() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  // Add profile with user ID
  Future addProfile(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection("Profiles")
        .doc(userId) // Use user ID as document ID
        .set(userInfoMap);
  }

  // Fetch user-specific profile by userId
  Future<DocumentSnapshot> getProfileByUserId(String userId) async {
    return await FirebaseFirestore.instance
        .collection('Profiles')
        .doc(userId)
        .get();
  }

  // Update profile data
  Future updateProfile(Map<String, dynamic> userInfoMap, String userId) async {
    return await FirebaseFirestore.instance
        .collection('Profiles')
        .doc(userId)
        .update(userInfoMap);
  }

  // Add user contact details to Firebase
  Future addContactDetails(Map<String, dynamic> contactInfo) async {
    return await FirebaseFirestore.instance
        .collection("contacts") // Specify the collection to store contact info
        .add(contactInfo); // Automatically generate a document ID
  }



  //addtocart show
  
}




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'package:flutter/material.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // FirebaseAuth instance
  List<Map<String, dynamic>> wishlistItems = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Check if the user is logged in
  void _checkUserStatus() {
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchWishlistItems();  // Fetch wishlist items if user is logged in
    }
  }

  // Fetch wishlist items for the logged-in user
  void _fetchWishlistItems() async {
    if (_user == null) return;  // Ensure the user is logged in

    final QuerySnapshot result = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: _user!.uid)  // Filter by user ID
        .get();
    final List<DocumentSnapshot> docs = result.docs;

    setState(() {
      wishlistItems = docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  void _addToCart(String name, Map<String, dynamic> item) async {
    await _firestore.collection('cart').doc(name).set(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name added to cart!')),
    );
  }

  void _removeFromWishlist(int index) async {
    await _firestore.collection('wishlist').doc(wishlistItems[index]["name"]).delete();
    setState(() {
      wishlistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Wishlist')),
      body: _user == null
          ? Center(
              child: Text(
                'First login to add products to wishlist',
                style: TextStyle(color: Colors.white),
              ),
            )
          : wishlistItems.isEmpty
              ? Center(
                  child: Text(
                    'No items in the wishlist',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: wishlistItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      var item = entry.value;
                      return _buildWishlistItem(item["name"], item["image"], item["price"], index);
                    }).toList(),
                  ),
                ),
    );
  }

  Widget _buildWishlistItem(String name, String image, String price, int index) {
    return Card(
      color: Colors.grey[800],
      child: ListTile(
        leading: Image.network(image, fit: BoxFit.cover, width: 60),
        title: Text(name, style: TextStyle(color: Colors.white)),
        subtitle: Text("\$$price", style: TextStyle(color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => _addToCart(name, wishlistItems[index]),
              icon: Icon(Icons.add),
              label: Text("Add to Cart"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFromWishlist(index),
            ),
          ],
        ),
      ),
    );
  }
}

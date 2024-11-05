import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/user/add_profile';
import 'package:laptop_harbor_app/user/contactus.dart';
import 'package:laptop_harbor_app/user/profile.dart';
import 'package:laptop_harbor_app/user/wishlist.dart';
import 'addcart.dart'; // Adjust this import based on your project structure

class ViewDetailsPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final String detail;
  final dynamic price; // Nullable price

  ViewDetailsPage({
    required this.title,
    required this.imagePath,
    required this.detail,
    required this.price,
  });

  @override
  _ViewDetailsPageState createState() => _ViewDetailsPageState();
}

class _ViewDetailsPageState extends State<ViewDetailsPage> {
  int _currentIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text('Contact Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Profile Details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProfile()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  logout();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddToCartPage(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WishListPage(),
        ),
      );
    } else if (index == 3) {
      _showProfileDialog();
    }
  }

  void _addToCart() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please register or log in to add items to your cart.'),
        ),
      );
      return;
    }

    try {
      await _firestore
          .collection('cart')
          .doc('${widget.title}_${currentUser.uid}')
          .set({
        'name': widget.title,
        'image': widget.imagePath,
        'price': widget.price,
        'quantity': 1, // Default quantity
        'userId': currentUser.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} added to cart!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $error')),
      );
    }
  }

  void _addToWishlist() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please register or log in to add items to your wishlist.'),
        ),
      );
      return;
    }

    try {
      await _firestore
          .collection('wishlist')
          .doc('${widget.title}_${currentUser.uid}')
          .set({
        'name': widget.title,
        'image': widget.imagePath,
        'price': widget.price,
        'userId': currentUser.uid, // Save user ID to filter wishlist
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.title} added to wishlist!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to wishlist: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddToCartPage(),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 250,
                  child: Image.network(
                    widget.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not available',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.detail,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.price != null)
                      Text(
                        'Price: ${widget.price}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addToCart,
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      User? currentUser = FirebaseAuth.instance.currentUser;

                      if (currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please log in or register to proceed with purchase.',
                            ),
                          ),
                        );
                        return;
                      }

                      // Implement buy now functionality here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Buying ${widget.title} now!')),
                      );
                    },
                    child: Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addToWishlist,
                    child: Text('Add to Wishlist'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.pink, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.details), label: 'Details'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

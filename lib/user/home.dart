import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/user/add_profile';
import 'package:laptop_harbor_app/user/addcart.dart';
import 'package:laptop_harbor_app/user/contactus.dart';
import 'package:laptop_harbor_app/user/details.dart';
import 'package:laptop_harbor_app/user/category_product.dart' as productCardTwo;
import 'package:laptop_harbor_app/user/profile.dart';
import 'package:laptop_harbor_app/user/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptop_harbor_app/firestore_firebase.dart'; 
import 'package:laptop_harbor_app/user/wishlist.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  List categories = [
    'assets/images/dell.jpg',
    'assets/images/acerimg.jpg',
    'assets/images/asusimg.jpg',
    'assets/images/lenonvoimg.jpg',
    'assets/images/apple.jpg',
    'assets/images/micro.jpg',
    'assets/images/hp.jpg',
  ];

  List categoryname = [
    "Dell",
    "Acer",
    "Asus",
    "Lenovo",
    "Apple",
    "Microsoft",
    "HP"
  ];
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _searchQuery = "";

  final List<Widget> _pages = [
    HomePage(),
    WishListPage(),
  ];

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

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 48, 48),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white24,
            hintText: 'Search',
            prefixIcon: Icon(Icons.search, color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner section
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Laptop on your hands',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),

             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose the Brand',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: _scrollLeft,
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: _scrollRight,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Brands in a Single Row with Horizontal Scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Row(
                  children: widget.categories.asMap().entries.map((entry) {
                    int index = entry.key;
                    String imagePath = entry.value;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                productCardTwo.CategoryProducts(
                              category: widget.categoryname[index],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(imagePath),
                              radius: 50,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              widget.categoryname[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // 20% Discount section
              Text(
                '20% Discount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

// Product Cards using StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Apple'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); 
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 15,),
// Product Cards using StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Dell'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(
                      
                        ); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
              
              SizedBox(height: 15,),
               StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Microsoft'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
               
                
              SizedBox(height: 15,),
               StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('HP'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
               
               SizedBox(height: 15,),
                StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Lenovo'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
               SizedBox(height: 15,),
// Product Cards using StreamBuilder
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Acer'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 15,),
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseMethods()
                    .getProducts('Asus'), // Pass the category as an argument
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No products available.'));
                  }

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: snapshot.data!.docs.map((doc) {
                      String title = doc['Name'];
                      String imagePath =
                          doc['Image'] ?? 'https://via.placeholder.com/150';
                      String description =
                          doc['Description'] ?? 'No details available';
                      String price =
                          doc['Price'] != null ? doc['Price'].toString() : '0';

                      // Filter based on the search query
                      if (!title.toLowerCase().contains(_searchQuery)) {
                        return Container(); // Skip if it doesn't match the search query
                      }

                      return _buildProductCard(
                        context,
                        title,
                        imagePath,
                        description,
                        price,
                      );
                    }).toList(),
                  );
                },
              )
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, String title, String imagePath,
      String description, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailsPage(
              title: title,
              detail: description,
              price: price,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
          'Product Name: $title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Price : $price',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.add_shopping_cart),
                  //   color: Colors.blue,
                  //   onPressed: () {
                  //     // Add to cart functionality
                  //   },
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.favorite_border),
                  //   color: Colors.red,
                  //   onPressed: () {
                  //     // Add to wishlist functionality
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

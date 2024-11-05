import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptop_harbor_app/firestore_firebase.dart';
import 'package:laptop_harbor_app/user/details.dart';

class CategoryProducts extends StatefulWidget {
  final String category;

  CategoryProducts({required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream? categoryStream;

  getOnTheLoad() async {
    categoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.7,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewDetailsPage(
                          title: ds['Name'],
                          imagePath: ds['Image'] ?? 'https://via.placeholder.com/600',
                          detail: ds['Description'] ?? 'No details available',
                          price: ds['Price'] != null ? ds['Price'].toString() : null,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Color(0xFF1C1C1E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Image with Quality Enhancement
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: ds['Image'] ?? 'https://via.placeholder.com/600',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain, // Adjust to fit the image without blur
                              filterQuality: FilterQuality.high,
                              fadeInDuration: Duration(milliseconds: 200),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[900],
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[600],
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Product Info Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Name",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              Text(
                                ds['Name'],
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Price",
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                              Text(
                                ds['Price'] != null ? "${ds['Price']}" : "Unavailable",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.category,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 3,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: allProducts(),
      ),
    );
  }
}

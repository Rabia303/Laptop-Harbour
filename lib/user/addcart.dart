import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laptop_harbor_app/user/checkout.dart';

class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> cartItems = [];
  double total = 0.0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    if (currentUser != null) {
      _fetchCartItems();
    }
  }

  void _fetchCartItems() async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('cart')
          .where('userId', isEqualTo: currentUser!.uid)
          .get();
      final List<DocumentSnapshot> docs = result.docs;

      setState(() {
        cartItems = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          String priceString = data["price"] ?? "0";
          double price = double.tryParse(
                priceString.replaceAll(RegExp(r'[^0-9.]'), ''),
              ) ?? 0.0;
          data["price"] = price;
          data["quantity"] = data["quantity"] ?? 1;
          return data;
        }).toList();
        _calculateTotals();
      });
    } catch (e) {
      print("Error fetching cart items: $e");
    }
  }

  void _calculateTotals() {
    total = cartItems.fold(0.0, (sum, item) => sum + (item["price"] * item["quantity"]));
    setState(() {}); // Trigger UI update
  }

  void _updateCartItem(int index) async {
    await _firestore
        .collection('cart')
        .doc(cartItems[index]["name"] + currentUser!.uid)
        .update({"quantity": cartItems[index]["quantity"]});
    _calculateTotals(); // Ensure total recalculates after update
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]["quantity"]++;
    });
    _updateCartItem(index);
    _calculateTotals(); // Ensure total recalculates after quantity increase
  }

  void _decreaseQuantity(int index) {
    if (cartItems[index]["quantity"] > 1) {
      setState(() {
        cartItems[index]["quantity"]--;
      });
      _updateCartItem(index);
      _calculateTotals(); // Ensure total recalculates after quantity decrease
    }
  }

  void _removeItem(int index) async {
    await _firestore
        .collection('cart')
        .doc(cartItems[index]["name"] + currentUser!.uid)
        .delete();
    setState(() {
      cartItems.removeAt(index);
    });
    _calculateTotals(); // Ensure total recalculates after item removal
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: Text('Cart')),
        body: Center(
          child: Text(
            'Please register to view your cart',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('No items in the cart', style: TextStyle(color: Colors.white)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      return _buildCartItem(
                        item["name"] ?? "Unknown Item",
                        item["image"] ?? "assets/images/default.png",
                        item["price"] ?? 0.0,
                        item["quantity"] ?? 1,
                        index,
                      );
                    },
                  ),
                ),
                _buildTotalSummary(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutPage(total: total, cartItems: [],)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Proceed to Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCartItem(String name, String image, dynamic price, int quantity, int index) {
    double itemSubtotal = price * quantity;
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Image.network(image, fit: BoxFit.cover, width: 50, height: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text('\$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.white)),
                  Text('Subtotal: \$${itemSubtotal.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _decreaseQuantity(index),
                ),
                Text(quantity.toString(), style: TextStyle(color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _increaseQuantity(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeItem(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary() {
    return Container(
      color: Colors.grey[900],
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Text(
            'Shipping: Free Shipping',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Total: \$${total.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptop_harbor_app/pages/admin_add_Products.dart';
import 'package:laptop_harbor_app/pages/admin_login.dart';
import 'package:laptop_harbor_app/user/home.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  //logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Admin Dashboard',style: TextStyle(fontWeight: FontWeight.bold),)),
        backgroundColor: Colors.deepPurple[200],
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF854F6C),
              ),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminAddProducts()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Promos'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Banners'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Coupons'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Return Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Overview',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF854F6C),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSummaryRow(),
                    SizedBox(height: 20),
                    _buildSalesChart(),
                    SizedBox(height: 20),
                    _buildRecentActivities(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          icon: Icons.shopping_cart,
          title: 'Total Orders',
          value: '150',
          color: Colors.blueAccent,
        ),
        _buildSummaryCard(
          icon: Icons.inventory,
          title: 'Products in Stock',
          value: '85',
          color: Colors.greenAccent,
        ),
        _buildSummaryCard(
          icon: Icons.attach_money,
          title: 'Total Sales',
          value: '\$25,000',
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepPurple[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
          SizedBox(height: 10),
          // Placeholder for the chart
          Container(
            height: 150,
            color: Colors.deepPurple[100],
            child: Center(
              child: Text(
                'Sales Chart Placeholder',
                style: TextStyle(color: Colors.deepPurple[400]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          SizedBox(height: 10),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.shopping_cart, color: Colors.blueAccent),
                title: Text('New Order from Customer #123'),
                subtitle: Text('2 hours ago'),
              ),
              ListTile(
                leading: Icon(Icons.inventory, color: Colors.green),
                title: Text('Product Stock Updated'),
                subtitle: Text('5 hours ago'),
              ),
              ListTile(
                leading: Icon(Icons.attach_money, color: Colors.orange),
                title: Text('Daily Sales Report Generated'),
                subtitle: Text('1 day ago'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

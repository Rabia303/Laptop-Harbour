import 'package:flutter/material.dart';

class AdminCategories extends StatefulWidget {
  const AdminCategories({super.key});

  @override
  State<AdminCategories> createState() => _AdminCategoriesState();
}

class _AdminCategoriesState extends State<AdminCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Categories'),
      ),
      body: Center(
        child: Text('Category List'), 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple, 
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laptop_harbor_app/firestore_firebase.dart'; 

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();

  void submitContactForm() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String message = messageController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && message.isNotEmpty) {
      Map<String, dynamic> contactInfo = {
        "name": name,
        "email": email,
        "message": message,
        "timestamp": FieldValue.serverTimestamp(),
      };

      try {
        await databaseMethods.addContactDetails(contactInfo);
        Fluttertoast.showToast(msg: "Message sent successfully!");
        nameController.clear();
        emailController.clear();
        messageController.clear();
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to send message: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "Please fill all fields.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(31, 206, 171, 171),
        title: Text(
          'Contact Us',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(  
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigating back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Center(
                child: Column(
                  children: [
                    Icon(Icons.support_agent, size: 60, color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text(
                      'Customer Support',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'We\'re here to help you!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
             
              Text(
                'Feel free to reach out to us for any queries, support, or feedback.',
                style: TextStyle(fontSize: 16, color: Colors.grey[300]),
              ),
              SizedBox(height: 30),
             
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                   
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(color: Colors.grey[200]),
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        labelStyle: TextStyle(color: Colors.grey[200]),
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(Icons.email, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
            
                    TextField(
                      controller: messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Your Message',
                        labelStyle: TextStyle(color: Colors.grey[200]),
                        filled: true,
                        fillColor: Colors.white12,
                        prefixIcon: Icon(Icons.message, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
           
              Center(
                child: GestureDetector(
                  onTap: submitContactForm,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1C1C1C),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }
}

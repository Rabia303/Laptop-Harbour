

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:laptop_harbor_app/firestore_firebase.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AdminAddProducts extends StatefulWidget {
  const AdminAddProducts({super.key});

  @override
  State<AdminAddProducts> createState() => _AdminAddProductsState();
}

class _AdminAddProductsState extends State<AdminAddProducts> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  XFile? selectedImageWeb;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController(); 
  TextEditingController priceController = TextEditingController(); 

  Future<void> getImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        setState(() {
          selectedImageWeb = pickedFile;
        });
      } else {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  uploadItem() async {
    try {
      if ((selectedImage != null || selectedImageWeb != null) &&
          nameController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        String addId = randomAlphaNumeric(10);
        Reference firebaseStorageref =
            FirebaseStorage.instance.ref().child("productImage").child(addId);

        UploadTask task;
        if (kIsWeb) {
          task = firebaseStorageref.putData(
            await selectedImageWeb!.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else {
          task = firebaseStorageref.putFile(selectedImage!);
        }
        // Wait for the upload to complete
        var snapshot = await task.whenComplete(() {});
        var downloadUrl = await snapshot.ref.getDownloadURL();
        await _uploadProductData(downloadUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all fields and select an image.")),
        );
      }
    } catch (e) {
      print("Error uploading item: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload product.")),
      );
    }
  }

  Future<void> _uploadProductData(String downloadUrl) async {
    Map<String, dynamic> AdminAddProducts = {
      "Name": nameController.text,
      "Description": descriptionController.text,
      "Price": priceController.text,
      "Image": downloadUrl,
    };
    try {
      await DatabaseMethods().adminAddProducts(AdminAddProducts, value!);
      // Reset the input fields and image
      selectedImage = null;
      selectedImageWeb = null;
      nameController.text = "";
      descriptionController.text = "";
      priceController.text = "";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Product has been uploaded Successfully!",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      );
    } catch (e) {
      print("Error uploading product data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Failed to upload product data.")),
      );
    }
  }

  String? value = "Dell";
  final List<String> categoryItems = [
    "Dell",
    "Acer",
    "Asus",
    "Lenovo",
    "Apple",
    "Microsoft",
    "HP"
  ];

  Widget displayImage() {
    if (kIsWeb && selectedImageWeb != null) {
      return Image.network(
        selectedImageWeb!.path,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (selectedImage != null) {
      return Image.file(
        selectedImage!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Icon(Icons.camera_alt_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Product",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload the Product Image",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            SizedBox(height: 20.0),
            selectedImage == null && selectedImageWeb == null
                ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  )
                : Center(
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: displayImage(),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 20.0),
            Text(
              "Product Name",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Product Description",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
              ),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Product Price",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
              ),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Product Category",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.blueGrey[300],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFececf8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: categoryItems
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.blueGrey[300],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    this.value = value;
                  }),
                  dropdownColor: Colors.white,
                  hint: Text(
                    "Select Category",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.blueGrey[300],
                    ),
                  ),
                  isExpanded: true,
                  value: value,
                ),
              ),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: () {
                uploadItem();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 15.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff4b0b8a),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Upload",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

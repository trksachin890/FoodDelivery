import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sachinfood3/pages/signup.dart';
import 'package:sachinfood3/widget/widget_support.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> _uploadFoodItem() async {
    if (_imageUrlController.text.isEmpty || _nameController.text.isEmpty || _priceController.text.isEmpty || _detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide all the details and an image URL")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('foodItems').add({
        'name': _nameController.text.trim(),
        'price': _priceController.text.trim(),
        'details': _detailsController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Food item added successfully!")),
      );
      _nameController.clear();
      _priceController.clear();
      _detailsController.clear();
      _imageUrlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload food item: $e")),
      );
    }
  }

  void _logout() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Admin"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Column(
            children: [
              Center(child: Text("Home Admin", style: AppWidget.HeadlineTextFeildStyle())),
              SizedBox(height: 30.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Food Name"),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: "Details"),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _uploadFoodItem,
                child: Text("Upload Food Item"),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _logout,
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
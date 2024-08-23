import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sachinfood3/service/shared_pref.dart';
import 'package:sachinfood3/widget/widget_support.dart';

class Checkout extends StatefulWidget {
  final int totalAmount;

  Checkout({required this.totalAmount});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  String? userId, fullName, address, phoneNumber;

  @override
  void initState() {
    super.initState();
    getUserIdFromSharedPref();
  }

  Future<void> getUserIdFromSharedPref() async {
    userId = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  Future<void> placeOrder() async {
    if (_formKey.currentState!.validate() && userId != null) {
      _formKey.currentState!.save();

      Map<String, dynamic> orderData = {
        "userId": userId,
        "fullName": fullName,
        "address": address,
        "phoneNumber": phoneNumber,
        "totalAmount": widget.totalAmount,
        "timestamp": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection("OrderTable").add(orderData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Order placed successfully!"),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your full name";
                  }
                  return null;
                },
                onSaved: (value) {
                  fullName = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your address";
                  }
                  return null;
                },
                onSaved: (value) {
                  address = value;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  return null;
                },
                onSaved: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: placeOrder,
                child: Text("Place Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

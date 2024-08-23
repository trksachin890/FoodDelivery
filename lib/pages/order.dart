import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sachinfood3/service/database.dart';
import 'package:sachinfood3/service/shared_pref.dart';
import 'package:sachinfood3/widget/widget_support.dart';
import 'checkout.dart'; // Import the Checkout page

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  Stream? foodStream;

  @override
  void initState() {
    super.initState();
    ontheload();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
  }

  Future<void> getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    // wallet = await SharedPreferenceHelper().getUserWallet();
    setState(() {});
  }

  Future<void> ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  int calculateTotal(List<DocumentSnapshot> docs) {
    int total = 0;
    for (var doc in docs) {
      total += int.parse(doc["Total"]);
    }
    return total;
  }

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.docs;
            total = calculateTotal(docs);
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = docs[index];
                  return Container(
                    margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text(ds["Quantity"])),
                            ),
                            SizedBox(width: 20.0),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  ds["Image"],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                )),
                            SizedBox(width: 15.0),
                            Column(
                              children: [
                                Text(
                                  ds["Name"],
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                ),
                                Text(
                                  "\$" + ds["Total"],
                                  style: AppWidget.semiBoldTextFeildStyle(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Your Cart",
                  style: AppWidget.HeadlineTextFeildStyle(),
                ),
                Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Expanded(child: foodCart()),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price",
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                    Text(
                      "\$${total.toString()}",
                      style: AppWidget.HeadlineTextFeildStyle(),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Checkout(totalAmount: total), // Pass the total amount
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Checkout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

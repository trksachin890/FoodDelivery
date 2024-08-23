import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sachinfood3/pages/details.dart';
import 'package:sachinfood3/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot>? fooditemsStream;

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  void ontheload() {
    // Fetch all food items from Firestore
    fooditemsStream = FirebaseFirestore.instance.collection("foodItems").snapshots();
  }

  Widget allItemsVertically() {
    return StreamBuilder<QuerySnapshot>(
      stream: fooditemsStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items found'));
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final imageUrl = data["imageUrl"] ?? ""; // Get the imageUrl from Firestore

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      detail: data["details"] ?? "N/A",
                      name: data["name"] ?? "Unknown",
                      price: data["price"] ?? "0",
                      image: imageUrl, // Use the fetched imageUrl
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(4),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl.isNotEmpty) // Check if imageUrl is not empty
                          Image.network(
                            imageUrl,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, size: 150);
                            },
                          )
                        else
                          Icon(Icons.error, size: 150), // Display a default image if imageUrl is empty
                        Text(
                          data['name'] ?? "Unknown",
                          style: AppWidget.semiBoldTextFeildStyle(),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          data["details"] ?? "N/A",
                          style: AppWidget.LightTextFeildStyle(),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "NRP " + (data['price'] ?? "0"),
                          style: AppWidget.semiBoldTextFeildStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hello Guys,", style: AppWidget.boldTextFeildStyle()),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text("Delicious Food", style: AppWidget.HeadlineTextFeildStyle()),
              Text("Discover and Get Great Food",
                  style: AppWidget.LightTextFeildStyle()),
              SizedBox(height: 20.0),
              Container(
                height: 270,
                child: allItemsVertically(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sachinfood3/service/database.dart';
import 'package:sachinfood3/service/shared_pref.dart';
import 'package:sachinfood3/widget/widget_support.dart';

class Details extends StatefulWidget {
  final String image, name, detail, price;

  Details({
    required this.detail,
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int quantity = 1, total = 0;
  String? userId;

  @override
  void initState() {
    super.initState();
    onLoad();
    total = int.parse(widget.price);
  }

  Future<void> getUserIdFromSharedPref() async {
    userId = await SharedPreferenceHelper().getUserId();
    if (userId == null) {
      // Handle the case when userId is null
      print("User ID is null, something went wrong.");
    } else {
      print("Retrieved userId: $userId");
    }
    setState(() {});
  }

  Future<void> onLoad() async {
    await getUserIdFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15.0),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: AppWidget.semiBoldTextFeildStyle(),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (quantity > 1) {
                      --quantity;
                      total -= int.parse(widget.price);
                    }
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  quantity.toString(),
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    ++quantity;
                    total += int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              widget.detail,
              maxLines: 4,
              style: AppWidget.LightTextFeildStyle(),
            ),
            SizedBox(height: 30.0),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: AppWidget.semiBoldTextFeildStyle(),
                ),
                SizedBox(width: 25.0),
                Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                SizedBox(width: 5.0),
                Text(
                  "30 min",
                  style: AppWidget.semiBoldTextFeildStyle(),
                )
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
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
                    onTap: userId != null
                        ? () async {
                            Map<String, dynamic> addFoodToCart = {
                              "Name": widget.name,
                              "Quantity": quantity.toString(),
                              "Total": total.toString(),
                              "Image": widget.image
                            };
                            await DatabaseMethods()
                                .addFoodtoCart(addFoodToCart, userId!);
                            print("Food added to cart: $addFoodToCart");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.orangeAccent,
                                content: Text(
                                  "Food Added to Cart",
                                  style: TextStyle(fontSize: 18.0),
                                )));
                          }
                        : () {
                            print("userId is null, cannot add to cart");
                          },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: userId != null ? Colors.black : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Add to cart",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 30.0),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10.0),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

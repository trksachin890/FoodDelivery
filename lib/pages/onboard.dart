import 'package:flutter/material.dart';
import 'package:sachinfood3/pages/signup.dart';
import 'package:sachinfood3/widget/content_model.dart';
import 'package:sachinfood3/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: screenSize.height * 0.4, // Dynamic height
                        width: screenSize.width,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.05, // Dynamic spacing
                      ),
                      Text(
                        contents[i].title,
                        style: AppWidget.HeadlineTextFeildStyle(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.02, // Dynamic spacing
                      ),
                      Text(
                        contents[i].description,
                        style: AppWidget.LightTextFeildStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: screenSize.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contents.length - 1) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              } else {
                _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              height: screenSize.height * 0.08, // Dynamic height
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1, vertical: screenSize.height * 0.03), // Dynamic margins
              width: double.infinity,
              child: Center(
                child: Text(
                  currentIndex == contents.length - 1 ? "Start" : "Next",
                  style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 18 : 7,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../responsive.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: buildMobileLayout(context),
      tablet: buildTabletLayout(context),
      desktop: buildDesktopLayout(context),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset('assets/images/main.jpeg', fit: BoxFit.fill),
            ),
            buildAnimatedText(context),
            buildImageAboveForm(context), // Add the image above the form
            buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Color(0xFFF3F4F6),
                    child: Image.asset('assets/images/main.jpeg', fit: BoxFit.fill),
                  ),
                  buildAnimatedText(context),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  buildImageAboveForm(context), // Add the image above the form
                  buildForm(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Color(0xFFF3F4F6),
                  child: Image.asset('assets/images/main.jpeg', fit: BoxFit.fill),
                ),
                buildAnimatedText(context),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                buildImageAboveForm(context), // Add the image above the form
                buildForm(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2, // Adjust the position from the top as needed
      left: 50, // Adjust the position from the left as needed
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          children: [
            TypewriterAnimatedTextKit(
              totalRepeatCount: 100,
              speed: Duration(milliseconds: 200),
              pause: Duration(milliseconds: 1000),
              text: ['Welcome to'' Smart Course Registration System'],
              textStyle: TextStyle(
                color: Color(0xFFF3F4F6),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageAboveForm(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height / 3,
      child: Image.asset(
          'assets/images/background.png'), // Replace with your image asset
    );
  }
}
  Widget buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Color(0xFFF3F4F6), // Adjust the color as needed
              child:
               Image.asset(
                  'assets/images/main.jpeg',
                  fit: BoxFit.fill,
                ),

            ),
          ),


          Expanded(
            flex: 3,

            child: Container(

                child:buildForm(context)),
          ),
        ],
      ),
    );
  }

Widget buildForm(BuildContext context) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email',
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const TextField(
                style: TextStyle(color: Color(0xFF334155)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xFF334155),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Color(0xFF334155)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Password',
              style: TextStyle(
                color: Color(0xFF334155),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xFF334155),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 35),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/dashboard");
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFF334155),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        ' Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


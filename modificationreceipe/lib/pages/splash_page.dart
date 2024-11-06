import 'package:flutter/material.dart';
import 'package:logins/pages/Homepage/home_page.dart';
import 'package:lottie/lottie.dart';

import 'bottomnavbar/bottom_navigation_bar.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'images/animation_file.json', // Replace with the actual path to your Lottie animation
          width: 200, // Adjust the width as needed
          height: 200, // Adjust the height as needed
        ),
      ),
    );
  }
}


// final int selectedNavBarIndex = 0;
//
// void _onNavBarItemTapped(BuildContext context, int index) {
//   // Handle bottom navigation bar item tap
//   switch (index) {
//     case 0:
//     // Navigate to the home screen
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage()),
//       );
//       break;
//     case 1:
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => SplashPage()),
//       );
//       // Navigate to the search screen
//       break;
//     case 2:
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SplashPage()),
//       );
//       // Navigate to the favorites screen
//       break;
//     case 3:
//     // Navigate to the profile screen
//       break;
//   }
// }
import 'package:flutter/material.dart';
import 'package:logins/pages/profile/profile.dart';

import 'Homepage/home_page.dart';
import 'createReceipe/addReceipe.dart';
import 'myreceipe/myreceipe.dart';
import 'mywishlist/mywishlist.dart';

void navigateToScreen(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      break;
    case 1:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => myWishlistPage()));
      break;
    case 2:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddReceipePage()));
      break;
    case 3:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Myreceipe()));
      break;
    case 4:
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile()));
      break;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/addReceipe/homepage_event.dart';
import '../../blocs/floatingbtn/homepage_bloc.dart';
import '../createReceipe/addReceipe.dart';

class BottomNavigationBarPage extends StatefulWidget {
  final int selectedNavBarIndex;
  final Function(int) onNavBarItemTapped;

  const BottomNavigationBarPage({
    Key? key,
    required this.selectedNavBarIndex,
    required this.onNavBarItemTapped,
  }) : super(key: key);

  @override
  _BottomNavigationBarPageState createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: const Color(0xff000080), // Set the background color here
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, size: 20),
              color: widget.selectedNavBarIndex == 0 ? Colors.white : Colors.white.withOpacity(0.6),
              onPressed: () => widget.onNavBarItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.favorite, size: 20),
              color: widget.selectedNavBarIndex == 1 ? Colors.white : Colors.white.withOpacity(0.6),
              onPressed: () => widget.onNavBarItemTapped(1),
            ),
            IconButton(
              icon: Icon(Icons.my_library_add_outlined, size: 20),
              color: widget.selectedNavBarIndex == 2 ? Colors.white : Colors.white.withOpacity(0.6),
              onPressed: () => widget.onNavBarItemTapped(2),
            ),

            IconButton(
              icon: Icon(Icons.dataset_outlined, size: 20),
              color: widget.selectedNavBarIndex == 3 ? Colors.white : Colors.white.withOpacity(0.6),
              onPressed: () => widget.onNavBarItemTapped(3),
            ),
            IconButton(
              icon: Icon(Icons.person, size: 20),
              color: widget.selectedNavBarIndex == 4 ? Colors.white : Colors.white.withOpacity(0.6),
              onPressed: () => widget.onNavBarItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

}

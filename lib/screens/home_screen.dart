import 'package:flutter/material.dart';
import 'package:flutter_cars/screens/search_screen.dart';
import 'package:flutter_cars/screens/my_bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.idx});
  final int idx;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    if (widget.idx != null) {
      _currentIndex = widget.idx;
    }
    super.initState();
  }

  final List<Widget> _children = [
    SearchScreen(),
    BookingsScreen(),
  ];

  final List<String> _titles = ["Flutter Cars", "My Bookings"];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        automaticallyImplyLeading: false,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.directions_car),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}

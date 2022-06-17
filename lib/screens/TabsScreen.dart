import "package:flutter/material.dart";
import "./SearchScreen.dart";
import 'FavoritesScreen.dart';
import "ChatScreen.dart";
import "ProfileScreen.dart";

class TabScreen extends StatefulWidget {
  static const routeName = "/tabs-screen";

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Map<String, Object>> _pages = [
    {"page": SearchScreen(), "title": "Search"},
    {"page": FavoritesScreen(), "title": "Favorites"},
    {"page": ChatScreen(), "title": "Chat"},
    {"page": ProfileScreen(), "title": "Profile"},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectedPageIndex]["title"] as String),
      // ),
      body: SafeArea(
        child:
            _pages[_selectedPageIndex]["page"] as Widget, // Index from state.
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_application_2/pages/calendar_page.dart';
import 'package:flutter_application_2/pages/graph_page.dart';
import 'package:flutter_application_2/pages/memory_page.dart';
import 'package:flutter_application_2/pages/pet_page.dart';
import 'package:flutter_application_2/pages/home_page.dart';
import 'package:flutter_application_2/pages/setting_page.dart';

import 'pages/map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openSettingsPage() {
    // Push a new route for the SettingPage without removing the current state
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(),
      ),
    );
  }

  void _openMapPage() {
    // Push a new route for the SettingPage without removing the current state
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPage(),
      ),
    );
  }

  final List<Widget> _pages = [
    HomePage1(),
    PetPage(),
    MemoryPage(),
    CalendarPage(),
    GraphPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[200],
          child: ListView(
            children: [
              DrawerHeader(
                  child: Center(
                child: Text(
                  " M Y  P E T ",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              )),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: _openSettingsPage,
              ),
              ListTile(
                  leading: Icon(Icons.map),
                  title: Text(
                    "MAP",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: _openMapPage)
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'pets'),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'memory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'calendar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.graphic_eq), label: 'graphs'),
        ],
      ),
    );
  }
}

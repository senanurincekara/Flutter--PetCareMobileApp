import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: Center(
        child: Text(
          'This is the Settings Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

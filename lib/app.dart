import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:urban_hamony/widgets/layout.dart';
import 'package:urban_hamony/widgets/login_page.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  Future<bool> _checkCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currentUser');
    return jsonString != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder<bool>(
        future: _checkCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.orange,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data == true) {
            return Layout();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}


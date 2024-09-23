import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_hamony/widgets/admin_page.dart';
import 'dart:convert';

import 'package:urban_hamony/widgets/layout.dart';
import 'package:urban_hamony/widgets/login_page.dart';
import 'package:urban_hamony/widgets/screens/chooseRole.dart';
import 'package:urban_hamony/widgets/screens/drawScreen.dart';
import 'package:urban_hamony/widgets/screens/homeScreen.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  Future<Map<String, dynamic>> _checkCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currentUser');
    if (jsonString != null) {
      final user = json.decode(jsonString);
      return {'isLoggedIn': true, 'role': user['role']};
    }
    return {'isLoggedIn': false, 'role': null};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins', // Áp dụng font Poppins cho toàn bộ ứng dụng
      ),
      routes: {
        '/home': (context) => const Layout(),
      },
        home: FutureBuilder<Map<String, dynamic>>(
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
            } else if (snapshot.hasData && snapshot.data!['isLoggedIn'] == true) {
              if (snapshot.data!['role'] == 'admin') {
                return AdminPage();
              } else {
                return Layout();
              }
            } else {
              return LoginPage();
            }
          },
        )
    );
  }
}


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_hamony/models/auth_model.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/login_page.dart';

import '../../providers/root.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseService _databaseService = DatabaseService();
  bool _isLoading = true;
  UserModel _user = UserModel();

  Future<void> _getUserP(String email) async {
    UserModel userP = await _databaseService.getUserProfile(email);
    setState(() {
      _user = userP;
      _isLoading = false;
    });
  }

  Future<void> _getId () async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currentUser');
    if (jsonString != null) {
      final currentUser = jsonDecode(jsonString);
      final email = currentUser['email'];
      await _getUserP(email);
    }
  }


  @override
  void initState() {
    super.initState();
    _getId();
  }

  @override
  Widget build(BuildContext context) {
    final List<ProfileInfoItem> _items = [
      ProfileInfoItem("${_user.gender}", "Gender"),
      ProfileInfoItem("${_user.role}", "Role"),
      ProfileInfoItem("Verified", "Verify"),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFFFF5733), Color(0xFFFECF02)]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage('${_user.urlAvatar}')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    '${_user.firstName} ${_user.lastName}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 80,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _items
                          .map((item) => Expanded(
                          child: Row(
                            children: [
                              if (_items.indexOf(item) != 0) const VerticalDivider(),
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          item.value.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.title,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                              ),
                            ],
                          )))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}



AppBar _buildAppBar(context) {
  Future<bool> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Provider.of<UserModel>(context, listen: false).clear();
    Provider.of<RootProvider>(context, listen: false).clear();
    return true;
  }
  return AppBar(
    backgroundColor: const Color(0xFFFFFFFF),
    elevation: 0,
    toolbarHeight: 80,
    title: const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
    actions: [
      Container(
        margin: const EdgeInsets.only(right: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.logout, color: Colors.orange),
          onPressed: () {
            _signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
    ],
  );
}

class ProfileInfoItem {
  final String title;
  final String value;
  const ProfileInfoItem(this.title, this.value);
}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_model.dart';

class UserinfoUtil{
  static Future<void> saveCurrentUser(currentUser) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(currentUser);
    prefs.setString('currentUser', jsonString);
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('currentUser');
    if (jsonString != null) {
      final Map<String, dynamic> userMap = jsonDecode(jsonString);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
}
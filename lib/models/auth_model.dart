import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String? urlAvatar;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? password;
  bool? isHasProfile;
  String ? gender;
  UserModel({
    this.urlAvatar,
    this.firstName,
    this.lastName,
    this.role,
    this.email,
    this.password,
    this.isHasProfile,
    this.gender
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    urlAvatar = json['urlAvatar'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    email = json['email'];
    password = json['password'];
    isHasProfile = json['isHasProfile'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlAvatar'] = this.urlAvatar;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['role'] = this.role;
    data['email'] = this.email;
    data['password'] = this.password;
    data['isHasProfile'] = this.isHasProfile;
    data['gender'] = this.gender;
    return data;
  }
  String getStringRepresentation() {
    return 'UserModel(urlAvatar: $urlAvatar, firstName: $firstName, lastName: $lastName, role: $role, email: $email, password: $password, isHasProfile: $isHasProfile, gender: $gender)';
  }
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.getStringRepresentation());
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString('user');
    if (userString != null) {
      Map<String, dynamic> userMap = jsonDecode(userString);
      return UserModel.fromJson(userMap);
    }
    return null;
  }

}

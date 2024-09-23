import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'design.dart';

class UserModel {
  String? urlAvatar;
  String? firstName;
  String? lastName;
  String? role;
  String? email;
  String? password;
  bool? isHasProfile;
  String? gender;
  List<Design>? listDesign; // Add listDesign property

  UserModel({
    this.urlAvatar,
    this.firstName,
    this.lastName,
    this.role,
    this.email,
    this.password,
    this.isHasProfile,
    this.gender,
    this.listDesign, // Initialize listDesign
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
    if (json['listDesign'] != null) {
      listDesign = (json['listDesign'] as List)
          .map((item) => Design.fromJson(item))
          .toList();
    }
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
    if (this.listDesign != null) {
      data['listDesign'] = this.listDesign!.map((item) => item.toJson()).toList();
    }
    return data;
  }
  void clear() {
    urlAvatar = null;
    firstName = null;
    lastName = null;
    role = null;
    email = null;
    password = null;
    isHasProfile = null;
    gender = null;
    listDesign = [];
  }
}

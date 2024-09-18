class UserModel {
  String? fullName;
  String? role;
  String? email;
  String? password;
  bool? isHasProfile;
  UserModel({
    this.fullName,
    this.role,
    this.email,
    this.password,
    this.isHasProfile,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['fullName'];
    password = json['role'];
    email = json['email'];
    password = json['password'];
    isHasProfile = json['isHasProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['role'] = this.role;
    data['email'] = this.email;
    data['password'] = this.password;
    data['isHasProfile'] = this.isHasProfile;
    return data;
  }
}

import 'package:flutter/material.dart';
import '../models/auth_model.dart';


class AppBloc extends ChangeNotifier {
  UserModel _currentUser = UserModel();
  // CreateProfileModel _createProfile = CreateProfileModel();
  // SettingModel _createSetting = SettingModel();
  // LocationModel _createLocation = LocationModel();

  Stream<UserModel> get currentUserStream => Stream.value(_currentUser);

  // Stream<CreateProfileModel> get profileCreateStream =>
  //     Stream.value(_createProfile);
  //
  // Stream<SettingModel> get settingCreateStream => Stream.value(_createSetting);
  //
  // Stream<LocationModel> get currentLocationStream =>
  //     Stream.value(_createLocation);


  void logInSuccess(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void logOutSuccess() {
    _currentUser = UserModel();
    notifyListeners();
  }

}
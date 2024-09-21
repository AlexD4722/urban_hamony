import 'package:flutter/material.dart';

class RoomTypeProvider with ChangeNotifier {
  String _selectedRoomType = 'rectangle';

  String get selectedRoomType => _selectedRoomType;

  void setSelectedRoomType(String type) {
    _selectedRoomType = type;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class RootProvider with ChangeNotifier {
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void setPageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }
  void clear() {
    _pageIndex = 0;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
class RootProvider with ChangeNotifier {
  String pageIndex = 'Home';
  void setPageIndex(String index) {
    pageIndex = index;
    notifyListeners();
  }

  int getPageIndex() {
    switch (pageIndex) {
      case 'Home':
        return 0;
      case 'Project':
        return 1;
      case 'Gallery':
        return 2;
      case 'Profile':
        return 3;
      default:
        return 0;
    }
  }
}

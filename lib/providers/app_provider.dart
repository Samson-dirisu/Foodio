
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  // private variables
  int _page = 0;
  bool _permissionAllowed = false;

  //getters
  int get page => _page;
  bool get permissioAllowed => _permissionAllowed;

  void changePage(int value) {
    _page = value;
    notifyListeners();
  }
  
}

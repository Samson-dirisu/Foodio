import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {

  // private variables
  int _page = 0;

  //getters
  int get page => _page;

  void changePage(int value) {
    _page = value;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

class Nav {
  // 
   Future<dynamic> pushReplacement(
      {BuildContext context, Widget destination}) {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return destination;
    }));
  }

   Future<dynamic> push({BuildContext context, Widget destination}) {
   return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return destination;
    }));
  }

   void pop(BuildContext context) {
    return Navigator.pop(context);
  }
} 

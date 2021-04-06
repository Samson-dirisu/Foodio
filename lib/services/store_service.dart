import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "vendors";

 getTopPickedStore() {
    return _firestore
        .collection(collection)
        .where("accVerified", isEqualTo: true)
        .where("isTopPicked", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }
}

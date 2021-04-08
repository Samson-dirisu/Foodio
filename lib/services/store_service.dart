import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "vendors";

 Stream<QuerySnapshot> getTopPickedStore() {
    return _firestore
        .collection(collection)
        .where("accVerified", isEqualTo: true)
        .where("isTopPicked", isEqualTo: true)
        .orderBy("shopName")
        .snapshots();
  }
}

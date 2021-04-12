import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodio/models/user_model.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create new user
  Future<void> createUser(Map<String, dynamic> values) async {
    String id = values["id"];
    await _firestore.collection(collection).doc(id).set(values);
  }

  // update user data
  Future<void> updataUserData(Map<String, dynamic> values) async {
    String id = values["id"];
    await _firestore.collection(collection).doc(id).update(values);
  }

  // get user by user id
  Future<UserModel> getUserById(String id) =>
    _firestore
    .collection(collection)
    .doc(id)
    .get()
    .then((snapshot){
      return UserModel.fromSnapshot(snapshot);
    });
  
}

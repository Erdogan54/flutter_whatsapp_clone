import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/main.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDbService implements DBBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser({required UserModel? user}) async {
    if (user == null) {
      scaffoldKey.currentState?.showSnackBar(const SnackBar(content: Text("user==null ; user not saved to firebase !")));
      return false;
    }

    await _fireStore.collection("users").doc(user.userId).set(user.toMap());

    DocumentSnapshot _okunanUser = await _fireStore.doc("users/${user.userId}").get();
    // print(_okunanUser.data());
    final getUser = UserModel.fromMap(_okunanUser.data() as Map<String, dynamic>);
    // print(getUser.email);
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(" ${getUser.email}\n ${getUser.userId} kaydedildi")));

    return true;
  }
}

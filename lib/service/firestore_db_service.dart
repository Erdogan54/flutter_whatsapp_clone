import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';

import '../main.dart';
import '../models/user_model.dart';
import 'db_base.dart';

class FireStoreDbService implements DBBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser({required UserModel? user}) async {
    if (user == null) {
      MyConst.debugP("FireStoreDbService.saveUser error: user == null");
      return false;
    } else {
      await _fireStore.collection("users").doc(user.userId).set(user.toMap());
      return true;
    }
  }

  @override
  Future<UserModel?>? readUser(String? userId) async {
    if (userId?.isEmpty ?? true) {
      MyConst.debugP("FireStoreDbService.readUser error: userId empty");
      return null;
    }
    final readedUser = await _fireStore.doc("users/$userId").get();
    if (readedUser.data() != null) {
      final readedUserMap = readedUser.data() as Map<String, dynamic>;
      UserModel user = UserModel.fromMap(readedUserMap);

      MyConst.debugP("hoş geldin ${user.userName}");

      return user;
    }
    return null;
  }

  @override
  Future<bool> updateUserName({required String? userId, required String newUserName}) async {
    final users = await _fireStore.collection("users").where("userName", isEqualTo: newUserName).get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _fireStore.collection("users").doc(userId).update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl}) async {
    await _fireStore.collection("users").doc(userId).update({"photoUrl": photoUrl});
    return true;
  }


}

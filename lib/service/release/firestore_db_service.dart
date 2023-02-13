import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_whatsapp_clone/models/chat_model.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';

import '../../constants/my_const.dart';
import '../../models/user_model.dart';
import '../base/db_base.dart';

import 'package:async/async.dart';

class FireStoreDbService implements DBBase {
  final FirebaseFirestore _firebaseDBService = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser({required UserModel? user}) async {
    if (user == null) {
      MyConst.debugP("FireStoreDbService.saveUser error: user == null");
      return false;
    } else {
      await _firebaseDBService.collection("users").doc(user.userId).set(user.toMap());
      return true;
    }
  }

  @override
  Future<UserModel?>? readUser(String? userId) async {
    if (userId?.isEmpty ?? true) {
      MyConst.debugP("FireStoreDbService.readUser error: userId empty");
      return null;
    }
    final readedUser = await _firebaseDBService.doc("users/$userId").get();
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
    final users = await _firebaseDBService.collection("users").where("userName", isEqualTo: newUserName).get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDBService.collection("users").doc(userId).update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl}) async {
    await _firebaseDBService.collection("users").doc(userId).update({"photoUrl": photoUrl});
    return true;
  }

  @override
  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    var snapshot = _firebaseDBService
        .collection("chats")
        .doc("$fromUserID--$toUserID")
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();

    return snapshot
        .map((messageList) => messageList.docs.map((message) => MessageModel.fromMap(message.data())).toList());
  }

  @override
  Future<bool> saveMessage(MessageModel willBeSavedMessage) async {
    try {
      final messageID = _firebaseDBService.collection("chats").doc().id;
      final fromUserDocID = "${willBeSavedMessage.fromUserID}--${willBeSavedMessage.toUserID}";
      final toUserDocID = "${willBeSavedMessage.toUserID}--${willBeSavedMessage.fromUserID}";

      final fromUserMessageMap = willBeSavedMessage.toMap();

      ///////// message sending /////

      await _firebaseDBService
          .collection("chats")
          .doc(fromUserDocID)
          .collection("messages")
          .doc(messageID)
          .set(fromUserMessageMap);

      await _firebaseDBService.collection("chats").doc(fromUserDocID).set(
        {
          "fromUserID": willBeSavedMessage.fromUserID,
          "toUserID": willBeSavedMessage.toUserID,
          "lastMessage": willBeSavedMessage.message,
          "isShow": false,
          "createdDate": FieldValue.serverTimestamp(),
          "displayedDate": null
        },
      );
      ///////// message receiver /////
      willBeSavedMessage.isFromMe = false;
      final toUserMessageMap = willBeSavedMessage.toMap();
      await _firebaseDBService
          .collection("chats")
          .doc(toUserDocID)
          .collection("messages")
          .doc(messageID)
          .set(toUserMessageMap);

      await _firebaseDBService.collection("chats").doc(toUserDocID).set(
        {
          "fromUserID": willBeSavedMessage.toUserID,
          "toUserID": willBeSavedMessage.fromUserID,
          "lastMessage": willBeSavedMessage.message,
          "isShow": false,
          "createdDate": FieldValue.serverTimestamp(),
          "displayedDate": null
        },
      );

      return true;
    } on Exception catch (e) {
      MyConst.showSnackBar("firestore_db_service saveMessage exception: $e");
    }

    return false;
  }

  @override
  Stream<List<ChatModel>> getAllConversations(String? fromUserId) {
    final querySnapshot = _firebaseDBService
        .collection("chats")
        .where("fromUserID", isEqualTo: fromUserId)
        .orderBy("createdDate", descending: true)
        .snapshots();
    var result = querySnapshot.map((userList) => userList.docs.map((chat) => ChatModel.fromMap(chat.data())).toList());

    return result;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> userList = [];
    final querySnapshot = await _firebaseDBService.collection("users/").get();
    userList = querySnapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
    // for (var data in querySnapshot.docs) {
    //   final user = UserModel.fromMap(data.data());
    //   userList.add(user);
    // }

    return userList;
  }

  @override
  Future<DateTime?> getServerDateTime(String? fromUserId) async {
    await _firebaseDBService.collection("server").doc(fromUserId).set({"time": FieldValue.serverTimestamp()});
    final readedMap = await _firebaseDBService.collection("server").doc(fromUserId).get();
    Timestamp? readedDateTime = readedMap.data()?["time"];
    return readedDateTime?.toDate();
  }
}

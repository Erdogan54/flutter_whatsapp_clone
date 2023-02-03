import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';
import '../../app/error_exception.dart';
import '../../constants/my_const.dart';
import '../../models/user_model.dart';
import '../base/db_base.dart';

class FireStoreDbService implements DBBase {
  final FirebaseFirestore _fireStoreDBService = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser({required UserModel? user}) async {
    if (user == null) {
      MyConst.debugP("FireStoreDbService.saveUser error: user == null");
      return false;
    } else {
      await _fireStoreDBService.collection("users").doc(user.userId).set(user.toMap());
      return true;
    }
  }

  @override
  Future<UserModel?>? readUser(String? userId) async {
    if (userId?.isEmpty ?? true) {
      MyConst.debugP("FireStoreDbService.readUser error: userId empty");
      return null;
    }
    final readedUser = await _fireStoreDBService.doc("users/$userId").get();
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
    final users = await _fireStoreDBService.collection("users").where("userName", isEqualTo: newUserName).get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _fireStoreDBService.collection("users").doc(userId).update({"userName": newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl}) async {
    await _fireStoreDBService.collection("users").doc(userId).update({"photoUrl": photoUrl});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> userList = [];
    final querySnapshot = await _fireStoreDBService.collection("users/").get();
    userList = querySnapshot.docs.map((e) => UserModel.fromMap(e.data())).toList();
    // for (var data in querySnapshot.docs) {
    //   final user = UserModel.fromMap(data.data());
    //   userList.add(user);
    // }

    return userList;
  }

  @override
  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    var snapshot = _fireStoreDBService
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
    saveLastMessage(willBeSavedMessage);
    try {
      final messageID = _fireStoreDBService.collection("chats").doc().id;
      final fromUserDocID = "${willBeSavedMessage.fromUserID}--${willBeSavedMessage.toUserID}";
      final toUserDocID = "${willBeSavedMessage.toUserID}--${willBeSavedMessage.fromUserID}";

      final fromUserMessageMap = willBeSavedMessage.toMap();

      await _fireStoreDBService
          .collection("chats")
          .doc(fromUserDocID)
          .collection("messages")
          .doc(messageID)
          .set(fromUserMessageMap);

      willBeSavedMessage.isFromMe = false;
      final toUserMessageMap = willBeSavedMessage.toMap();

      await _fireStoreDBService
          .collection("chats")
          .doc(toUserDocID)
          .collection("messages")
          .doc(messageID)
          .set(toUserMessageMap);
      return true;
    } on Exception catch (e) {
      MyConst.showSnackBar("firestore_db_service saveMessage exception: $e");
    }

    return false;
  }

  @override
  Future<bool> saveLastMessage(MessageModel willBeSavedMessage) async {
    final fromUserDocID = "${willBeSavedMessage.fromUserID}--${willBeSavedMessage.toUserID}";
    final toUserDocID = "${willBeSavedMessage.toUserID}--${willBeSavedMessage.fromUserID}";

    final fromUserMessageMap = willBeSavedMessage.toMap();

    await _fireStoreDBService
        .collection("chats")
        .doc(fromUserDocID)
        .collection("last_message")
        .doc(willBeSavedMessage.date?.toLocal().toString() ?? "last_message")
        .set(fromUserMessageMap);

    willBeSavedMessage.isFromMe = false;
    final toUserMessageMap = willBeSavedMessage.toMap();

    await _fireStoreDBService
        .collection("chats")
        .doc(toUserDocID)
        .collection("last_message")
        .doc(willBeSavedMessage.date?.toLocal().toString() ?? "last_message")
        .set(toUserMessageMap);

    return true;
  }

  @override
  Stream<String?> getLastMessage(String? fromUserId, String? toUserId) {
    final fromUserDocID = "$fromUserId--$toUserId";

    final snapshot = _fireStoreDBService
        .collection("chats")
        .doc(fromUserDocID)
        .collection("last_message")
        .doc("last_message")
        .snapshots();

    final result = snapshot.map((event) => MessageModel.fromMap(event.data()).message);

    return result;
  }
}

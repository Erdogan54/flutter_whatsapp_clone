import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';

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
        .limit(1)
        .snapshots();

    final result =
        snapshot.map((messageList) => messageList.docs.map((message) => MessageModel.fromMap(message.data())).toList());

    print(result);
    return result;
  }

  @override
  Future<bool> sendAndSaveMessage(MessageModel willBeSavedMessage) async {
    try {
      final messageID = _firebaseDBService.collection("chats").doc().id;
      final fromUserDocID = "${willBeSavedMessage.fromUserID}--${willBeSavedMessage.toUserID}";
      final toUserDocID = "${willBeSavedMessage.toUserID}--${willBeSavedMessage.fromUserID}";

      final fromUserMessageMap = willBeSavedMessage.toMap();

      ///////// fromUser Database /////
      await _firebaseDBService.collection("chats").doc(fromUserDocID).set(
        {
          "fromUserID": willBeSavedMessage.fromUserID,
          "toUserID": willBeSavedMessage.toUserID,
          "lastMessage": willBeSavedMessage.message,
          "isShow": false,
          "createdDate": fromUserMessageMap["date"],
          "displayedDate": null,
        },
      );

      await _firebaseDBService
          .collection("chats")
          .doc(fromUserDocID)
          .collection("messages")
          .doc(messageID)
          .set(fromUserMessageMap);

      ///////// toUser Database /////
      willBeSavedMessage.isFromMe = false;
      final toUserMessageMap = willBeSavedMessage.toMap();

      await _firebaseDBService.collection("chats").doc(toUserDocID).set(
        {
          "fromUserID": willBeSavedMessage.toUserID,
          "toUserID": willBeSavedMessage.fromUserID,
          "lastMessage": willBeSavedMessage.message,
          "isShow": false,
          "createdDate": toUserMessageMap["date"],
          "displayedDate": null
        },
      );

      await _firebaseDBService
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
  Stream<List<ChatModel>> getAllConversations(String? fromUserId) {
    final querySnapshot = _firebaseDBService
        .collection("chats")
        .where("fromUserID", isEqualTo: fromUserId)
        .orderBy("createdDate", descending: true)
        .snapshots();
    var result = querySnapshot.map((userList) => userList.docs.map((chat) {
          print("createdDate: ${chat.data()["createdDate"]}");
          print("toUserID: ${chat.data()["toUserID"]}");
          print("fromUserID: ${chat.data()["fromUserID"]}");
          return ChatModel.fromMap(chat.data());
        }).toList());

    return result;
  }

  @override
  Future<DateTime?> getServerDateTime(String? fromUserId) async {
    await _firebaseDBService.collection("server").doc(fromUserId).set({"time": FieldValue.serverTimestamp()});
    final readedMap = await _firebaseDBService.collection("server").doc(fromUserId).get();
    Timestamp? readedDateTime = readedMap.data()?["time"];
    print("result server time ${readedDateTime}");
    return readedDateTime?.toDate();
  }

  @override
  Future<List<UserModel>> getUsersWithPagination(UserModel? lastUser, int userCount) async {
    QuerySnapshot querySnapshot;

    List<UserModel> allUsers = [];
    if (lastUser == null) {
      print("kullanıcılar ilk olarak getiriliyor - database service");
      querySnapshot = await FirebaseFirestore.instance.collection("users").orderBy("userName").limit(userCount).get();
    } else {
      print("sonraki kullanıcılar getirirliyor - database service");
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([lastUser.userName])
          .limit(userCount)
          .get();
      //await Future.delayed(const Duration(seconds: 1));
    }

    for (var snap in querySnapshot.docs) {
      UserModel user = UserModel.fromMap(snap.data() as Map<String, dynamic>);
      allUsers.add(user);
     // print("getirilen userName: ${user.userName} - database service");
    }

    return allUsers;
  }

  Future<List<MessageModel>> getMessagesWithPagination(
      String? fromUserId, String? toUserId, int messageCount, MessageModel? lastMessage) async {
    QuerySnapshot querySnapshot;

    List<MessageModel> allMessages = [];
    if (lastMessage == null) {
      print("mesajlar ilk olarak getiriliyor - database service");
      querySnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc("$fromUserId--$toUserId")
          .collection("messages")
          .orderBy("date", descending: true)
          //.startAfter([lastMessage])
          .limit(messageCount)
          .get();
    } else {
      print("önceki mesajlar getirirliyor - database service");
      querySnapshot = await FirebaseFirestore.instance
          .collection("chats")
          .doc("$fromUserId--$toUserId")
          .collection("messages")
          .orderBy("date", descending: true)
          .startAfter([lastMessage.date])
          .limit(messageCount)
          .get();
      //await Future.delayed(const Duration(seconds: 1));
    }

    for (var snap in querySnapshot.docs) {
      MessageModel message = MessageModel.fromMap(snap.data() as Map<String, dynamic>);
      allMessages.add(message);
      // print("getirilen message: $message - database service");
    }

    //print(allMessages);

    return allMessages;
  }

  Future<List<MessageModel>> getLastMessages(String? fromUserId, String? toUserId, MessageModel? lastMessage) async {
    QuerySnapshot querySnapshot;

    List<MessageModel> allMessages = [];

    print("son mesajlar getirirliyor - database service");
    querySnapshot = await FirebaseFirestore.instance
        .collection("chats")
        .doc("$fromUserId--$toUserId")
        .collection("messages")
        .orderBy("date", descending: true)
        .endBefore([lastMessage?.date]).get();
    //await Future.delayed(const Duration(seconds: 1));

    for (var snap in querySnapshot.docs) {
      MessageModel message = MessageModel.fromMap(snap.data() as Map<String, dynamic>);
      allMessages.add(message);
      // print("getirilen message: $message - database service");
    }

    //print(allMessages);

    return allMessages;
  }
}

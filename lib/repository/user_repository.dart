// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/base/auth_base.dart';
import 'package:flutter_whatsapp_clone/service/release/firebase_auth_service.dart';

import '../constants/my_const.dart';
import '../models/chat_model.dart';
import '../service/debug/fake_auth_service.dart';
import '../service/release/firebase_storege_service.dart';
import '../service/release/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final _fakeAuthService = getIt<FakeAuthService>();
  final _fireAuthService = getIt<FirebaseAuthService>();
  final fireStoreDBService = getIt<FireStoreDbService>();
  final _firebaseStorageService = getIt<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<UserModel> allUser = [];

  @override
  Future<UserModel?>? currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      final user = await _fireAuthService.currentUser();
      return await fireStoreDBService.readUser(user?.userId);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      final user = await _fireAuthService.signInAnonymously();
      if (user == null) {
        MyConst.debugP("signInAnonymously: user == null");
        return null;
      }
      final result = await fireStoreDBService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInAnonymously: resultSaveUser == null");
        return null;
      }
      return await fireStoreDBService.readUser(user.userId);
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _fireAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      final user = await _fireAuthService.signInWithGoogle();

      UserModel? readedUser = await fireStoreDBService.readUser(user?.userId);
      if (readedUser == null) {
        await fireStoreDBService.saveUser(user: user);
        readedUser = await fireStoreDBService.readUser(user?.userId);
      } else {
        await fireStoreDBService.saveUser(user: readedUser);
      }
      return readedUser;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      final user = await _fireAuthService.signInWithFacebook();

      if (user == null) {
        MyConst.debugP("signInWithFacebook: user == null");
        return null;
      }

      final result = await fireStoreDBService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInWithFacebook: resultSaveUser == null");
        return null;
      }
      return await fireStoreDBService.readUser(user.userId);
    }
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email: email, password: password);
    } else {
      final user = await _fireAuthService.signInWithEmail(email: email, password: password);

      final readedUser = await fireStoreDBService.readUser(user?.userId);
      await fireStoreDBService.saveUser(user: readedUser);
      debugPrint("readUser ${readedUser?.userName ?? "null"}");
      return readedUser;
    }
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signUpEmailPass(email: email, password: password);
    } else {
      final user = await _fireAuthService.signUpEmailPass(email: email, password: password);
      await fireStoreDBService.saveUser(user: user);
      return await fireStoreDBService.readUser(user?.userId);
    }
  }

  Future<bool> updateUserName({required String? userId, required String newUserName}) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return fireStoreDBService.updateUserName(userId: userId, newUserName: newUserName);
    }
  }

  Future<String?> updateProfilePhoto({required String? userId, required String? fileType, required File? file}) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linkli";
    } else {
      final profilePhotoUrl = await _firebaseStorageService.uploadFile(userId: userId, fileType: fileType, file: file);
      fireStoreDBService.updateProfilePhoto(userId: userId, photoUrl: profilePhotoUrl);

      return profilePhotoUrl;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [UserModel(userId: null, email: null)];
    }
    return allUser = await fireStoreDBService.getAllUsers();
  }

  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    }
    return fireStoreDBService.getMessages(fromUserID, toUserID);
  }

  Future<bool> sendMessage(MessageModel willBeSavedMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    }
    return await fireStoreDBService.saveMessage(willBeSavedMessage);
  }

  Stream<List<ChatModel>> getAllConversations({String? fromUserId}) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    }

    return fireStoreDBService.getAllConversations(fromUserId);

    // List<ChatModel> newList = [];
    // var chatList = _fireStoreDBService.getAllConversations(fromUserId);

    // chatList.listen((e1) {
    //   e1.forEach((e2) {
    //     allUser.forEach((e) {
    //       if (e.userId == e2.toUserID) {
    //         e2.toUserName = e.userName;
    //         e2.toUserProfileURL = e.photoUrl;

    //         newList.add(e2);
    //       }
    //     });
    //   });
    // });

    // StreamController<List<ChatModel>> streamController = StreamController();
    // streamController.add(newList);

    // return streamController.stream;
  }
}

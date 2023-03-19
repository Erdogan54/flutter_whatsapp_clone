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
  final _fireStoreDBService = getIt<FireStoreDbService>();
  final _firebaseStorageService = getIt<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<UserModel> allUser = [];

  @override
  Future<UserModel?>? currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      final user = await _fireAuthService.currentUser();
      return await _fireStoreDBService.readUser(user?.userId);
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
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInAnonymously: resultSaveUser == null");
        return null;
      }
      return await _fireStoreDBService.readUser(user.userId);
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

      UserModel? readedUser = await _fireStoreDBService.readUser(user?.userId);
      if (readedUser == null) {
        await _fireStoreDBService.saveUser(user: user);
        readedUser = await _fireStoreDBService.readUser(user?.userId);
      } else {
        await _fireStoreDBService.saveUser(user: readedUser);
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

      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInWithFacebook: resultSaveUser == null");
        return null;
      }
      return await _fireStoreDBService.readUser(user.userId);
    }
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email: email, password: password);
    } else {
      final user = await _fireAuthService.signInWithEmail(email: email, password: password);

      final readedUser = await _fireStoreDBService.readUser(user?.userId);
      await _fireStoreDBService.saveUser(user: readedUser);
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
      await _fireStoreDBService.saveUser(user: user);
      return await _fireStoreDBService.readUser(user?.userId);
    }
  }

  Future<bool> updateUserName({required String? userId, required String newUserName}) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return _fireStoreDBService.updateUserName(userId: userId, newUserName: newUserName);
    }
  }

  Future<String?> updateProfilePhoto({required String? userId, required String? fileType, required File? file}) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linkli";
    } else {
      final profilePhotoUrl = await _firebaseStorageService.uploadFile(userId: userId, fileType: fileType, file: file);
      _fireStoreDBService.updateProfilePhoto(userId: userId, photoUrl: profilePhotoUrl);

      return profilePhotoUrl;
    }
  }

  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    }
    return _fireStoreDBService.getMessages(fromUserID, toUserID);
  }

  Future<bool> sendMessage(MessageModel sendMessageModel) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    }
    return await _fireStoreDBService.sendAndSaveMessage(sendMessageModel);
  }

  Stream<List<ChatModel>> getAllConversations({String? fromUserId}) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    }

    return _fireStoreDBService.getAllConversations(fromUserId);
  }

  Future<List<UserModel>> getUsersWithPagination(UserModel? lastUser, int userCount) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    }

    return await _fireStoreDBService.getUsersWithPagination(lastUser, userCount);
  }

  Future<List<MessageModel>> getMessagesWithPagination(
      String? fromUserId, String? toUserUserId, int messageCount, MessageModel? lastMessages) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    }

    return await _fireStoreDBService.getMessagesWithPagination(fromUserId, toUserUserId, messageCount, lastMessages);
  }

  Future<DateTime?> getServerDateTime(fromUserId) async {
    return await _fireStoreDBService.getServerDateTime(fromUserId);
  }

  getLastMessages(String? fromUserId, String? toUserUserId, MessageModel? lastMessage) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    }

    return await _fireStoreDBService.getLastMessages(fromUserId, toUserUserId, lastMessage);
  }
}

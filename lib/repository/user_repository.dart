// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';
import 'package:flutter_whatsapp_clone/service/firebase_auth_service.dart';

import '../constants/my_const.dart';
import '../extensions/context_extension.dart';
import '../service/fake_auth_service.dart';
import '../service/firebase_storege_service.dart';
import '../service/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final _fakeAuthService = getIt<FakeAuthService>();
  final _fireAuthService = getIt<FirebaseAuthService>();
  final _fireStoreService = getIt<FireStoreDbService>();
  final _firebaseStorageService = getIt<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?>? currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      final user = await _fireAuthService.currentUser();
      return await _fireStoreService.readUser(user?.userId);
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
      final result = await _fireStoreService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInAnonymously: resultSaveUser == null");
        return null;
      }
      return await _fireStoreService.readUser(user.userId);
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
      final readedUser = await _fireStoreService.readUser(user?.userId);
      await _fireStoreService.saveUser(user: readedUser);

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

      final result = await _fireStoreService.saveUser(user: user);
      if (!result) {
        MyConst.debugP("signInWithFacebook: resultSaveUser == null");
        return null;
      }
      return await _fireStoreService.readUser(user.userId);
    }
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email: email, password: password);
    } else {
      final user = await _fireAuthService.signInWithEmail(email: email, password: password);

      final readedUser = await _fireStoreService.readUser(user?.userId);
      await _fireStoreService.saveUser(user: readedUser);
      print("readUser ${readedUser?.userName ?? "null"}");
      return readedUser;
    }
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signUpEmailPass(email: email, password: password);
    } else {
      final user = await _fireAuthService.signUpEmailPass(email: email, password: password);
      await _fireStoreService.saveUser(user: user);
      return await _fireStoreService.readUser(user?.userId);
    }
  }

  Future<bool> updateUserName({required String? userId, required String newUserName}) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return _fireStoreService.updateUserName(userId: userId, newUserName: newUserName);
    }
  }

  Future<String?> updateProfilePhoto({required String? userId, required String? fileType, required File? file}) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linkli";
    } else {
      final profilePhotoUrl = await _firebaseStorageService.uploadFile(userId: userId, fileType: fileType, file: file);
      _fireStoreService.updateProfilePhoto(userId: userId, photoUrl: profilePhotoUrl);

      return profilePhotoUrl;
    }
  }
}

// ignore_for_file: constant_identifier_names

import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';
import 'package:flutter_whatsapp_clone/service/firebase_auth_service.dart';

import '../service/fake_auth_service.dart';
import '../service/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final _fakeAuthService = getIt<FakeAuthService>();
  final _fireAuthService = getIt<FirebaseAuthService>();
  final _fireStoreDBService = getIt<FireStoreDbService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?>? currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return await _fireAuthService.currentUser();
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      final user = await _fireAuthService.signInAnonymously();
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) return null;
      return user;
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
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) return null;
      return user;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithFacebook();
    } else {
      final user = await _fireAuthService.signInWithFacebook();
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) return null;
      return user;
    }
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmail(email: email, password: password);
    } else {
      final user = await _fireAuthService.signInWithEmail(email: email, password: password);
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) return null;
      return user;
    }
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signUpEmailPass(email: email, password: password);
    } else {
      final user = await _fireAuthService.signUpEmailPass(email: email, password: password);
      final result = await _fireStoreDBService.saveUser(user: user);
      if (!result) return null;
      return user;
    }
  }
}

// ignore_for_file: constant_identifier_names

import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';
import 'package:flutter_whatsapp_clone/service/firebase_auth_service.dart';

import '../service/fake_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {

  var fakeDb = getIt<FakeAuthenticationService>();
  var fireDb = getIt<FirebaseAuthService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await fakeDb.currentUser();
    } else {
      return await fireDb.currentUser();
    }
  }

  @override
  Future<UserModel?> signInAnonymously()async {
     if (appMode == AppMode.DEBUG) {
      return await fakeDb.signInAnonymously();
    } else {
      return await fireDb.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut()async {
     if (appMode == AppMode.DEBUG) {
      return await fakeDb.signOut();
    } else {
      return await  fireDb.signOut();
    }
  }
  
  @override
  Future<UserModel?> signInWithGoogle() async {
     if (appMode == AppMode.DEBUG) {
      return await fakeDb.signInWithGoogle();
    } else {
      return await  fireDb.signInWithGoogle();
    }
  }
  
  @override
  Future<UserModel?> signInWithFacebook() async  {
    if (appMode == AppMode.DEBUG) {
      return await fakeDb.signInWithFacebook();
    } else {
      return await  fireDb.signInWithFacebook();
    }
  }
  
  @override
  Future<UserModel?> signInWithEmail() {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> signUpEmailPass() {
    // TODO: implement signUpEmailPass
    throw UnimplementedError();
  }
}

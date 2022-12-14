// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/repository/user_repository.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository userRepo = getIt<UserRepository>();
  UserModel? _user;

  UserModel? get user => _user;
  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?>? currentUser() async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.currentUser();
    } on Exception catch (e) {
      debugPrint("ViewModel currentUser Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.signInWithGoogle();
    } on Exception catch (e) {
      debugPrint("ViewModel signInWithGoogle Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.signInWithFacebook();
    } on Exception catch (e) {
      debugPrint("ViewModel signInWithFacebook Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.signUpEmailPass(email: email, password: password);
    } on Exception catch (e) {
      debugPrint("ViewModel signUpWithFacebook Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.signInWithEmail(email: email, password: password);
    } on Exception catch (e) {
      debugPrint("ViewModel signInWithFacebook Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      return _user = await userRepo.signInAnonymously();
    } on Exception catch (e) {
      debugPrint("ViewModel signInAnonymously Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await userRepo.signOut();
      _user = null;
      return result;
    } on Exception catch (e) {
      debugPrint("ViewModel signOut Error: $e");
    } finally {
      state = ViewState.Idle;
    }
    return false;
  }
}

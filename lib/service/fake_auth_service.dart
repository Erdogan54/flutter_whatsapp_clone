// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/auth_base.dart';

class FakeAuthenticationService extends AuthBase {
  final String userId = "65346812151546";

  @override
  Future<UserModel?> currentUser() {
    return Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: userId);
    });
  }

  @override
  Future<UserModel?> signInAnonymously() {
    return Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: userId);
    });
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }
  
  @override
  Future<UserModel?> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
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

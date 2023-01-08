// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/service/base/auth_base.dart';

class FakeAuthService extends AuthBase {
  final String userId = "65346812151546";

  @override
  Future<UserModel?> currentUser() {
    return Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: userId,email: "fakeuser@fake.com");
    });
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    return await Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: "signInAnonymously_$userId",email: "fakeuser@fake.com");
    });
  }

  @override
  Future<bool> signOut( ) {
    return Future.value(true);
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    return await Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: "google_user_id_123456",email: "fakeuser@fake.com");
    });
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return await Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: "facebook_user_id_123456",email: "fakeuser@fake.com");
    });
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    return await Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: "signInWithEmail_user_id_123456",email: "fakeuser@fake.com");
    });
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    return await Future.delayed(const Duration(milliseconds: 200), () {
      return UserModel(userId: "signUpEmailPass_user_id_123456",email: "fakeuser@fake.com");
    });
  }
}

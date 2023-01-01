// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

abstract class AuthBase {
 
  Future<UserModel?>? currentUser();
  Future<UserModel?> signInAnonymously();
  Future<bool> signOut( );
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithFacebook();
  Future<UserModel?> signUpEmailPass({required String email,required String password});
  Future<UserModel?> signInWithEmail({required String email,required String password});

}

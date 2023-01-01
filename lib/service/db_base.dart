import 'dart:io';

import '../models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser({required UserModel user});
  Future<UserModel?>? readUser(String userId);
  Future<bool> updateUserName({required String? userId, required String newUserName});
  Future<bool> updateProfilePhoto({required String? userId, required String? photoUrl});
}

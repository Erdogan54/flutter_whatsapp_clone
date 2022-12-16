import '../models/user_model.dart';

abstract class DBBase{
  Future<bool> saveUser({required UserModel user});
}
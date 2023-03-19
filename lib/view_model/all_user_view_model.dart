import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';

import '../get_it.dart';
import '../repository/user_repository.dart';
import '../service/base/auth_base.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  final _userRepo = getIt<UserRepository>();

  List<UserModel>? _allUser;
  List<UserModel>? allUserCache;

  UserModel? _lastUser;
  bool? _hasMore;
  bool? isFirstRequest;
  static const userCount = 15;

  List<UserModel>? get allUser => _allUser;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _allUser = [];
    _lastUser = null;
    isFirstRequest = true;
    getUserWithPagination(_lastUser);
  }

  Future<void> getUserWithPagination(UserModel? lastUser) async {
    state = AllUserViewState.Busy;

    final users = await _userRepo.getUsersWithPagination(lastUser, userCount);
    _hasMore = !(users.length < userCount);

    isFirstRequest == true ? _allUser = [] : null;

    _allUser?.addAll(users);
    _lastUser = _allUser?.isNotEmpty ?? false ? _allUser!.last : null;
   
    state = AllUserViewState.Loaded;
  
  }

  void getMoreUser() {
    if (state == AllUserViewState.Busy) return;
    isFirstRequest = false;
    if (_hasMore == true) {
      print("daha fazla user model getir - allUserViewModel");
      getUserWithPagination(_lastUser);
    } else if (_hasMore == false) {
      print("daha fazla kullanıcı olmadığından istek atılmadı - allUserViewModel");
    } else if (_hasMore == null) {
      print("hasMore null");
    }
  }

  Future<void> getAllUsers() async {
    if (state == AllUserViewState.Busy) return;
    isFirstRequest = true;

    print("kullanıcılar yeni baştan getir - allUserViewModel");

    return await getUserWithPagination(null);
  }
}

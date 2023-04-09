import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_whatsapp_clone/admob/revarded_ad.dart';
import '../app/pages/home_page/profile_page.dart/profil_page.dart';
import '../constants/my_const.dart';
import '../get_it.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../service/base/auth_base.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/chat_model.dart';

enum ViewState { idle, busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  UserViewModel() {
    currentUser();
  }
  final _userRepo = getIt<UserRepository>();
  ViewState _state = ViewState.idle;
  bool _isUpdateUserInfo = false;
  UserModel? user;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  final picker = ImagePicker();
  XFile? resultPicker;
  DateTime? currentServerTime;

  ViewState get state => _state;

  set isUpdateUserInfo(bool value) {
    _isUpdateUserInfo = value;
    notifyListeners();
  }

  bool get isUpdateUserInfo => _isUpdateUserInfo;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  void setUser(UserModel? model) {
    user = model;
    notifyListeners();
  }

  Future<DateTime?> getCurrentServerTime(String? fromUserId) async {
    currentServerTime = await _userRepo.getServerDateTime(fromUserId);
    print("update servertime: $currentServerTime");
    return currentServerTime;
  }

  bool emailPassCheck({required String email, required String pass}) {
    bool result = true;

    if (pass.length < 6) {
      passwordErrorMessage = "En az 6 karakter olmali";
      return false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains("@")) {
      emailErrorMessage = "Geçersiz email adresi";
      return false;
    } else {
      emailErrorMessage = null;
    }

    return result;
  }

  @override
  Future<UserModel?>? currentUser() async {
    try {
      state = ViewState.busy;
      return user = await _userRepo.currentUser();
    } on Exception catch (e) {
      debugPrint("ViewModel currentUser Error: $e");
    } finally {
      state = ViewState.idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      state = ViewState.busy;
      return user = await _userRepo.signInWithGoogle();
    } on Exception catch (e) {
      debugPrint("ViewModel signInWithGoogle Error: $e");
    } finally {
      state = ViewState.idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    try {
      state = ViewState.busy;
      return user = await _userRepo.signInWithFacebook();
    } on Exception catch (e) {
      debugPrint("ViewModel signInWithFacebook Error: $e");
    } finally {
      state = ViewState.idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    state = ViewState.busy;
    if (!emailPassCheck(email: email, pass: password)) {
      state = ViewState.idle;
      return null;
    }

    try {
      user = await _userRepo.signUpEmailPass(email: email, password: password);
    } finally {
      state = ViewState.idle;
    }

    return user;
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    try {
      state = ViewState.busy;
      if (!emailPassCheck(email: email, pass: password)) return null;

      return user = await _userRepo.signInWithEmail(email: email, password: password);
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.busy;
      return user = await _userRepo.signInAnonymously();
    } on Exception catch (e) {
      debugPrint("ViewModel signInAnonymously Error: $e");
    } finally {
      state = ViewState.idle;
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.busy;
      bool result = await _userRepo.signOut();
      if (result) {
        user = null;
        return result;
      }
    } on Exception catch (e) {
      debugPrint("ViewModel signOut Error: $e");
    } finally {
      state = ViewState.idle;
    }
    return false;
  }

  Future<bool> updateUserName(BuildContext context, {required String? userId, required String newUserName}) async {
    isUpdateUserInfo = true;
    bool result = false;

    if (user?.userName != newUserName) {
      result = await _userRepo.updateUserName(userId: userId, newUserName: newUserName);

      if (result == true) {
        user?.userName = newUserName;
        MyConst.showSnackBar("User name değiştirildi");
      } else {
        controllerUserNameKey.currentState
            ?.didChange(user?.userName ?? await currentUser()?.then((value) => value?.userName));
        user?.userName = MyConst.showSnackBar("User name zaten kullanımda..");
      }
    }

    isUpdateUserInfo = false;

    return result;
  }

  Future<bool> kameradanFotoCek() async {
    resultPicker = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    //getAllUsers();
    updateProfilPhoto();
    notifyListeners();

    return true;
  }

  void galeridenFotoSec() async {
    resultPicker = await picker.pickImage(source: ImageSource.gallery);

    updateProfilPhoto();
    notifyListeners();
  }

  Future<String?> updateProfilPhoto() async {
    if (resultPicker != null) {
      final url = await _userRepo.updateProfilePhoto(
          userId: user?.userId, file: File(resultPicker!.path), fileType: "profile_photo.png");
      if (url != null) {
        MyConst.showSnackBar("Profil fotoğrafınız güncellendi");
      }
      return url;
    }
    return null;
  }

  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    return _userRepo.getMessages(fromUserID, toUserID);
  }

  Stream<List<ChatModel>> getAllConversations({String? fromUserId}) {
    return _userRepo.getAllConversations(fromUserId: fromUserId);
  }

  List<ChatModel> chatModelDataUpdate(List<ChatModel> chatModels, List<UserModel> allUsers) {
    for (var allUserElement in allUsers) {
      for (var chatModelElement in chatModels) {
        if (allUserElement.userId == chatModelElement.toUserID) {
          chatModelElement.toUserName = allUserElement.userName;
          chatModelElement.toUserProfileURL = allUserElement.photoUrl;
          chatModelElement.timeAgo = getTimeAgo(chatModelElement.createdDate);
        }
      }
    }

    return chatModels;
  }

  String? getTimeAgo(Timestamp? messageCreatedTime) {
    // print("messageCreatedTime: ${messageCreatedTime?.toDate()}");
    // print("currentServerTime: ${currentServerTime}");

    var duration = currentServerTime?.difference(messageCreatedTime?.toDate() ?? DateTime.now());

    timeago.setLocaleMessages("tr", timeago.TrMessages());
    var differentTime =
        timeago.format((currentServerTime ?? DateTime.now()).subtract(duration ?? const Duration()), locale: "tr");

    return differentTime;
  }

  Future<List<UserModel>> getUsersWithPagination(UserModel? lastUser, int i) async {
    return await _userRepo.getUsersWithPagination(lastUser, i);
  }
}

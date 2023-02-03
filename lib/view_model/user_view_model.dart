import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_whatsapp_clone/app/pages/profil_page.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:flutter_whatsapp_clone/get_it.dart';
import 'package:flutter_whatsapp_clone/models/message_model.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:flutter_whatsapp_clone/repository/user_repository.dart';
import 'package:flutter_whatsapp_clone/service/base/auth_base.dart';
import 'package:image_picker/image_picker.dart';

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
    notifyListeners();
    return true;
  }

  void galeridenFotoSec() async {
    resultPicker = await picker.pickImage(source: ImageSource.gallery);
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

  Future<List<UserModel>> getAllUsers() async {
    return await _userRepo.getAllUsers();
  }

  Stream<List<MessageModel>> getMessages(String? fromUserID, String? toUserID) {
    return _userRepo.getMessages(fromUserID, toUserID);
  }

  Future<bool> sendMessage(MessageModel willBeSavedMessage) async {
    return await _userRepo.sendMessage(willBeSavedMessage);
  }

  Stream<String?> getLastMessage(String? fromUserId, String? toUserId)  {
    return  _userRepo.getLastMessage(fromUserId, toUserId);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constants/my_const.dart';
import '../../main.dart';
import '../../models/user_model.dart';
import '../base/auth_base.dart';

class FirebaseAuthService extends AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String? _userEmail;
  bool _isSignGoogle = false;

  Future<UserModel?> _userFromFirebase(User? user) async {
    // print("user.email ${user?.email}");
    // print("user.displayName ${user?.displayName}");
    // print("user.emailVerified ${user?.emailVerified}");
    // print("user.isAnonymous ${user?.isAnonymous}");
    // print("user.metadata ${user?.metadata}");
    // print("user.phoneNumber ${user?.phoneNumber}");
    // print("user.photoURL ${user?.photoURL}");
    // print("user.providerData ${user?.providerData}");
    // print("user.refreshToken ${user?.refreshToken}");
    // print("user.tenantId ${user?.tenantId}");
    // print("user.uid ${user?.uid}");

    if (user != null) {
      String? emailCreate() {
        if (user.email == null) {
          if (_isSignGoogle) {
            return _userEmail;
          }
          return null;
        }
        return user.email;
      }

      return UserModel(userId: user.uid, email: emailCreate(), photoUrl: user.photoURL);
    }
    return null;
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } on Exception catch (e) {
      debugPrint("currentUser error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      var credential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(credential.user);
    } on Exception catch (e) {
      debugPrint("sign in error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _signOutGoogle();
      await FacebookLogin().logOut();
      await _firebaseAuth.signOut();

      return true;
    } on Exception catch (e) {
      MyConst.debugP("sign out error: $e");
      return false;
    }
  }

  Future<void> _signOutGoogle() async {
    await GoogleSignIn().signOut();
    _isSignGoogle = false;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignInAccount? googleAccount = await GoogleSignIn().signIn();
    _userEmail = googleAccount?.email;
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        UserCredential googleCredential = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        _isSignGoogle = true;
        return _userFromFirebase(googleCredential.user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    final fb = FacebookLogin();

    final res = await fb.logIn(
        permissions: [FacebookPermission.publicProfile, FacebookPermission.email, FacebookPermission.userBirthday]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = res.accessToken;
        debugPrint("acces token: $accessToken");

        if (accessToken != null) {
          final facebookCredential =
              await _firebaseAuth.signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
          debugPrint("facebook credential: ${facebookCredential.credential}");

          final profile = await fb.getUserProfile();
          debugPrint("hello ${profile?.name}  You Id ${profile?.userId}");

          final imageUrl = await fb.getProfileImageUrl(width: 100);
          debugPrint('Your profile image: $imageUrl');

          final email = await fb.getUserEmail();
          debugPrint('And your email is $email');

          return _userFromFirebase(facebookCredential.user);
        }

        break;

      case FacebookLoginStatus.cancel:
        debugPrint("Kullanıcı facebook girişi iptal edildi ");
        break;

      case FacebookLoginStatus.error:
        debugPrint('Error while log in: ${res.error}');
        scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(res.error.toString())));
        break;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(credential.user);
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    return _userFromFirebase(credential.user);
  }
}

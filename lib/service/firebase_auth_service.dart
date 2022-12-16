import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_whatsapp_clone/main.dart';
import '../models/user_model.dart';
import 'auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService extends AuthBase {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserModel?> _userFromFirebase(User? user) async {
    if (user != null) {
     //DocumentSnapshot snapshot = await _fireStore.doc("user/${user.uid}").get();
     // final getUser = UserModel.fromJson(snapshot.data().toString());

     // scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text("hoş geldin ${getUser.email}")));
      return UserModel(userId: user.uid, email: user.email);
    }
    return null;
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _fireAuth.currentUser;
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
      var credential = await _fireAuth.signInAnonymously();
      return _userFromFirebase(credential.user);
    } on Exception catch (e) {
      print("sign in error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookLogin().logOut();
      await _fireAuth.signOut();

      return true;
    } on Exception catch (e) {
      debugPrint("sign out error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignInAccount? _googleAccount = await GoogleSignIn().signIn();

    if (_googleAccount != null) {
      GoogleSignInAuthentication _googleAuth = await _googleAccount.authentication;
      debugPrint(_googleAuth.accessToken);
      debugPrint("_googleAuth.idToken  ${_googleAuth.idToken}");

      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential _googleCredential =
            await _fireAuth.signInWithCredential(GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken));

        print(_googleCredential.credential);
        return _userFromFirebase(_googleCredential.user);
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

    final res = await fb.logIn(permissions: [FacebookPermission.publicProfile, FacebookPermission.email, FacebookPermission.userBirthday]);

    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = res.accessToken;
        print("acces token: $accessToken");

        if (accessToken != null) {
          final _facebookCredential = await _fireAuth.signInWithCredential(FacebookAuthProvider.credential(accessToken.token));
          debugPrint("facebook credential: ${_facebookCredential.credential}");

          final profile = await fb.getUserProfile();
          debugPrint("hello ${profile?.name}  You Id ${profile?.userId}");

          final imageUrl = await fb.getProfileImageUrl(width: 100);
          print('Your profile image: $imageUrl');

          final email = await fb.getUserEmail();
          print('And your email is $email');

          return _userFromFirebase(_facebookCredential.user);
        }

        break;

      case FacebookLoginStatus.cancel:
        debugPrint("Kullanıcı facebook girişi iptal edildi ");
        break;

      case FacebookLoginStatus.error:
        print('Error while log in: ${res.error}');
        scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(res.error.toString())));
        break;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmail({required String email, required String password}) async {
    try {
      var credential = await _fireAuth.signInWithEmailAndPassword(email: email, password: password);

      return _userFromFirebase(credential.user);
    } on Exception catch (e) {
      print("sign in error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }

  @override
  Future<UserModel?> signUpEmailPass({required String email, required String password}) async {
    try {
      var credential = await _fireAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(credential.user);
    } on Exception catch (e) {
      print("sign up error: $e");
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.toString())));
      return null;
    }
  }
}

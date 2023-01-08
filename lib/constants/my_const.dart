import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyConst {
  static debugP(String? label) {
    if (kDebugMode) {
      debugPrint(label);
      //scaffoldKey.currentState?.hideCurrentSnackBar();
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label ?? "null")));
    }
  }

  static showSnackBar(String label) {
    debugPrint(label);
    //scaffoldKey.currentState?.hideCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label)));
  }

  static get defaultProfilePhotoUrl =>
      "https://firebasestorage.googleapis.com/v0/b/flutter-whatsapp-clone-3d171.appspot.com/o/defaultProfilePhoto%2Fblank-profile-picture-973460__480%20(1).png?alt=media&token=f2d6db0a-57e2-42f2-92ba-cb6bf1445eef";
}

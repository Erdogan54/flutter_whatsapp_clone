import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MyConst {
  static debugP(String? label) {
    if (kDebugMode) {
      debugPrint(label);
      scaffoldKey.currentState?.hideCurrentSnackBar();
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label ?? "null")));
    }
  }

  static showSnackBar(String label) {
    debugPrint(label);
    scaffoldKey.currentState?.hideCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label)));
  }
}

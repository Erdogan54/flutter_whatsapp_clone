import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

extension ContextExtension on BuildContext {
  debugP(String label) {
    if (kDebugMode) {
      debugPrint(label);
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label)));
    }
  }
}

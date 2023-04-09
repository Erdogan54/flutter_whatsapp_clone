import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

extension ContextExtension on BuildContext {
  void debugP(String label) {
    if (kDebugMode) {
      debugPrint(label);
      scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(label)));
    }
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  double get height {
    return MediaQuery.of(this).size.height;
  }
}

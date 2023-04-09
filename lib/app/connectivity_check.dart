import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../constants/my_const.dart';

class ConnectivityCheck {
  static ConnectivityCheck? _instance;
  static ConnectivityCheck get instance {
    return _instance ??= ConnectivityCheck._();
  }

  late final Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityCheck._() {
    _connectivity = Connectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      MyConst.showSnackBar(result.toString(), 1);
    });
  }

 void dispose() {
 
    _connectivitySubscription.cancel();
  }
}

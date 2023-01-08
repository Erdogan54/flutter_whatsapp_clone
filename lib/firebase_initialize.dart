import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'constants/my_const.dart';

import 'firebase_options.dart';

firebaseInitialize() async {
  debugPrint("firebase initialize başladı..${DateTime.now()}");

  try {
    WidgetsFlutterBinding.ensureInitialized();

    return await Firebase.initializeApp(
      name: "flutter_whatsapp_clone",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    MyConst.debugP(e.toString());
  }
}

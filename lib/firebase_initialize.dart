import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

firebaseInitialzie() async {
  print("firebase initialize basşladı..${DateTime.now()}");

  WidgetsFlutterBinding.ensureInitialized();

  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

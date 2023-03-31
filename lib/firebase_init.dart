import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/service/notification/receive_notifications.dart';
import 'constants/my_const.dart';

import 'firebase_options.dart';

Future<void> firebaseInit() async {
  await Firebase.initializeApp(
    name: "flutter_whatsapp_clone",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ReceiveNotificationService.instance;
}

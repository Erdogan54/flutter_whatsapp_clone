import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_whatsapp_clone/constants/my_const.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("message.notification ${message.notification}");

  print("Handling a background message: ${message.messageId}");
}

class FirebaseNotifications {
  late final FirebaseMessaging _messaging;
  static FirebaseNotifications? _instance;
  static FirebaseNotifications get instance {
    return _instance ??= FirebaseNotifications._();
  }

  FirebaseNotifications._() {
    _messaging = FirebaseMessaging.instance;
    _initNotifications();
  }

  _notificationsRequestPermission() async {
    String? token = await _messaging.getToken();
    print("token: $token ");

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  _listenNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification?.title}');
        MyConst.showSnackBar(message.notification?.title ?? "", 5);
      }
    });
  }

  _onRefreshToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print("fcmToken guncellendi $fcmToken");
    }).onError((err) {
      print("fcmToken guncellenirken hata $err");
    });
  }

  _initNotifications() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await _notificationsRequestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _listenNotifications();
    _onRefreshToken();
  }
}

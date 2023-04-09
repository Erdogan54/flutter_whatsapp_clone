import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_whatsapp_clone/constants/my_const.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../app/pages/home_page/chat_page/chat_page.dart';
import '../../models/user_model.dart';
import '../../view_model/user_view_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("_firebaseMessagingBackgroundHandler");

  await Firebase.initializeApp();

  ReceiveNotificationService.instance.showLocalNotification(message: message.data);
}

@pragma('vm:entry-point')
void localNotificationTapBackground(NotificationResponse notificationResponse) {
  Map<String, dynamic> message = {
    "data": {
      "title": "${notificationResponse.input}",
      "message": "${notificationResponse.payload}",
    }
  };
  print("_firebaseMessagingBackgroundHandler");
  ReceiveNotificationService.instance.showLocalNotification(message: message["data"]);

  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

class ReceiveNotificationService {
  late final FirebaseMessaging _messaging;
  static ReceiveNotificationService? _instance;
  static ReceiveNotificationService get instance {
    return _instance ??= ReceiveNotificationService._();
  }

  ReceiveNotificationService._() {
    _messaging = FirebaseMessaging.instance;
    _initNotifications();
    //_initLocalNotification();
  }

  _initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await _notificationsRequestPermission();
    // _messaging.subscribeToTopic("spor");

    _onForegroundNotifications();
    // getAndSaveToken();
  }

  late final BuildContext myContext;
  Future initLocalNotification(BuildContext context) async {
    myContext = context;
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitialize = DarwinInitializationSettings();

    const initSetting = InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onDidReceiveNotificationResponse: localNotificationTapForeground,
        onDidReceiveBackgroundNotificationResponse: null);
  }

  _notificationsRequestPermission() async {
    try {
      var settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _onForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      // MyConst.showSnackBar(message.data["title"], 5);
      ReceiveNotificationService.instance.showLocalNotification(message: message.data);
    });
  }

  saveTokenToCloudDb() async {
    String? token = await _messaging.getToken();
    print("token: $token ");

    User? _currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.doc("tokens/${_currentUser?.uid}").set({"token": token});

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      //User? _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.doc("tokens/${_currentUser?.uid}").set({"token": fcmToken});

      print("fcmToken guncellendi $fcmToken");
    }).onError((err) {
      print("fcmToken guncellenirken hata $err");
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();

  final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

  String? selectedNotificationPayload;

  /// A notification action which triggers a App navigation event
  String navigationActionId = 'id_3';

  bool _notificationsEnabled = false;

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      // setState(() {
      _notificationsEnabled = granted;
      //});
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      // final bool? granted = await androidImplementation?.requestPermission();
      // setState(() {
      //_notificationsEnabled = granted ?? false;
      // });
    }
  }

  Future showLocalNotification({
    id = 0,
    required Map<String, dynamic> message,
  }) async {
   // var userUrlPath = await _downloadAndSaveFile(message["photo-url"], "largeIcon");

  //  var person = Person(name: message["title"], key: "1", icon: BitmapFilePathAndroidIcon(userUrlPath));
   // var mesajStyle =
    //    MessagingStyleInformation(person, messages: [Message(message["message"], DateTime.now().toLocal(), person)]);

    AndroidNotificationDetails androidPlatformChannelSpecific = AndroidNotificationDetails("1234", "kanal adi",
       // styleInformation: mesajStyle,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("notification"),
        importance: Importance.max,
        priority: Priority.high);

    var not = NotificationDetails(android: androidPlatformChannelSpecific, iOS: const DarwinNotificationDetails());
    id++;
    //print(message);
    await flutterLocalNotificationsPlugin.show(
      id,
      message["title"],
      message["message"],
      not,
       payload: jsonEncode(message),
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      print("select payload: $payload");
      print("_configureSelectNotificationSubject- selectNotificationStream.stream.listen");

      Map<String,dynamic>? responsoNotification = await jsonDecode(payload ?? "");
      print("responsoNotification: $responsoNotification");

      if (responsoNotification?.isNotEmpty ?? false) {
        // ignore: use_build_context_synchronously
        Navigator.of(myContext, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ChatPage(
            fromUser: context.read<UserViewModel>().user,
            toUser: UserModel.IdAndPhoto(
                userId: responsoNotification!["senderUserId"],
                photoUrl: responsoNotification["photo-url"]),
          ),
        ));
      }

   
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream.listen((ReceivedNotification receivedNotification) async {
      print("_configureDidReceiveLocalNotificationSubject-  didReceiveLocalNotificationStream.stream.listen");
    });
  }

  void localNotificationTapForeground(NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // selectedNotificationPayload = notificationResponse.payload;
        selectNotificationStream.add(notificationResponse.payload);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          selectNotificationStream.add(notificationResponse.payload);
        }
        break;
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

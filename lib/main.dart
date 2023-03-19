import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_whatsapp_clone/firebase_options.dart';
import 'package:flutter_whatsapp_clone/service/release/firebase_notifications.dart';
import 'package:flutter_whatsapp_clone/view_model/all_user_view_model.dart';
import 'package:flutter_whatsapp_clone/view_model/chat_view_model.dart';
import 'package:provider/provider.dart';


import 'app/pages/landing_page/landing_page.dart';
import 'firebase_init.dart';
import 'get_it.dart';
import 'view_model/user_view_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInit();
  getItSetup();
  runApp(const MyApp());
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint("MyApp run");
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => AllUserViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ChatViewModel(),
          )
        ],
        child: MaterialApp(
            scaffoldMessengerKey: scaffoldKey,
            title: 'Flutter WhatsApp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.cyan,
            ),
            home: const LandingPage()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_whatsapp_clone/service/firebase_storege_service.dart';
import 'package:provider/provider.dart';

import 'app/sign_in/initialize_page.dart';
import 'app/sign_in/landing_page.dart';
import 'firebase_initialize.dart';
import 'get_it.dart';
import 'view_model/user_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

main() {
  getItSetup();
  runApp(const MyApp());
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) => ChangeNotifierProvider(
        create: (context) => UserViewModel(),
        builder: (context, child) => MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          title: 'Flutter WhatsApp',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.cyan),
          home: FutureBuilder(
            future: firebaseInitialize(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
               
                return const LandingPage();
              } else {
                return const InitializePage(
                  locatePage: "main init",
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

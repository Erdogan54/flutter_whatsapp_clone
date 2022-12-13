import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_whatsapp_clone/app/initialize_page.dart';
import 'package:flutter_whatsapp_clone/app/landing_page.dart';

import 'package:flutter_whatsapp_clone/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_initialize.dart';
import 'get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) => MaterialApp(
        title: 'Flutter WhatsApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.cyan),
        home: FutureBuilder(
          future: firebaseInitialzie(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ChangeNotifierProvider(
                create: (context) => UserViewModel(),
                child: LandingPage(),
              );
            } else {
              return const InitializePage();
            }
          },
        ),
      ),
    );
  }
}

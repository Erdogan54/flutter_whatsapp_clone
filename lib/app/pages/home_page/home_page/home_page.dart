import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whatsapp_clone/app/connectivity_check.dart';
import 'package:flutter_whatsapp_clone/service/notification/receive_notifications.dart';
import 'package:flutter_whatsapp_clone/view_model/all_user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../admob/app_open_ad_manager.dart';
import '../../../../admob/app_lifecycle_reactor.dart';
import '../../../../constants/my_const.dart';
import '../../../../get_it.dart';
import '../chatted_users_page/chatted_users_page.dart';
import 'custom_bottom_navi.dart';
import '../users_page.dart/users_page.dart';
import '../profile_page.dart/profil_page.dart';
import 'tab_items.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.users;

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: const UsersPage(),
      TabItem.mychats: const ChattedUserListPage(),
      TabItem.profil: const ProfilPage(),
    };
  }

  final _navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.mychats: GlobalKey<NavigatorState>(),
    TabItem.profil: GlobalKey<NavigatorState>(),
  };

  late AppLifecycleReactor _appLifecycleReactor;
  @override
  void initState() {
    ReceiveNotificationService.instance.initLocalNotification(context);
    ReceiveNotificationService.instance.saveTokenToCloudDb();

    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager)..listenToAppStateChanges();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("home page build");
    return WillPopScope(
      onWillPop: () async => !(await _navigatorKeys[_currentTab]?.currentState?.maybePop() ?? false),
      child: MyCustomBottomNavigation(
        //currentTab: _currentTab,
        allPages: allPages(),
        navigatorKeys: _navigatorKeys,
        onSelectedTab: (secilenTab) {
          if (_currentTab == secilenTab) {
            _navigatorKeys[_currentTab]?.currentState?.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}

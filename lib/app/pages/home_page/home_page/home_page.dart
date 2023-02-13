import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/app/pages/home_page/my_chats_page/my_chats_page.dart';
import 'custom_bottom_navi.dart';
import '../users_page.dart/kullanicilar_page.dart';
import '../profile_page.dart/profil_page.dart';
import 'tab_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.users;

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.users: const KullanicilarPage(),
      TabItem.mychats: const MyChatsPage(),
      TabItem.profil: const ProfilPage(),
    };
  }

  final _navigatorKeys = {
    TabItem.users: GlobalKey<NavigatorState>(),
    TabItem.mychats: GlobalKey<NavigatorState>(),
    TabItem.profil: GlobalKey<NavigatorState>(),
  };

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

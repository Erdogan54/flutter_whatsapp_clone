import 'package:flutter/material.dart';
import 'custom_bottom_navi.dart';
import '../kullanicilar_page.dart';
import '../profil_page.dart';
import 'tab_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.kullaniciler;

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.kullaniciler: const KullanicilarPage(),
      TabItem.profil: const ProfilPage(),
    };
  }

  final _navigatorKeys = {
    TabItem.kullaniciler: GlobalKey<NavigatorState>(),
    TabItem.profil: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    debugPrint("home page build");
    return WillPopScope(
      onWillPop: () async => !(await _navigatorKeys[_currentTab]?.currentState?.maybePop() ?? false),
      child: MyCustomBottomNavigation(
        //currentTab: _currentTab,
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
        allPages: allPages(),
      ),
    );
  }
}

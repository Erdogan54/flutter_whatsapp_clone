import 'package:flutter/material.dart';
import 'custom_bottom_navi.dart';
import 'kullanicilar_page.dart';
import 'profil_page.dart';
import 'tab_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullaniciler;

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Kullaniciler: const KullanicilarPage(),
      TabItem.Profil: const ProfilPage(),
    };
  }

  final _navigatorKeys = {
    TabItem.Kullaniciler: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {

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

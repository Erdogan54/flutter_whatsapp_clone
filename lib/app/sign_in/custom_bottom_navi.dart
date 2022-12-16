import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/tab_items.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, required this.currentTab, required this.onSelectedTab});

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        _navItemBarItem(TabItem.Kullaniciler),
        _navItemBarItem(TabItem.Profil),
      ]),
      tabBuilder: (BuildContext context, int index) {
        return Container();
      },
    );
  }

  BottomNavigationBarItem _navItemBarItem(TabItem tabItem) {
    final willCreateTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(icon: Icon(willCreateTab?.icon), label: willCreateTab?.title);
  }
}

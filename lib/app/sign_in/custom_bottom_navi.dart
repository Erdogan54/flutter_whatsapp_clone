import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'tab_items.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  MyCustomBottomNavigation({
    super.key,
    required this.onSelectedTab,
    this.currentTab,
    required this.allPages,
    required this.navigatorKeys,
  });

  TabItem? currentTab = TabItem.Kullaniciler;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> allPages;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
          items: [
            _navItemBarItem(TabItem.Kullaniciler),
            _navItemBarItem(TabItem.Profil),
          ],
          onTap: (value) {
            currentTab = TabItem.values[value];
            onSelectedTab(currentTab!);
          }),
      tabBuilder: (BuildContext context, int index) {
        final buildTab = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[buildTab],
          builder: (context) {
            return allPages[buildTab]!;
          },
        );
      },
    );
  }

  BottomNavigationBarItem _navItemBarItem(TabItem tabItem) {
    final willCreateTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(icon: Icon(willCreateTab?.icon), label: willCreateTab?.title);
  }
}

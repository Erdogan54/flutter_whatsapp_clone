import 'package:flutter/material.dart';

enum TabItem { kullaniciler, profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.kullaniciler: TabItemData("Kullanicilar", Icons.supervised_user_circle),
    TabItem.profil: TabItemData("Profil", Icons.person),
  };
}

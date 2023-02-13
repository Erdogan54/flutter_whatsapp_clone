import 'package:flutter/material.dart';

enum TabItem { users, mychats, profil }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.users: TabItemData("Kullanicilar", Icons.supervised_user_circle),
    TabItem.mychats: TabItemData("Konusmalarim", Icons.chat),
    TabItem.profil: TabItemData("Profil", Icons.person),
  };
}

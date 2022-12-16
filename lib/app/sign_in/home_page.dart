import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/custom_bottom_navi.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/sign_in_page.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/tab_items.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullaniciler;

  @override
  Widget build(BuildContext context) {
    UserViewModel userVm = Provider.of<UserViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Ana Sayfa"),
          actions: [
            IconButton(
                onPressed: () {
                  pressSignOut(context, userVm);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: CustomBottomNavigation(
          currentTab: _currentTab,
          onSelectedTab: (secilenTab) => debugPrint("secilen Tab ıtem $secilenTab") ,
        ));
  }

  void pressSignOut(context, userVm) async {
    final result = await userVm.signOut();
    if (result) {
      // Navigator.maybePop(context);
    }
  }
}

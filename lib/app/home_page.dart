import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../view_model/user_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Center(child: userVm.user != null ? Text("Hoş Geldiniz ${userVm.user!.userId}") : null),
    );
  }

  void pressSignOut(context, userVm) async {
    final result = await userVm.signOut();
    if (result) {
     // Navigator.maybePop(context);
    }
  }
}

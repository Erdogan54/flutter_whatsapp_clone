import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/app/home_page.dart';
import 'package:flutter_whatsapp_clone/app/initialize_page.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/sign_in_page.dart';


import 'package:flutter_whatsapp_clone/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userVM = Provider.of<UserViewModel>(context);

    if (_userVM.state == ViewState.Idle) {
      if (_userVM.user == null) {
        return SignInPage();
      } else {
        return HomePage();
      }
    } else {
      return const InitializePage();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_whatsapp_clone/app/connectivity_check.dart';
import 'package:provider/provider.dart';

import '../../../view_model/all_user_view_model.dart';
import '../../../view_model/user_view_model.dart';
import '../home_page/home_page/home_page.dart';
import '../initialize_page/initialize_page.dart';
import '../sign_in_page/sign_in_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    ConnectivityCheck.instance;
  }

  @override
  void dispose() {
    ConnectivityCheck.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("landing page build");
    final userViewModelWatch = Provider.of<UserViewModel>(context, listen: true);

    if (userViewModelWatch.state == ViewState.idle) {
      if (userViewModelWatch.user == null) {
        return const SignInPage();
      } else {
        return const HomePage();
      }
    } else {
      return const InitializePage(
        pageName: "landing init",
      );
    }
  }
}

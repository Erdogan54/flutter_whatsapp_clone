import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';
import 'sign_in/sign_in_page.dart';
import 'home_page/home_page/home_page.dart';
import 'initialize_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // late FirebaseAuth _auth;
  // late User? _user;

  @override
  void initState() {
    // _auth = FirebaseAuth.instance;
    // _user = _auth.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("landing page build");
    final viewModel = Provider.of<UserViewModel>(context, listen: true);

    //print("viewModel.user: ${viewModel.user}");

    if (viewModel.state == ViewState.idle) {
      if (viewModel.user == null) {
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

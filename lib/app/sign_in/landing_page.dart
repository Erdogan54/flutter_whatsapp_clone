import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_view_model.dart';
import 'home_page.dart';
import 'initialize_page.dart';
import 'sign_in_page.dart';

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
    final viewModel = Provider.of<UserViewModel>(context, listen: true);

    print("viewModel.user: ${viewModel.user}");

    if (viewModel.state == ViewState.Idle) {
      if (viewModel.user == null) {
        return SignInPage();
      } else {
        return const HomePage();
      }
    } else {
      return const InitializePage(
        locatePage: "landing init",
      );
    }
  }
}

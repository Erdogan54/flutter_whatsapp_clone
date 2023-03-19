import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widget/platform_duyarli_alert_dialog.dart';
import '../../../common_widget/busy_progressbar.dart';
import '../../error_exception.dart';
import '../home_page/home_page/home_page.dart';
import '../../../common_widget/social_login_button.dart';

import '../../../view_model/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';

enum FormType { register, login }

class EmailSifreKayitLogin extends StatefulWidget {
  const EmailSifreKayitLogin({Key? key}) : super(key: key);

  @override
  State<EmailSifreKayitLogin> createState() => _EmailSifreKayitLoginState();
}

class _EmailSifreKayitLoginState extends State<EmailSifreKayitLogin> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String? _buttonText, _linkText;

  UserModel? userModel;

  void _formSubmit() async {
    UserViewModel viewModel = Provider.of<UserViewModel>(context, listen: false);
    _formKey.currentState?.save();

    if (_formType == FormType.login) {
      try {
        debugPrint("signInWithEmail");
        userModel = await viewModel.signInWithEmail(email: _emailController.text, password: _passwordController.text);
      } on FirebaseException catch (e) {
        PlatformDuyarliAlertDialog(
          title: "Sign In Error",
          contents: MyErrorException.show(e.code),
          positiveActionLabel: "Ok",
          //negativeActionLabel: "Cancel",
        ).show(context);
      }
    } else {
      try {
        debugPrint("signUpEmailPass");
        userModel = await viewModel.signUpEmailPass(email: _emailController.text, password: _passwordController.text);
      } on FirebaseException catch (e) {
        //MyConst.showSnackBar(MyErrorException.show(e.code));

        PlatformDuyarliAlertDialog(
          title: "Sign Up Error",
          contents: MyErrorException.show(e.code),
          positiveActionLabel: "Ok",
          //negativeActionLabel: "Cancel",
        ).show(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType = _formType == FormType.login ? FormType.register : FormType.login;
    });
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.text = "erdgn54@gmail.com";
    _passwordController.text = "123456";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("email giriş page build");
    _changeText();
    UserViewModel viewModel = context.watch<UserViewModel>();
    if (viewModel.user != null) return const HomePage();
    // if (viewModel.user != null) Navigator.pop(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildPage(context, viewModel),
        BusyProgressBar(isBusy: viewModel.state == ViewState.busy),
      ],
    );
  }

  Scaffold _buildPage(BuildContext context, UserViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş/Kayıt"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    errorText: viewModel.emailErrorMessage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r)),
                    labelText: "Email",
                    hintText: "Enter email",
                    prefixIcon: const Icon(Icons.email)),
                onSaved: (value) {
                  value != null ? _emailController.text = value : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    errorText: viewModel.passwordErrorMessage,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r)),
                    labelText: "Password",
                    hintText: "Enter password",
                    prefixIcon: const Icon(Icons.password_sharp)),
                onSaved: (value) {
                  value != null ? _passwordController.text = value : null;
                },
              ),
            ),
            SocialLoginButton(
              onPressed: viewModel.state == ViewState.idle ? _formSubmit : null,
              buttonColor: Theme.of(context).primaryColor,
              buttonText: _buttonText ?? "",
            ),
            SizedBox(height: 50.h),
            TextButton(
              onPressed: _degistir,
              child: Text(_linkText ?? ""),
            )
          ],
        ),
      ),
    );
  }

  void _changeText() {
    _buttonText = _formType == FormType.login ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.login ? "Hesabınız yok mu? Kayıt Olun" : "Hesabınız var mı? Giriş Yap";
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_whatsapp_clone/app/sign_in/email_sifre_kayit_page.dart';
import 'package:flutter_whatsapp_clone/common_widget/social_login_button.dart';
import 'package:flutter_whatsapp_clone/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  _pressSignInAnonymous(context, userVm) async {
    await userVm.signInAnonymously();
    print("misafir girişi istek yapıldı");
  }

  _pressSignInWithGoole(context, userVm) async {
    await userVm.signInWithGoogle();
    print("google ile giriş isteği yapıldı");
  }

  _pressSignInWithFacebook(context, userVm) async {
    await userVm.signInWithFacebook();
    print("facebook ile girişi isteği yapıldı");
  }

  _emailVeSifreKayit(context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const EmailSifreKayitLogin(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userVm = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("WhatsApp Clone"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: EdgeInsets.all(30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            oturumAcText(),
            SizedBox(height: 100.h),
            googleGirisButton(context, userVm),
            facebookGirisButton(context, userVm),
            emailVeSifreGirisButton(context),
            anonymousGirisButton(context, userVm),
            Flexible(child: SizedBox(height: 300.sp))
          ],
        ),
      ),
    );
  }

  Widget googleGirisButton(context, userVm) {
    return SocialLoginButton(
        buttonIcon: Image.asset(
          "assets/images/google.png",
          fit: BoxFit.contain,
          height: 70.h,
        ),
        radius: 40.r,
        buttonColor: Colors.white,
        buttonText: "Google ile Oturum Aç",
        textColor: Colors.black,
        onPressed: () {
          _pressSignInWithGoole(context, userVm);
        });
  }

  Widget facebookGirisButton(context, userVm) {
    return SocialLoginButton(
      radius: 40.r,
      buttonIcon: Image.asset(
        "assets/images/facebook.png",
        fit: BoxFit.contain,
        height: 70.h,
      ),
      buttonColor: const Color(0xFF334D92),
      //  radius: 10,
      buttonText: "Facebook ile Oturum Aç",
      textColor: Colors.white,
      onPressed: () {
        _pressSignInWithFacebook(context, userVm);
      },
    );
  }

  Widget emailVeSifreGirisButton(context) {
    return SocialLoginButton(
      radius: 40.r,
      buttonIcon: Image.asset(
        "assets/images/gmail.png",
        fit: BoxFit.contain,
        height: 70.h,
      ),
      buttonColor: Colors.red,
      buttonText: "Email ve Şifre ile Giriş Yap",
      textColor: Colors.white,
      onPressed: () {
        _emailVeSifreKayit(context);
      },
    );
  }

  Widget anonymousGirisButton(context, userVm) {
    return SocialLoginButton(
      radius: 40.r,
      buttonIcon: Icon(Icons.supervised_user_circle, size: 70.w),
      buttonColor: Colors.teal,
      buttonText: "Misafir Olarak Giriş Yap",
      textColor: Colors.white,
      onPressed: () {
        _pressSignInAnonymous(context, userVm);
      },
    );
  }

  Widget oturumAcText() {
    return Text(
      "Oturum Açın",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80.sp),
    );
  }
}

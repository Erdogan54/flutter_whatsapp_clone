import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyErrorException {
  static String show(eCode) {
    switch (eCode) {
      case "email-already-in-use":
        return "Girdiğiniz mail adresi daha önce kullanılmıştır.Lütfen farklı bir mail adresi giriniz.";
      case "user-not-found":
        return "Böyle bir mail adresi bulunmamaktadır.";
      default:
        debugPrint(eCode.toString());
        return eCode;
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/my_const.dart';
import 'platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String title;
  final String contents;
  final String positiveActionLabel;
  final String? negativeActionLabel;

  const PlatformDuyarliAlertDialog(
      {super.key, required this.title, required this.contents, required this.positiveActionLabel, this.negativeActionLabel});

  Future<bool?> show(BuildContext context) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog<bool>(context: context, builder: (context) => this);
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.6),
      );
    }
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(contents),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(contents),
      actions: _buildActions(context),
    );
  }

  _buildActions(BuildContext context) {
    List<Widget> dialogActions = [];

    if (Platform.isIOS) {
      if (negativeActionLabel != null) {
        dialogActions.add(CupertinoDialogAction(
            child: Text(negativeActionLabel!),
            onPressed: () {
              Navigator.pop(context, false);
              MyConst.debugP("Cupertino Platform Cancel");
            }));
      }

      dialogActions.add(CupertinoDialogAction(
          child: Text(positiveActionLabel),
          onPressed: () {
            Navigator.pop(context, true);
            MyConst.debugP("Cupertino Platform OK");
          }));
    } else {
      if (negativeActionLabel != null) {
        dialogActions.add(TextButton(
            child: Text(negativeActionLabel!),
            onPressed: () {
              //dialogResult:
              (context) => false;
              Navigator.pop(context, false);
              MyConst.debugP("Other Platform Cancel");
            }));
      }
      dialogActions.add(TextButton(
          child: Text(positiveActionLabel),
          onPressed: () {
            //dialogResult:
            (context) => true;
            Navigator.pop(context, true);
            MyConst.debugP("Other Platform OK");
          }));
    }
    return dialogActions;
  }
}

import 'package:aqar/model/design.dart';
import 'package:aqar/view/signInFirstModalSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';

class AppController {
  void showAlertRichDialog(
      {BuildContext context,
      Widget title,
      Widget subTitle,
      int richAlertType,
      List<Widget> actions}) {
    showDialog(
        context: context,
        builder: (context) => RichAlertDialog(
              alertTitle: title,
              alertSubtitle: subTitle,
              alertType: richAlertType,
              actions: actions,
            ));
  }

  void showSignInFirstDialog(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (context) => SignInFirstModalSheet());
  }

  void showSnackBarOfContent(
      {GlobalKey<ScaffoldState> scaffold, Widget content}) {
    scaffold.currentState.showSnackBar(SnackBar(content: content));
  }

  void showLoadingProgress({BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  backgroundColor: appDesign.green,
                ),
              ),
            ));
  }
}

final appController = AppController();

import 'dart:io';
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/signIn.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  String title;
  GlobalKey<NavigatorState> nav;
  Splash({this.title, this.nav});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
  }

  bool _loading = true;
  DateTime _now;
  DateTime _nextTime;
  bool _stop = false;
  Future<bool> _onWillPop() async {
    if (_now == null) {
      if (mounted)
        setState(() {
          _now = DateTime.now();
        });
    } else if (mounted)
      setState(() {
        _nextTime = DateTime.now();
      });
    if (_nextTime != null && _now != null) {
      var dif = _nextTime.difference(_now);
      if (mounted)
        setState(() {
          _now = null;
          _nextTime = null;
        });
      if (dif.inMilliseconds < 1000) whenExitDialog(context);

      print(dif.inMilliseconds);
    }
    return Future.value(false);
  }


  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _sc,
            body: Stack(children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 100,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                           Image.asset(
                                'assets/images/logo.png',
                                width: MediaQuery.of(context).size.width / 2,
                                fit: BoxFit.fitWidth,
                           )
                         
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }
}

//////////////////////////////////////////////////////////


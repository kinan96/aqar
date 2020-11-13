import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class MyProperties extends StatefulWidget {
  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  @override
  void initState() {
    _getProfile();
    super.initState();
  }
  GlobalKey<ScaffoldState>_sc=GlobalKey<ScaffoldState>();
  _getProfile()async{
UserModel _user=await userController.showProfile(_sc, userController.userModel.id);
if(mounted)
setState(() {
  _profile=_user;
});
  }
UserModel _profile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sc,
        appBar: buildCustomAppBar(title: "My Properties"),
        body: Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
          child:Column(
                    children: _profile == null
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: LoadingBumpingLine.circle(),
                            ),
                          )
                        ]
                      : _profile.ads.length == 0
                          ? [
                              CustomText(
                                "No ads yet",
                                textAlign: TextAlign.center,
                                color: appDesign.hint,
                              )
                            ]
                          : List.generate(
                              _profile.ads.length,
                              (index) => CustomAdCard(
                                    adModel: _profile.ads[index],
                                  )),
                  ),
        ));
  }
}

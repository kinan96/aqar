import 'dart:io';

import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/editProfile.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animations/loading_animations.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  _getProfile() async {
    UserModel _user =
        await userController.showProfile(_sc, userController.userModel.id);
    if (mounted)
      setState(() {
        _profile = _user;
      });
  }

  UserModel _profile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sc,
      appBar: buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfilePicture(context,
                  iconData: Icons.settings,
                  imageURL: userController.userModel.image, onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => EditProfile()));
              }),
              SizedBox(
                height: 10,
              ),
              _profile == null
                  ? SizedBox()
                  : CustomText(
                      "${userController.userModel.firstName} ${userController.userModel.lastName}" ??
                          "",
                      size: 17,
                      textAlign: TextAlign.center,
                    ),
              SizedBox(
                height: 5,
              ),
              _profile == null
                  ? SizedBox()
                  : RattingProfile(
                      rate: userController.userModel.totalRating,
                    ),
              SizedBox(
                height: 9,
              ),
              _profile == null
                  ? SizedBox()
                  : CustomText(
                      userController.userModel.mobile ?? "",
                      textDirection: TextDirection.ltr,
                      color: appDesign.hint,
                      textAlign: TextAlign.center,
                    ),
              SizedBox(
                height: 5,
              ),
              TitleAndDiscripWidget(
                titleText: "My Properties",
                titleSize: 15,
                discripWidget: Column(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

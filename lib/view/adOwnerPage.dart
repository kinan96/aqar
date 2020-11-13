import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AdOwnerPage extends StatefulWidget {
  AdModel adModel;
  int id;
  AdOwnerPage({this.adModel, this.id});
  @override
  _AdOwnerPageState createState() => _AdOwnerPageState();
}

class _AdOwnerPageState extends State<AdOwnerPage> {
  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  _getProfile() async {
    UserModel _user =
        await userController.showProfile(_sc, widget.adModel.user.id);
    if (mounted)
      setState(() {
        _profile = _user;
      });
  }

  UserModel _profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(title: "Ad Owner"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      CustomAdOwnerCard(
                        adOwnerPage: true,
                        id: widget.id,
                        adModel: widget.adModel,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TitleAndDiscripWidget(
                        titleText: "Ads",
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
                              
                        )),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

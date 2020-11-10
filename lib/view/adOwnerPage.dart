import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:aqar/view/rateSheet.dart';
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
    // _getProfile();
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
                          children:[]
                              
                        )),
                      
                    ],
                  ),
                ),
              ),
            ),
            userController.userModel == null
                ? SizedBox()
                : userController.userModel != null &&
                        userController.userModel.id == widget.adModel.user.id
                    ? Positioned(
                        bottom: 0,
                        child: SizedBox(),
                      )
                    : Positioned(
                        bottom: 0,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width - 40,
                          child: RaisedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => RateSheet(
                                        id: widget.adModel.user.id,
                                      ));
                            },
                            child: Text("Rate"),
                          ),
                        ),
                      )
          ],
        ),
      ),
    );
  }
}

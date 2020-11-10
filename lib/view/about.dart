import 'package:aqar/controller/settingsController.dart';
import 'package:aqar/model/settingsModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  _launchSocialUrl(String uri) async {
    // Android
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {}
    }
  }
  _openWhatsapp(String mobile) async {
    String _mob;
    if (mobile[0] == "0" || mobile[0] == "+")
      _mob = mobile.substring(1);
    else
      _mob = mobile;
    // Android
    String uri = 'https://wa.me/$_mob';
    print(_mob);
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      // iOS
      String uri = 'https://wa.me/$_mob';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {}
    }
  }
  initState(){
    _getSettings();
    super.initState();
  }
  _getSettings()async{
    SettingsModel settingsModel =settingController.settingsModel??await settingController.getSettings();
if(mounted)
setState(() {
  _settingsModel=settingsModel;
});
  }
  SettingsModel _settingsModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(title: "عن التطبيق"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child:_settingsModel==null? Center(child: LoadingBouncingGrid.square(),) :  Column(
            children: [
              TitleAndDiscripWidget(
                titleText: "من نحن",
                titleSize: 25,
                discripSize: 18,
                heightSpace: 20,
                discripText:
                   _settingsModel.about??"",
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocialIcon(
                      imageSRC: "assets/images/f.png",
                      onPressed: () async {
                        await _launchSocialUrl(_settingsModel.facebook);
                      },
                    ),
                    SocialIcon(
                      imageSRC: "assets/images/t.png",
                      onPressed: () async {
                        await _launchSocialUrl(_settingsModel.twitter);
                      },
                    ),SocialIcon(
                      imageSRC: "assets/images/snap.png",
                      onPressed: () async {
                        await _launchSocialUrl(_settingsModel.snapchat);
                      },
                    ),SocialIcon(
                      imageSRC: "assets/images/whatsapp.png",
                      onPressed: () async {
                        await _openWhatsapp(_settingsModel.whatsapp);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  String imageSRC;
  Widget child;
  Function onPressed;
  SocialIcon({this.onPressed, this.child, this.imageSRC});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 36,
      width: 36,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: EdgeInsets.all(0),
        onPressed: onPressed ?? () {},
        child: child ?? Image.asset(imageSRC),
      ),
    );
  }
}

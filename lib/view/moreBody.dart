import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/settingsController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/about.dart';
import 'package:aqar/view/chat.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/favouriteAds.dart';
import 'package:aqar/view/pleaseSignUp.dart';
import 'package:aqar/view/splash.dart';
import 'package:aqar/view/termsAndCond.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:share/share.dart';

class MoreBody extends StatefulWidget {
  @override
  _MoreBodyState createState() => _MoreBodyState();
}

class _MoreBodyState extends State<MoreBody> {
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//       key: _sc,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
//           child: Column(
//             children: [
//               CustomMoreButton(
//                 imageSrc: "assets/images/chat.png",
//                 text: "المحادثات",
//                 onPressed: () {
//                                 if(userController.userModel==null)
//               showModalBottomSheet(context: context, builder:(context)=>PleaseSignUp());
//               else

//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => AllChats()));

//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/fav.png",
//                 text: "المفضلة",
//                 onPressed: () {
//                                 if(userController.userModel==null)
//               showModalBottomSheet(context: context, builder:(context)=>PleaseSignUp());
//               else

//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => FavouriteAds()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/commission.png",
//                 text: "حساب العمولة",
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => Commision()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/unallowed.png",
//                 text: "إعلانات ممنوعة",
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => BlockedAds()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/banking.png",
//                 text: "الحسابات البنكية",
//                 onPressed: () {
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(builder: (context) => Banks()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/about.png",
//                 text: "عن التطبيق",
//                 onPressed: () {
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(builder: (context) => About()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/contactus.png",
//                 text: "تواصل معنا",
//                 onPressed: () {
//                                 if(userController.userModel==null)
//               showModalBottomSheet(context: context, builder:(context)=>PleaseSignUp());
//               else

//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => ContactUs()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/terms.png",
//                 text: "الشروط والأحكام",
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => TermsAndCond()));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/share.png",
//                 text: "شارك التطبيق",
//                 onPressed: () async {
//                   if (settingController.settingsModel == null)
//                    { showLoadingProgressIndicator(context);
//                   await settingController.getSettings();
//                   Navigator.pop(context);}
//                   _sc.currentState.showSnackBar(SnackBar(
//                     backgroundColor: appDesign.bg,
//                       content: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         InkWell(
//                           onTap: ()async{
//                             await Share.share(settingController.settingsModel.android);
//                           },
//                           child: Container(
//                                  width: 60,
//                                 height: 60,
//                             child: ClipRRect(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                               child: Image.asset(
//                                 "assets/images/googleplay.png",
//                            fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                         ),
//                             InkWell(
//                           onTap: ()async{
//                             await Share.share(settingController.settingsModel.ios);
//                           },
//                           child: Container(
//                                  width: 60,
//                                 height: 60,
//                           child: ClipRRect(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                               child: Image.asset(
//                                 "assets/images/appstore.png",
//                          fit: BoxFit.fill,
//                               ),
//                           ),
//                         ),
//                            )
//                       ],
//                     ),
//                   )));
//                 },
//               ),
//               CustomMoreButton(
//                 imageSrc: "assets/images/logout.png",
//                 text:userController.userModel==null?"تسجيل الدخول": "تسجيل الخروج",
//                 onPressed: () async {
//                                 if(userController.userModel==null)
// Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Splash()));              else

//                   showMSG(context, "تنبيه", "هل تريد تسجيل الخروج من التطبيق ؟",
//                       richAlertType: RichAlertType.ERROR,
//                       actions: [
//                         Container(
//                           width: MediaQuery.of(context).size.width - 60,
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: RaisedButton(
//                                   child: Text("نعم"),
//                                   onPressed: () async {
//                                     await userController.logOut(context);
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Expanded(
//                                 child: RaisedButton(
//                                   child: Text("لا"),
//                                   color: appDesign.white,
//                                   onPressed: () async {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ]);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
    );
  }
}

class CustomMoreButton extends StatelessWidget {
  Function onPressed;
  String text;
  String imageSrc;
  CustomMoreButton({
    this.text,
    this.imageSrc,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: appDesign.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
              userController.userModel==null&&imageSrc=="assets/images/logout.png"? Transform.rotate(angle: 22/7,child:  Image.asset(
                  imageSrc,
                  width: 35,
                  height: 35,
                ),) :Image.asset(
                  imageSrc,
                  width: 35,
                  height: 35,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomText(text),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

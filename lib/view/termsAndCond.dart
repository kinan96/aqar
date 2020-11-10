import 'package:aqar/controller/settingsController.dart';
import 'package:aqar/model/settingsModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
class TermsAndCond extends StatefulWidget {
  @override
  _TermsAndCondState createState() => _TermsAndCondState();
}

class _TermsAndCondState extends State<TermsAndCond> {
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
      appBar:buildCustomAppBar(title: "Terms And Conditions",),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
          child:_settingsModel==null? Center(child: LoadingBouncingGrid.square(),) :  Column(children: [
          // SizedBox(height: 30,),
            // CustomText("ما هي سياسة الخصوصية",size: 25,),
            // SizedBox(height: 20,),
            CustomText(_settingsModel.licence??""
            ,fontWeight: FontWeight.w600,maxLines: 999999999,
            )
          ],),
        ),
      ),
    );
  }
}
import 'package:aqar/view/confirm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgetPasswordController{
  navigateToConfirm(BuildContext context){
Navigator.push(context,MaterialPageRoute(builder: (context)=>Confirm()));
  }
}
ForgetPasswordController forgetPasswordController=ForgetPasswordController();
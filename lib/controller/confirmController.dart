import 'package:aqar/view/newPassword.dart';
import 'package:flutter/material.dart';

class ConfirmController{
  navigateToNewPassword(BuildContext context){
Navigator.push(context,MaterialPageRoute(builder: (context)=>NewPassword()));
  }

}
ConfirmController confirmController=ConfirmController();
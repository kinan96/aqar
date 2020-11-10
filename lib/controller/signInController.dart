import 'package:aqar/view/forgetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInController{
navigateToForgetPAssword(BuildContext context){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgetPassword()));
}


}
SignInController signInController=SignInController();
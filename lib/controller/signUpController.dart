import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/termsAndCond.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SignUpController{

  navigateToTermsAndCond(BuildContext context){
Navigator.push(context,MaterialPageRoute(builder: (context)=>TermsAndCond()));
  }
 List<DropdownMenuItem> builDropDownItem(Map<int, String> items, int value) {
    List<DropdownMenuItem> _itemsList = [];
    for (int i = 0; i < items.length; i++) {
      _itemsList.add(DropdownMenuItem(
          value: items.keys.toList()[i],
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              items.values.toList()[i],
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  fontWeight: items.keys.toList()[i] == value && value > 0
                      ? FontWeight.bold
                      : FontWeight.w600,
                  fontSize: 16,
                  color: items.keys.toList()[i] == 0
                      ? Colors.grey.withOpacity(0.8)
                      : appDesign.black),
            ),
          )));
    }
    return _itemsList;
  }







}
SignUpController signUpController=SignUpController();
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';

class ContactController{
  Map<int,String> contactTypes={0:"تحميل أنواع التواصل ..."};
  Future< Map<int,String>> getContactTypes() async {
     Map<int,String> _contacts = {0:"اختر نوع التواصل"};
    // showLoadingContext(context);
    try {
      Response response = await Dio().get("$baseUrl/reason"    ,      options: Options(headers: {
            "apiToken": "${userController.userModel.apiToken}"
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),);

      if (response.data['status'] == 200) {
        // Navigator.pop(context);
print(response.data);
        for (Map<String, dynamic> type in response.data['data'])
          _contacts[type['id']]=type['name'];
         contactController.contactTypes=_contacts;
          return _contacts;
      }
 else if (response.data['status'] == 400) {
              // Navigator.pop(context);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }      
    } catch (e) {}
    return _contacts;
  }

  Future sendContact(BuildContext context,int typeId, String message) async {
    progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/contact",
          data: {
            "reason_id":typeId.toString(),
            "message":message
          },
          options: Options(headers: {
            "apiToken": "${userController.userModel.apiToken}"
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        print(response.data);
Navigator.pop(context);
          showMSG(context, "رسالة إدارية", "تم إرسال رسالتك بنجاح",
              richAlertType: RichAlertType.SUCCESS);
        
      } else if (response.data['status'] == 400) {      Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['message'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {}
  }

}
ContactController contactController =ContactController();
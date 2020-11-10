import 'dart:convert';
import 'dart:io';

import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/chatPage.dart';
import 'package:aqar/view/signIn.dart';
import 'package:aqar/view/signUp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'chatController.dart';

class SplashController{
  void navigateToSignIn(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>SignIn()));
  }
  void navigateToSigUp(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));
  }
  void skipToHome(BuildContext context){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
  }






}
final splashController=SplashController();
class FCMNotificationModel {
  NotificationModel notificationModel;
  NotificationBodyModel notificationBodyModel;
  FCMNotificationModel({this.notificationBodyModel, this.notificationModel
  });
  factory FCMNotificationModel.fromJson(Map<dynamic, dynamic> message) {
    return FCMNotificationModel(
       notificationModel:message['notification']!=null? NotificationModel.fromJson(message['notification']):null,
        notificationBodyModel:message['data']!=null?NotificationBodyModel.fromJson(message['data']):null);
  }
}
class NotificationBodyModel {
  String status;
  int id;
  String title;
  String body;
  ChatMessageModel messageModel;
  AdModel adModel;
  NotificationBodyModel(
      {this.title,this.id, this.body,this.messageModel, this.status, this.adModel});
  factory NotificationBodyModel.fromJson(
      Map<String, dynamic> notificationBody) {
    return NotificationBodyModel(
        title: notificationBody['title'].toString(),
        id:int.tryParse(notificationBody['id'].toString()),
        status:notificationBody['status'],
        messageModel:notificationBody['chat']!=null?ChatMessageModel.fromJson(notificationBody['chat'],0):null ,
        body: notificationBody['body'].toString(),
        adModel:notificationBody['ad']!=null? AdModel.fromJson(notificationBody['ad']):null);
          }
}

// Future<void> _showNotification(Map<String, dynamic> notifi) async {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final android = AndroidNotificationDetails(
//       'channel id', 'channel name', 'channel description',
//       playSound: true,
//       showWhen: false,
//       enableVibration: true,
//       priority: Priority.High,
//       importance: Importance.Max);
//   final iOS = IOSNotificationDetails();
//   final platform = NotificationDetails(android, iOS);
//   final json = jsonEncode(notifi);
//   // final isSuccess = downloadStatus['isSuccess'];
//   if (notifi != null && notifi['data'] != null)
//     await flutterLocalNotificationsPlugin.show(
//         //  notifi['data'].length>0?    notifi['data']['order']['id']:
//         int.tryParse(notifi['data']["id"].toString()) ?? 0, // notification id
//         //  notifi['data'].length>0?    notifi['data']['title']:
//         notifi['data']['status'] == "chat"
//             ? "${notifi['data']['message']['sender']['name']}  #${notifi['data']["id"]}"
//             : "${notifi['data']["title"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["order"]['provider']['name']:notifi['data']["order"]['user']['name']}
//         // notifi['data'].length>0?   notifi['data']['body']:
//         notifi['data']['status'] == "chat"
//             ? notifi['data']['message']['msg']
//             : "${notifi['data']["body"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["order"]['provider']['name']:notifi['data']["order"]['user']['name']}
//         platform,
//         payload: json);
// }

import 'dart:convert';
import 'dart:io';

import 'package:aqar/controller/appController.dart';
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/chatController.dart';
import 'package:aqar/controller/notificationController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/controller/splashController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/confirm.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/signIn.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loading_animations/loading_animations.dart';

import 'chatPage.dart';

class Splash extends StatefulWidget {
  String title;
  GlobalKey<NavigatorState> nav;
  Splash({this.title, this.nav});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    chatController.changeopenedChatId(0101010101);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (json) async {
      _onSelectNotification(widget.nav, json, flutterLocalNotificationsPlugin);
    });

    super.initState();
  }

  bool _loading = true;
  DateTime _now;
  DateTime _nextTime;
bool _stop=false;
  Future<bool> _onWillPop() async {
    if (_now == null) {
      if (mounted)
        setState(() {
          _now = DateTime.now();
        });
    } else if (mounted)
      setState(() {
        _nextTime = DateTime.now();
      });
    if (_nextTime != null && _now != null) {
      var dif = _nextTime.difference(_now);
      if (mounted)
        setState(() {
          _now = null;
          _nextTime = null;
        });
      if (dif.inMilliseconds < 1000) whenExitDialog(context);

      print(dif.inMilliseconds);
    }
    return Future.value(false);
  }

  chooseScreen(GlobalKey<NavigatorState> nav, bool isOnline,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      {Function onNotifi}) async {

      // if(userController.userModel!=null||notificationController.fromBackGround!=null){}
      // else{  
    List<String> userData;
    if (isOnline) userData = await getSharedListOfStringOfKey("savedUser");
    await _fcm_listener(_firebaseMessaging, flutterLocalNotificationsPlugin);
    if (userData != null && isOnline)
      await userController.signIn(nav.currentContext, userData[0], userData[1],
          open: true, onNotifi: onNotifi);
    else
    Navigator.pushReplacement(nav.currentContext, MaterialPageRoute(builder: (context)=>SignIn()));
//       setState(() {
//         _loading = false;
//       });
// if(mounted)
//       setState(() {
//         _stop=true;
//       });
      // }
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _sc,
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 100,
                      ),
                     
                      SizedBox(
                        height: 100,
                      ),
                      _loading
                          ? ConnectivityWidget(
                              offlineBanner: OflineConnectWidget(),
                              builder: (context, isOnline) => !isOnline
                                  ? SizedBox()
                                  : widget.nav == null
                                      ? SizedBox()
                                      : FutureBuilder(
                                          future: chooseScreen(
                                              widget.nav,
                                              isOnline,
                                              flutterLocalNotificationsPlugin),
                                          builder: (ctx, snapshot) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.fitWidth,
                      ),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                // LoadingBouncingLine.circle(
                                                //   backgroundColor:
                                                //       Colors.blue,
                                                //   size: 20,
                                                // ),
                                              ],
                                            );
                                          }),
                            )
                          : SizedBox(),
                      // Column(
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       width: MediaQuery.of(context).size.width - 40,
                      //       child: RaisedButton(
                      //         onPressed: _loading && widget.nav != null
                      //             ? () {}
                      //             : () {
                      //                 splashController
                      //                     .navigateToSignIn(context);
                      //               },
                      //         child: Text("تسجيل دخول"),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       width: MediaQuery.of(context).size.width - 40,
                      //       child: RaisedButton(
                      //         onPressed: _loading && widget.nav != null
                      //             ? () {}
                      //             : () {
                      //                 splashController.navigateToSigUp(context);
                      //               },
                      //         child: Text("اشترك الآن"),
                      //       ),
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.symmetric(vertical: 10),
                      //       width: MediaQuery.of(context).size.width - 40,
                      //       child: RaisedButton(
                      //         color: appDesign.bg,
                      //         onPressed: _loading && widget.nav != null
                      //             ? () {}
                      //             : () {
                      //                 splashController.skipToHome(context);
                      //               },
                      //         child: Text("تخطي"),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////
onNotifi(NavigatorState navigatorState, String json) async {
  final _noti = await jsonDecode(json);
  FCMNotificationModel notificationModel = FCMNotificationModel.fromJson(_noti);
  if (notificationModel != null &&
      notificationModel.notificationBodyModel != null) {
    if (
        notificationModel.notificationBodyModel.status == "chat"&&notificationModel.notificationBodyModel.messageModel!=null)
      navigatorState.push(MaterialPageRoute(
          builder: (context) => (ChatPage(
                chatModel: ChatModel(
                    adModel:
                        notificationModel.notificationBodyModel.messageModel.ad,
                    room: notificationModel
                        .notificationBodyModel.messageModel.room,
                    receiverId: notificationModel
                        .notificationBodyModel.messageModel.receiver.id,
                    title: notificationModel
                        .notificationBodyModel.messageModel.receiver.firstName,
                    image: notificationModel
                        .notificationBodyModel.messageModel.receiver.image),
              ))));
    else if (notificationModel.notificationBodyModel.adModel != null &&
        notificationModel.notificationBodyModel.status == "comment")
      navigatorState.push(MaterialPageRoute(
          builder: (context) => AdPage(
                adModel: notificationModel.notificationBodyModel.adModel,
              )));
    else if (userController.userModel != null) {
      if (userController.userModel.activationCode != null &&
          userController.userModel.activationCode.toString().length == 4) {
        print(userController.userModel.activationCode);
        navigatorState.pushReplacement(
            MaterialPageRoute(builder: (context) => Confirm()));
      } else {
        MaterialPageRoute(builder: (context) => Home());
      }
    }
  }
}

chooseScreen(GlobalKey<NavigatorState> nav, bool isOnline,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    {Function onNotifi}) async {
  List<String> userData;
  if (isOnline) userData = await getSharedListOfStringOfKey("savedUser");
  if (userData != null && isOnline)
    await userController.signIn(nav.currentContext, userData[0], userData[1],
        open: true, onNotifi: onNotifi);
     else
         Navigator.pushReplacement(nav.currentContext, MaterialPageRoute(builder: (context)=>SignIn()));

}

Future<void> _onSelectNotification(
    GlobalKey<NavigatorState> navigatorState,
    String json,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  if (userController.userModel == null) {
    await chooseScreen(navigatorState, true, flutterLocalNotificationsPlugin,
        onNotifi: onNotifi(navigatorState.currentState, json));
  } else
    await onNotifi(navigatorState.currentState, json);
}

Future<void> _showNotification(Map<String, dynamic> notifi,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  final android = AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      playSound: true,
      showWhen: false,
      enableVibration: true,
      priority: Priority.High,
      importance: Importance.Max);
  final iOS = IOSNotificationDetails();
  final platform = NotificationDetails(android, iOS);
  final json = jsonEncode(notifi);
  // final isSuccess = downloadStatus['isSuccess'];
  if (notifi != null && notifi['data'] != null)
    await flutterLocalNotificationsPlugin.show(
        //  notifi['data'].length>0?    notifi['data']['adModel']['id']:
        int.tryParse(notifi['data']["id"].toString()) ?? 0, // notification id
        //  notifi['data'].length>0?    notifi['data']['title']:
        notifi['data']['status'] == "chat"
            ? "${notifi['data']['chat']['sender']['firstName']}"
            : "${notifi['data']["title"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["adModel"]['provider']['name']:notifi['data']["adModel"]['user']['name']}
        // notifi['data'].length>0?   notifi['data']['body']:
        notifi['data']['status'] == "chat"
            ? notifi['data']['chat']['message']
            : "${notifi['data']["body"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["adModel"]['provider']['name']:notifi['data']["adModel"]['user']['name']}
        platform,
        payload: json);
}

Future _fcm_listener(FirebaseMessaging _firebaseMessaging,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  if (Platform.isIOS) ios_permission(_firebaseMessaging);
  _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async =>
          onPushNotification(message, flutterLocalNotificationsPlugin),
      onLaunch: (Map<String, dynamic> message) async =>
          onPushNotification(message, flutterLocalNotificationsPlugin),
      onResume: (Map<String, dynamic> message) async =>
          onPushNotification(message, flutterLocalNotificationsPlugin),
      onBackgroundMessage: Platform.isIOS ? null : onBackGroundNotification);
  await _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
    deviceInfo.changedeviceId(token);
    deviceInfo.changeplateform(Platform.operatingSystem);
    print("Push Messaging token: $token/////${Platform.operatingSystem}");
  });
  _firebaseMessaging.subscribeToTopic("matchscore");
}

void ios_permission(FirebaseMessaging _firebaseMessaging) {
  ///
  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: false, alert: true, provisional: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    print("Settings registered: $settings");
  });

  ///
}

Future<dynamic> onPushNotification(Map<String, dynamic> message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  print("--- $message");

  FCMNotificationModel fcmNotificationModel;
  Map<String, dynamic> _finalMessage;
  try {
    if (message.containsKey('data')) {
      final notifi = json.encode(message);
      final notification = await json.decode(notifi);
      if (notification['data'].containsKey('ad'))
        notification['data']['ad'] =
            await json.decode(notification['data']['ad']);
      if (notification['data'].containsKey('chat'))
        notification['data']['chat'] =
            await json.decode(notification['data']['chat']);
      _finalMessage = notification;
      print(notification);
      fcmNotificationModel = FCMNotificationModel.fromJson(notification);
      print("-----(((${fcmNotificationModel.notificationBodyModel})))----");
    } else if (message.containsKey('notification')) {}
  } catch (e) {
    print("error: $e");
  } finally {
          notificationController.changefromBackGround(null);
    if (fcmNotificationModel != null &&        fcmNotificationModel.notificationBodyModel != null &&
 fcmNotificationModel.notificationBodyModel.status == "chat"&&
        fcmNotificationModel.notificationBodyModel.messageModel != null &&
        chatController.openedChatId ==
            fcmNotificationModel.notificationBodyModel.messageModel.room
       ) {
      List<Widget> _currentChat = chatController.openedChatMessagesWidgets;
      print("object");
      _currentChat.add(CustomChatMessageWidget(
          loaded: true,
          chatMessageModel:
              fcmNotificationModel.notificationBodyModel.messageModel));
      chatController.changeopenedChatMessagesWidgets(_currentChat);
      await Future.delayed(Duration(milliseconds: 100));
      chatController.chatRefreshController.position.jumpTo(
          chatController.chatRefreshController.position.maxScrollExtent);
    } else {
      await _showNotification(_finalMessage, flutterLocalNotificationsPlugin);
    }
  }
}

Future<dynamic> onBackGroundNotification(Map<String, dynamic> message) async {
  print(message);
  FCMNotificationModel fcmNotificationModel;
  Map<String, dynamic> _finalMessage;
  try {
    if (message.containsKey('data')) {
      final notifi = json.encode(message);
      final notification = await json.decode(notifi);
      if (notification['data'].containsKey('ad'))
        notification['data']['ad'] =
            await json.decode(notification['data']['ad']);
      if (notification['data'].containsKey('chat'))
        notification['data']['chat'] =
            await json.decode(notification['data']['chat']);
      _finalMessage = notification;
      print(
          "(((((((((((((((((((((((((((((($notification))))))))))))))))))))))))))))))");
      fcmNotificationModel = FCMNotificationModel.fromJson(notification);
      print("-----(((${fcmNotificationModel.notificationBodyModel})))----");
    } else if (message.containsKey('notification')) {}
  } catch (e) {
    print("error: $e");
  } finally {
    if (fcmNotificationModel != null &&        fcmNotificationModel.notificationBodyModel != null &&
 fcmNotificationModel.notificationBodyModel.status == "chat"&&
        fcmNotificationModel.notificationBodyModel.messageModel != null &&
        chatController.openedChatId ==
            fcmNotificationModel.notificationBodyModel.messageModel.room) {
      List<Widget> _currentChat = chatController.openedChatMessagesWidgets;
      print("object");
      _currentChat.add(CustomChatMessageWidget(
          loaded: true,
          chatMessageModel:
              fcmNotificationModel.notificationBodyModel.messageModel));
      chatController.changeopenedChatMessagesWidgets(_currentChat);
      await Future.delayed(Duration(milliseconds: 100));
      chatController.chatRefreshController.position.jumpTo(
          chatController.chatRefreshController.position.maxScrollExtent);
    } else {
      print("kkk");
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      final android = AndroidNotificationDetails(
          'channel id', 'channel name', 'channel description',
          playSound: true,
          enableVibration: true,
          priority: Priority.High,
          importance: Importance.Max);
      final iOS = IOSNotificationDetails();
      final platform = NotificationDetails(android, iOS);
      final json = jsonEncode(_finalMessage);
      // final isSuccess = downloadStatus['isSuccess'];
      if (_finalMessage != null && _finalMessage['data'] != null){
              notificationController.changefromBackGround(true);
        await flutterLocalNotificationsPlugin.show(
            //  notifi['data'].length>0?    notifi['data']['adModel']['id']:
            int.tryParse(_finalMessage['data']["id"].toString()) ??
                0, // notification id
            //  notifi['data'].length>0?    notifi['data']['title']:
            _finalMessage['data']['status'] == "chat"
                ? "${_finalMessage['data']['chat']['sender']['firstName']}"
                : "${_finalMessage['data']["title"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["adModel"]['provider']['name']:notifi['data']["adModel"]['user']['name']}
            // notifi['data'].length>0?   notifi['data']['body']:
            _finalMessage['data']['status'] == "chat"
                ? _finalMessage['data']['chat']['message']
                : "${_finalMessage['data']["body"].toString()} ", //بواسطة ${userController.userModel.type.id==1? notifi['data']["adModel"]['provider']['name']:notifi['data']["adModel"]['user']['name']}
            platform,
            payload: json);
            }
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/chatController.dart';
import 'package:aqar/controller/notificationController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/main.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/chatPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/signUp.dart';
import 'package:aqar/view/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SignIn extends StatefulWidget {
  GlobalKey<NavigatorState> nav;
  SignIn({this.nav});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  initState() {
    chatController.changeopenedChatId(0101010101);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (json) async {
      _onSelectNotification(widget.nav, json, flutterLocalNotificationsPlugin);
    });

    _chooseScreen();
    super.initState();
  }

  _chooseScreen() async {
    await _fcm_listener(_firebaseMessaging, flutterLocalNotificationsPlugin);
  }

  String _email;
  String _password;
  bool _passVisible = false;
  DateTime _now;
  DateTime _nextTime;
  bool _stop = false;
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WillPopScope(
        onWillPop: () {
          _onWillPop();
          return Future.value(false);
        },
        child: Scaffold(
          // appBar: buildCustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    "Aqar Application",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _email = v;
                              });
                            },
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child:
                                  Icon(Icons.person, color: Colors.lightBlue),
                            ),
                            lable: "Email",
                            onValidate: emailValidate,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _password = v;
                              });
                            },
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phonelink_lock,
                                  color: Colors.lightBlue),
                            ),
                            isPassword: true,
                            lable: "Password",
                            onValidate: passwordValidate,
                          )
                        ],
                      )),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // CustomInkWell(
                  //   text: "نسيت كلمة المرور؟",
                  //   onTap: () =>
                  //       signInController.navigateToForgetPAssword(context),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();
                              await userController.signIn(
                                  context, _email, _password);
                            },
                            child: Text("Login"),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Text("Register"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _onSelectNotification(
    GlobalKey<NavigatorState> navigatorState,
    String json,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  if (userController.userModel == null) {
  } else
    await onNotifi(navigatorState.currentState, json);
}

onNotifi(NavigatorState navigatorState, String json) async {
  final _noti = await jsonDecode(json);
  FCMNotificationModel notificationModel = FCMNotificationModel.fromJson(_noti);
  if (notificationModel != null &&
      notificationModel.notificationBodyModel != null) {
    if (notificationModel.notificationBodyModel.status == "chat" &&
        notificationModel.notificationBodyModel.messageModel != null)
      navigatorState.push(MaterialPageRoute(
          builder: (context) => (ChatPage(
                chatModel: ChatModel(
                    adModel:
                        notificationModel.notificationBodyModel.messageModel.ad,
                    room: notificationModel
                        .notificationBodyModel.messageModel.room,
                    receiverId: notificationModel
                        .notificationBodyModel.messageModel.sender.id,
                    title: notificationModel.notificationBodyModel.messageModel
                            .sender.firstName +
                        " " +
                        notificationModel.notificationBodyModel.messageModel
                            .sender.lastName,
                    image: notificationModel
                        .notificationBodyModel.messageModel.sender.image),
              ))));
    else if (notificationModel.notificationBodyModel.adModel != null &&
        notificationModel.notificationBodyModel.status == "comment")
      navigatorState.push(MaterialPageRoute(
          builder: (context) => AdPage(
                adModel: notificationModel.notificationBodyModel.adModel,
              )));
    else if (userController.userModel != null) {
      MaterialPageRoute(builder: (context) => Home());
    }
  }
}

Future<void> _showNotification(Map<String, dynamic> notifi,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  print("$notifi");
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
            ? "${notifi['data']['chat']['sender']['first_name']} ${notifi['data']['chat']['sender']['last_name']}"
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
  await _firebaseMessaging.getToken().then((String token) async {
    assert(token != null);
    deviceInfo.changedeviceId(token);
    deviceInfo.changeplateform(Platform.operatingSystem);
    print("Push Messaging token: $token/////${Platform.operatingSystem}");
    List<String> userData;
    userData = await getSharedListOfStringOfKey("savedUser");
    if (userData != null) {
      await userController.signIn(
        nav.currentContext,
        userData[0],
        userData[1],
      );
    }
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
    if (fcmNotificationModel != null &&
        fcmNotificationModel.notificationBodyModel != null &&
        fcmNotificationModel.notificationBodyModel.status == "chat" &&
        fcmNotificationModel.notificationBodyModel.messageModel != null &&
        fcmNotificationModel.notificationBodyModel.messageModel.receiver.id ==
            userController.userModel.id &&
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
      if (fcmNotificationModel != null &&
          fcmNotificationModel.notificationBodyModel != null &&
          fcmNotificationModel.notificationBodyModel.status == "chat"&&
           fcmNotificationModel.notificationBodyModel.messageModel.receiver.id ==
            userController.userModel.id&&(
              chatController.openedChatId==null||
               chatController.openedChatId !=
            fcmNotificationModel.notificationBodyModel.messageModel.room
            )
          )
        await _showNotification(_finalMessage, flutterLocalNotificationsPlugin);
    }
  }
}

Future<dynamic> onBackGroundNotification(Map<String, dynamic> message) async {
  print(message);
  notificationController.changefromBackGround(true);
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
    if (fcmNotificationModel != null &&
        fcmNotificationModel.notificationBodyModel != null &&
        fcmNotificationModel.notificationBodyModel.status == "chat" &&
        fcmNotificationModel.notificationBodyModel.messageModel != null &&
        fcmNotificationModel.notificationBodyModel.messageModel.receiver.id ==
            userController.userModel.id &&
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
    } else if (fcmNotificationModel != null &&
        fcmNotificationModel.notificationBodyModel != null &&
        fcmNotificationModel.notificationBodyModel.status == "chat"&&
           fcmNotificationModel.notificationBodyModel.messageModel.receiver.id ==
            userController.userModel.id&&(
              chatController.openedChatId==null||
               chatController.openedChatId !=
            fcmNotificationModel.notificationBodyModel.messageModel.room
            )
        ) {
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
      if (_finalMessage != null && _finalMessage['data'] != null) {
        notificationController.changefromBackGround(true);
        await flutterLocalNotificationsPlugin.show(
            //  notifi['data'].length>0?    notifi['data']['adModel']['id']:
            int.tryParse(_finalMessage['data']["id"].toString()) ??
                0, // notification id
            //  notifi['data'].length>0?    notifi['data']['title']:
            _finalMessage['data']['status'] == "chat"
                ? "${_finalMessage['data']['chat']['sender']['first_name']} ${_finalMessage['data']['chat']['sender']['last_name']}"
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

class FCMNotificationModel {
  NotificationModel notificationModel;
  NotificationBodyModel notificationBodyModel;
  FCMNotificationModel({this.notificationBodyModel, this.notificationModel});
  factory FCMNotificationModel.fromJson(Map<dynamic, dynamic> message) {
    return FCMNotificationModel(
        notificationModel: message['notification'] != null
            ? NotificationModel.fromJson(message['notification'])
            : null,
        notificationBodyModel: message['data'] != null
            ? NotificationBodyModel.fromJson(message['data'])
            : null);
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
      {this.title,
      this.id,
      this.body,
      this.messageModel,
      this.status,
      this.adModel});
  factory NotificationBodyModel.fromJson(
      Map<String, dynamic> notificationBody) {
    return NotificationBodyModel(
        title: notificationBody['title'].toString(),
        id: int.tryParse(notificationBody['id'].toString()),
        status: notificationBody['status'],
        messageModel: notificationBody['chat'] != null
            ? ChatMessageModel.fromJson(notificationBody['chat'], 0)
            : null,
        body: notificationBody['body'].toString(),
        adModel: notificationBody['ad'] != null
            ? AdModel.fromJson(notificationBody['ad'])
            : null);
  }
}

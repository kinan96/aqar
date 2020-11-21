import 'dart:convert';
import 'dart:io';
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/chatController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adOwnerPage.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/editProfile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mime/mime.dart';
import 'package:permission/permission.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'chat.dart';

class ChatPage extends StatefulWidget {
  ChatModel chatModel;
  String from;
  ChatPage({this.chatModel, this.from});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  initState() {
    print(deviceInfo.deviceId);
    print(userController.userModel.apiToken);
    print(chatController.openedChatId);
    _refreshController = RefreshController();
    chatController.changechatRefreshController(_refreshController);
    chatController.changeopenedChatMessagesWidgets(null);
    chatController.changeopenedChatId(widget.chatModel.room);
    _loadMessages();
    super.initState();
  }

  RefreshController _refreshController;
  int _count = 0;
  _loadMessages() async {
    List _chat = await chatController.getChatMessages(widget.chatModel.room);
    if (mounted)
      setState(() {
        _count = _chat[0];

        _chatMessages = List.generate(
                _chat[1].length,
                (index) => CustomChatMessageWidget(
                      loaded: true,
                      chatMessageModel: _chat[1][index],
                    )) ??
            [];
      });
    chatController.changeopenedChatMessagesWidgets(_chatMessages);
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  bool godown = false;
  bool start = true;
  _loadMoreMessages() async {
    if (_chatMessages.length < _count) {
      List _chat = await chatController.getChatMessages(widget.chatModel.room,
          skip: _chatMessages.length);
      if (mounted)
        setState(() {
          _count = _chat[0];
          List<Widget> _oldMessages = _chatMessages;
          _chatMessages = List.generate(
                  _chat[1].length,
                  (index) => CustomChatMessageWidget(
                        loaded: true,
                        chatMessageModel: _chat[1][index],
                      )) ??
              [];
          _chatMessages.addAll(_oldMessages);
        });
      chatController.changeopenedChatMessagesWidgets(_chatMessages);
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      chatController.chatRefreshController.refreshCompleted();
    }
  }

  List<Widget> _chatMessages = [
    Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: LoadingBouncingLine.circle(),
      ),
    )
  ];
  TextEditingController _message = TextEditingController();
  _sendMessage() async {
    String text = _message.text;
    if (mounted && text.isNotEmpty) {
      if (mounted)
        setState(() {
          chatController.chatRefreshController.position.jumpTo(
              chatController.chatRefreshController.position.maxScrollExtent);
          _message.text = "";
          _chatMessages.add(CustomChatMessageWidget(
            chatMessageModel: ChatMessageModel(
                ad: widget.chatModel.adModel,
                receiver: UserModel(id: widget.chatModel.receiverId),
                room: widget.chatModel.room,
                id: widget.chatModel.room,
                message: text,
                sender: userController.userModel,
                time:
                    "${DateTime.now().hour > 12 ? DateTime.now().hour - 12 : DateTime.now().hour} : ${DateTime.now().minute.toString()} : ${DateTime.now().second.toString()} ${DateTime.now().hour >= 12 ? "PM" : "AM"}"),
          ));
        });
      await Future.delayed(Duration(milliseconds: 100));
      if (mounted)
        setState(() {
          chatController.chatRefreshController.position.jumpTo(
              chatController.chatRefreshController.position.maxScrollExtent);
        });
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        chatController.changeopenedChatId(null);
        chatController.changeopenedChatMessagesWidgets(null);
        widget.from == "owner"
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AdOwnerPage(
                          adModel: widget.chatModel.adModel,
                        )))
            : widget.from == "ad"
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdPage(
                              adModel: widget.chatModel.adModel,
                            )))
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              index: 3,
                            )));

        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  // appBar
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 16,
                      right: 18,
                      bottom: 15),
                  child: ChatAppBar(
                    from: widget.from,
                    chatModel: widget.chatModel,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: StreamBuilder<RefreshController>(
                      stream: chatController.chatRefreshControllerStream,
                      builder: (context, controler) {
                        chatController
                            .changechatRefreshController(_refreshController);
                        return SmartRefresher(
                          header: CustomHeader(
                              builder: (context, state) => Center(
                                    child: LoadingBouncingLine.circle(),
                                  )),
                          controller: controler.hasData
                              ? controler.data
                              : _refreshController,
                          onRefresh: () async {
                            if (start && _chatMessages.length < _count) {
                              if (mounted)
                                setState(() {
                                  start = false;
                                });
                              await _loadMoreMessages();
                              if (mounted)
                                setState(() {
                                  start = true;
                                });
                            }
                            chatController.chatRefreshController
                                .refreshCompleted();
                          },
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: StreamBuilder<List<Widget>>(
                                stream: chatController
                                    .openedChatMessagesWidgetsStream,
                                initialData: [],
                                builder: (context, snapshot) {
                                  return Column(
                                      children: snapshot.hasData
                                          ? snapshot.data
                                          : _chatMessages);
                                }),
                          ),
                        );
                      }),
                )),
                Container(
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    decoration: BoxDecoration(
                      color: appDesign.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              maxLines: 3,
                              minLines: 1,
                              controller: _message,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                  hintText: "Write your message here",
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              child: Icon(
                                Icons.send,
                                color: appDesign.green,
                              ),
                              onTap: _sendMessage),
                        ],
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomChatMessageWidget extends StatefulWidget {
  bool typing;
  bool loaded;
  // PlatformFile file;
  ChatMessageModel chatMessageModel;
  CustomChatMessageWidget({
    this.chatMessageModel,
    this.typing,
    // this.file,
    this.loaded,
    Key key,
  }) : super(key: key);

  @override
  _CustomChatMessageWidgetState createState() =>
      _CustomChatMessageWidgetState();
}

class _CustomChatMessageWidgetState extends State<CustomChatMessageWidget> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initState() {
    if (widget.loaded == null)
      sendMessage();
    else
      _sending = false;
    super.initState();
  }

  ChatMessageModel _chatMessageModel;

  sendMessage() async {
    print(widget.chatMessageModel.receiver.id);
    print(widget.chatMessageModel.sender.id);
    print(widget.chatMessageModel.id);
    print(widget.chatMessageModel.ad.id);
    ChatMessageModel chatMessageModel = await chatController.sendChatMessage(
        context,
        widget.chatMessageModel.ad.id,
        widget.chatMessageModel.receiver.id,
        widget.chatMessageModel.room,
        text: widget.chatMessageModel.message);
    if (mounted)
      setState(() {
        _chatMessageModel = chatMessageModel;
        _sending = false;
      });
  }

  bool _sending = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userController.userModel != null &&
                  userController.userModel.id ==
                      widget.chatMessageModel.sender.id
              ? InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: () {
                    if (widget.chatMessageModel.sender.id ==
                        userController.userModel.id)
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => EditProfile()));
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdOwnerPage(
                                adModel: widget.chatMessageModel.ad,
                                id: widget.chatMessageModel.room,
                              )));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        image: DecorationImage(
                            image: NetworkImage(userController.userModel.image),
                            fit: BoxFit.fill)),
                  ),
                ): SizedBox()
              ,
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: widget.chatMessageModel.sender.id ==
                      userController.userModel.id
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5, bottom: 5, top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 0.01,
                            color: appDesign.hint.withOpacity(0.3))
                      ],
                      color: userController.userModel != null &&
                              userController.userModel.id ==
                                  widget.chatMessageModel.sender.id
                          ? appDesign.white
                          : appDesign.green,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              userController.userModel != null &&
                                      userController.userModel.id ==
                                          widget.chatMessageModel.sender.id
                                  ? 15
                                  : 0),
                        topLeft: Radius.circular(
                              userController.userModel != null &&
                                      userController.userModel.id ==
                                          widget.chatMessageModel.sender.id
                                  ? 0
                                  : 15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: widget.typing != null
                      ? LoadingBumpingLine.circle(
                          size: 15,
                          backgroundColor: appDesign.green,
                        )
                      : Text(
                          widget.chatMessageModel.message ?? "",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              color: userController.userModel != null &&
                                      userController.userModel.id !=
                                          widget.chatMessageModel.sender.id
                                  ? appDesign.white
                                  : appDesign.green,
                              fontWeight: FontWeight.w600),
                        ),
                ),
                _sending
                    ? Container(
                        width: 10,
                        height: 10,
                        padding: EdgeInsets.all(1),
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ))
                    : Text(
                        widget.chatMessageModel.time ?? "",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: appDesign.hint.withOpacity(0.7)),
                        textAlign: TextAlign.left,
                      )
              ],
            ),
          ),
          SizedBox(width: 5,),
          userController.userModel != null &&
                  userController.userModel.id !=
                      widget.chatMessageModel.sender.id
              ? InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: () {
                    AdModel ad = widget.chatMessageModel.ad;
                    ad.user = widget.chatMessageModel.sender;
                    if (widget.chatMessageModel.sender.id ==
                        userController.userModel.id)
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Home(
                                index: 2,
                              )));
                    else
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdOwnerPage(
                                adModel: ad,
                                id: widget.chatMessageModel.id,
                              )));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: appDesign.white,
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.chatMessageModel.sender.image),
                            fit: BoxFit.fill)),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget {
  ChatModel chatModel;
  String from;
  ChatAppBar({
    this.from,
    this.chatModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            color: appDesign.green,
            onPressed: () {
              from == "owner"
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdOwnerPage(
                                adModel: chatModel.adModel,
                                id: chatModel.room,
                              )))
                  : from == "ad"
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdPage(
                                    adModel: chatModel.adModel,
                                  )))
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    index: 3,
                                  )));
            },
          ),
          Expanded(
            child: CustomText(
              chatModel.title,
              size: 18,
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            onTap: () {
              if (userController.userModel != null &&
                  userController.userModel.id != chatModel.adModel.user.id)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdOwnerPage(
                          adModel: chatModel.adModel,
                        )));
              else
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Home(index: 2)));
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      image: NetworkImage(chatModel.image), fit: BoxFit.fill)),
            ),
          ),
        ],
      ),
    );
  }
}

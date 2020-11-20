import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rxdart/rxdart.dart';

class ChatController {
  BehaviorSubject<int> _openedChatId = BehaviorSubject<int>();
  Function(int) get changeopenedChatId => _openedChatId.sink.add;
  int get openedChatId => _openedChatId.value;
  Stream<int> get openedChatIdStream => _openedChatId.stream;
  BehaviorSubject<RefreshController> _chatRefreshController =
      BehaviorSubject<RefreshController>();
  Function(RefreshController) get changechatRefreshController =>
      _chatRefreshController.sink.add;
  RefreshController get chatRefreshController => _chatRefreshController.value;
  Stream<RefreshController> get chatRefreshControllerStream =>
      _chatRefreshController.stream;

  BehaviorSubject<List<Widget>> _openedChatMessagesWidgets =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get changeopenedChatMessagesWidgets =>
      _openedChatMessagesWidgets.sink.add;
  List<Widget> get openedChatMessagesWidgets =>
      _openedChatMessagesWidgets.value;
  Stream<List<Widget>> get openedChatMessagesWidgetsStream =>
      _openedChatMessagesWidgets.stream;
  dispose() {
    _openedChatId.close();
    _chatRefreshController.close();
    _openedChatMessagesWidgets.close();
  }

  Future<List<ChatModel>> getHomeChats() async {
    List<ChatModel> _chatModels = [];
    try {
      Response response = await Dio().get(
        "$baseUrl/chat_contacts",
        options: Options(
            headers: {"apiToken": "${userController.userModel.apiToken}"},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
      );
      print(response.data);

      if (response.data['status'] == 200) {
        for (Map<String, dynamic> chat in response.data['data']) {
          _chatModels.add(
            ChatModel.fromJson(chat),
          );
        }
        return _chatModels;
      } else if (response.data['status'] == 400) {
        // Navigator.pop(context);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
    } catch (e) {}
    return _chatModels;
  }

  Future<ChatMessageModel> sendChatMessage(
      BuildContext context, int id, int receiverId, int room,
      {String text}) async {
    ChatMessageModel chatMessageModel;

    try {
      print({"$receiverId---$text"});
      Response response = await Dio().post(
        "$baseUrl/send_message",
        data: {"ad_id": id, "receiver_id": receiverId, "message": text},
        options: Options(
            headers: {"apiToken": "${userController.userModel.apiToken}"},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
      );
      print(response.data);

      if (response.data['status'] == 200) {
        chatMessageModel =
            ChatMessageModel.fromJson(response.data['data'], room);
        return chatMessageModel;
      } else if (response.data['status'] == 400) {
        // Navigator.pop(context);
        showMSG(context, "Alert", response.data['message'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {}
    return chatMessageModel;
  }

  Future<List> getChatMessages(int id, {int skip}) async {
    List result = [0, []];
    // ChatMessagesPagination _chatMessagesPagination;
    // showLoadingContext(context);
    try {
      Response response = await Dio().get(
        "$baseUrl/chat_messages/$id",
        options: Options(headers: {
          "apiToken": "${userController.userModel.apiToken}",
          "skip": skip
        }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
      );
      print(response.data);

      if (response.data['status'] == 200) {
        List<ChatMessageModel> _msgs = [];
        for (Map<String, dynamic> msg in response.data['data'])
          _msgs.add(ChatMessageModel.fromJson(msg, id));
        return [
          int.tryParse(response.data['data_count'].toString()),
          _msgs.reversed.toList()
        ];
        // _chatMessagesPagination=ChatMessagesPagination.fromJson(response.data);
        // return _chatMessagesPagination;
      } else if (response.data['status'] == 400) {
        // Navigator.pop(context);
        return result;
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        return result;
      }
    } catch (e) {}
    return result;
  }

  Future deletChatContact(BuildContext context, int id) async {
    showLoadingProgressIndicator(context);
    try {
      Response response = await Dio().delete(
        "$baseUrl/chat_contacts/$id",
        options: Options(
            headers: {"apiToken": "${userController.userModel.apiToken}"},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
      );
      print(response.data);

      if (response.data['status'] == 200) {
        Navigator.pop(context);
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);
        showMSG(context, "Alert", response.data['message'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {}
  }
}

ChatController chatController = ChatController();

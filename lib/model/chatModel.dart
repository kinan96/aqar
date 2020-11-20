import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:flutter/material.dart';
class ChatModel {
  int room;
AdModel adModel;
  String lastMsg;
  String published;
  String title;
    int receiverId;
  String image;
  ChatModel(
      {this.room,this.title,this.receiverId, this.image, this.adModel, this.published, this.lastMsg,});
  factory ChatModel.fromJson(Map<String, dynamic> chat) {
    print("ffffffffffffffffffffffffffff${chat['receiver_id']}");
    return ChatModel(
        room: chat['room'],
        title: chat['title'],
        receiverId:chat['receiver_id']??chat['receiver'],
        image: chat['image'],
        adModel: AdModel.fromJson(chat['ad']),
        lastMsg: chat['last_message'],
        published: chat['published'],);
  }
}

class ChatMessageModel {
  int id;
  UserModel sender;
  int room;
  UserModel receiver;
  String message;
  AdModel ad;
  String time;
  ChatMessageModel(
      {this.id,this.receiver,this.ad, this.message,this.room,
        this.sender, this.time,});
  factory ChatMessageModel.fromJson(Map<String, dynamic> message,int room) {
    return ChatMessageModel(
        id: message['id'],
        sender: UserModel.fromMapModel(message['sender']),
        room:int.tryParse(message['room'].toString())?? message['id']??room,
        receiver: UserModel.fromMapModel(message['receiver']),
        ad: AdModel.fromJson(message['ad']),
                message: message['message'],
        time: message['published'],
        );
  }
}


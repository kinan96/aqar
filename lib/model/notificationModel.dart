import 'package:aqar/model/adModel.dart';

class NotificationModel{
    int id;
  String type;
  bool read;
  String body;
  String status;
  String title;
  String note;
  int adId;
  String createdAt;
  NotificationModel(
      {this.id,
      this.body,
      this.status,
      this.note,
      this.adId,
      this.type,
      this.createdAt,
      this.read,
      this.title});
  factory NotificationModel.fromJson(Map<String, dynamic> noti) {
    return NotificationModel(
        id:int.tryParse(noti['id'].toString()),
        note: noti['note'],
        adId: noti['ad_id'],
        createdAt: noti['created_at'],
        read: noti['read'].toString() == "true",
        title: noti['title'],
        type: noti['type']);
  }

}



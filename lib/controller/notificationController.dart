import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'base_url.dart';

class NotificationController{
    BehaviorSubject<int> _unReadNotifications =
      BehaviorSubject<int>();
  Function(int) get changeunReadNotifications =>
      _unReadNotifications.sink.add;
  int get unReadNotifications =>
      _unReadNotifications.value;
  Stream<int> get unReadNotificationsStream =>
      _unReadNotifications.stream;
    BehaviorSubject<bool> _fromBackGround =
      BehaviorSubject<bool>();
  Function(bool) get changefromBackGround =>
      _fromBackGround.sink.add;
  bool get fromBackGround =>
      _fromBackGround.value;
  Stream<bool> get fromBackGroundStream =>
      _fromBackGround.stream;

  dispose() {
    _unReadNotifications.close();
    _fromBackGround.close();
  }

Future getMyNotifications()async{
    // showLoadingContext(context);
    List<NotificationModel>_notifications=[];
    try {
      Response response = await Dio().get("$baseUrl/notification"    ,      options: Options(headers: {
            "apiToken": "${userController.userModel.apiToken}"
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),);
print(response.data);
      if (response.data['status'] == 200) {
        // Navigator.pop(context);
print(response.data);
notificationController.changeunReadNotifications(int.tryParse( response.data['unread_count'].toString())??0);
for(Map<String,dynamic>notifi in response.data['data'])
_notifications.add(NotificationModel.fromJson(notifi),);
return _notifications;
      }
 else if (response.data['status'] == 400) {
              // Navigator.pop(context);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }      
    } catch (e) {}
return _notifications;

}


Future getSingleNotification(int id)async{
    // showLoadingContext(context);
    try {
      Response response = await Dio().get("$baseUrl/notification/$id"    ,      options: Options(headers: {
            "apiToken": "${userController.userModel.apiToken}"
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),);

      if (response.data['status'] == 200) {
        // Navigator.pop(context);
print(response.data);
      }
 else if (response.data['status'] == 400) {
              // Navigator.pop(context);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }      
    } catch (e) {}

}
}
NotificationController notificationController=NotificationController();
import 'package:aqar/controller/notificationController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/notificationPage.dart';
import 'package:aqar/view/pleaseSignUp.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AllNotificationsPage extends StatefulWidget {
  @override
  _AllNotificationsPageState createState() => _AllNotificationsPageState();
}

class _AllNotificationsPageState extends State<AllNotificationsPage> {
  @override
  void initState() {
 _getAllNotifications();
    super.initState();
  }
_getAllNotifications()async{
 List<NotificationModel>_noti= await     notificationController.getMyNotifications();
 if(mounted)setState(() {
   _notis=_noti;
 });
}
List<NotificationModel>_notis;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(title: "Notifications"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child:_notis==null? Center(child: LoadingBouncingGrid.square(),) : Column(
            children:List.generate(_notis.length, (index) => NotificationCard(notificationModel: _notis[index],)),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  NotificationModel notificationModel;

  NotificationCard({
    this.notificationModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage(notificationModel: notificationModel,)));
          },
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              decoration: BoxDecoration(
                  color: appDesign.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                 ! notificationModel.read
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.notifications_active,color: Colors.blue,),
                      )
                  :  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.notifications_none,color: Colors.blue,),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomText(
                                    notificationModel.title??"",maxLines: 1,),
                              ), Text(
                                   notificationModel.createdAt!=null? notificationModel.createdAt.split("،").first:""),
                            ],
                          ),
                              SizedBox(height: 5,),
                               CustomText(
                              notificationModel.note??"",fontWeight: FontWeight.w600,maxLines: 1,),
                        ],
                      ))
                ],
              ),
            )),
            SizedBox(height: 10,)
      ],
    );
  }
}

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({
    Key key,
  }) : super(key: key);

  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  void initState() {
    _getNotifications();
    super.initState();
  }

  _getNotifications() async {
    await  notificationController.getMyNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: notificationController.unReadNotificationsStream,
        initialData: 0,
        builder: (context, snapshot) {
          return IconButton(
              icon: (snapshot.hasData && snapshot.data > 0)
                  ? Icon(Icons.notifications_active,color: Colors.white,)
                  :  Icon(Icons.notifications_none,color: Colors.white,),
              onPressed: () {
                              if(userController.userModel==null)
              showModalBottomSheet(context: context, builder:(context)=>PleaseSignUp());
              else

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllNotificationsPage()));
              });
        });
  }
}

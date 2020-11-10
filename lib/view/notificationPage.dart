import 'package:aqar/controller/notificationController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
class NotificationPage extends StatefulWidget {
  NotificationModel notificationModel;
  NotificationPage({this.notificationModel});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    _getSinglenotification();
    super.initState();
  }

  _getSinglenotification()async {
   await notificationController.getSingleNotification(
        widget.notificationModel.id);
     if(mounted)   
    setState(() {
      loaded = true;
    });
  }

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    return ConnectivityWidget(
      offlineBanner: OflineConnectWidget(),
      builder: (context, isOlnline) => WillPopScope(
        onWillPop: () async {          return Future.value(true);
        },
        child: Scaffold(
          appBar: buildCustomAppBar(title: "Notification Page",),
          body: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                               widget.notificationModel.title??"",
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80),
                                child: Divider(thickness: 2,),
                              ),
                              SizedBox(height: 15,),
                              Text(
                                widget.notificationModel.note??"",

                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height:  widget.notificationModel.adId==null?0:20,),
                              widget.notificationModel.adId==null?SizedBox():
                              Center(
                                child: FlatButton(
                                  color: Colors.blue,
                                  onPressed: (){
                                  
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdPage(adModel: AdModel(id: widget.notificationModel.adId),)));
                                }, child: Text("Ad Page")),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
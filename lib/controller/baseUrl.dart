import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rxdart/rxdart.dart';

void showLoadingContext(BuildContext context){
          showDialog(context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (context)=> Center(
        child: Container(
          alignment: Alignment.center,
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder(
                      stream: progressRatio.progressRatioStream,
                      builder: (context,d)=>Text(d.hasData?"${d.data} %":"0.0 %",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),),
                    ),
                    LinearProgressIndicator()
                  ],
                ),
              ),
            ),
          ),
        ),
      ));

}

void showLoadingProgressIndicator(BuildContext context){
          showDialog(context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (context)=> Center(
        child: Container(
          alignment: Alignment.center,
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator()

                  ],
                ),
              ),
            ),
          ),
        ),
      ));

}

class ProgressRatio{
    BehaviorSubject<String> _progressRatio = BehaviorSubject<String>();
  Function(String) get changeprogressRatio => _progressRatio.sink.add;
  String get progressRatio => _progressRatio.value;
  Stream<String> get progressRatioStream => _progressRatio.stream;
  dispose() {
    _progressRatio.close();
  }

}

ProgressRatio progressRatio=ProgressRatio();

void showMSG(BuildContext context,String title,String msg,{int richAlertType,List<Widget>actions}){
  showDialog(context: context,
builder: (context)=>RichAlertDialog(alertTitle: Text(title,
  textDirection: TextDirection.ltr,
  style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18,

),), alertSubtitle: Text(msg,
    textDirection: TextDirection.ltr,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,

    )), alertType:richAlertType?? RichAlertType.SUCCESS,actions:actions?? [
      Container(
        width: MediaQuery.of(context).size.width-120,

        child: RaisedButton(
          child:Text("Ok"),
          
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      )
],)
);

}
class DeviceInfo{
    BehaviorSubject<String> _plateform = BehaviorSubject<String>();
  Function(String) get changeplateform => _plateform.sink.add;
  String get plateform => _plateform.value;
  Stream<String> get plateformStream => _plateform.stream;
    BehaviorSubject<String> _deviceId = BehaviorSubject<String>();
  Function(String) get changedeviceId => _deviceId.sink.add;
  String get deviceId => _deviceId.value;
  Stream<String> get deviceIdStream => _deviceId.stream;

dispose(){
  _deviceId.close();
  _plateform.close();
}
}
DeviceInfo deviceInfo=DeviceInfo();
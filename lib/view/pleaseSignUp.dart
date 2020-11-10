import 'package:aqar/model/design.dart';
import 'package:aqar/view/signIn.dart';
import 'package:aqar/view/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class PleaseSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: Color(0xff737373),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                                width: 60.5,
                                height: 120,
                                child: Image.asset(
                                    'assets/images/vector.png')),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "الرجاء تسجيل الدخول أولاً",
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: appDesign.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 40,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                
                                    Expanded(
                                    child: RaisedButton(
                                      child:Text( "تسجيل دخول"),
                                      onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignIn()));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      color: appDesign.white,
                                      child: Text(
                                          "إشترك الآن",style: TextStyle(color: Colors.blue),),
                                      onPressed: () async {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()));}
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(height: 10,)
                          ],
                        ),
                      ),
                 
                    ],
                  ))),
        ),
      ],
    );
  }
}

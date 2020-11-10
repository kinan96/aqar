import 'package:aqar/model/design.dart';
import 'package:flutter/material.dart';

class SignInFirstModalSheet extends StatefulWidget {
  bool logout;
  SignInFirstModalSheet({ this.logout});
  @override
  _SignInFirstModalSheetState createState() => _SignInFirstModalSheetState();
}

class _SignInFirstModalSheetState extends State<SignInFirstModalSheet> {
  bool empty = false;
  String reason = "";
  @override
  Widget build(BuildContext context) {
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
                                child: Image.asset('assets/images/vector.png')),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.logout != null
                                  ? "هل تريد تسجيل الخروج ؟"
                                  : "الرجاء تسجيل الدخول أولاً",
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,children:[
                                Expanded(
                                    child: RaisedButton(
                                      child: Text(widget.logout != null
                                          ? "إلغاء"
                                          : "تسجيل دخول"),
                                      onPressed: () {},
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ), 
                                  Expanded(
                                    child: RaisedButton(
                                      child: Text(widget.logout != null
                                          ? "Confirm"
                                          : "إشترك الآن"),
                                      onPressed: () async {},
                                      color: appDesign.white,
                                    ),
                                  ),
                                
                                ],
                              ),
                            ),SizedBox(height: 10,)
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

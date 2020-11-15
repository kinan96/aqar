import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/signUp.dart';
import 'package:aqar/view/splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
    GlobalKey<NavigatorState> nav;
    SignIn({this.nav});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  initState(){
    _chooseScreen();
    super.initState();
  }
  _chooseScreen()async{
    await fcm_listener(_firebaseMessaging, widget.nav);
  }
  String _email;
  String _password;
  bool _passVisible = false;
    DateTime _now;
  DateTime _nextTime;
bool _stop=false;
  Future<bool> _onWillPop() async {
    if (_now == null) {
      if (mounted)
        setState(() {
          _now = DateTime.now();
        });
    } else if (mounted)
      setState(() {
        _nextTime = DateTime.now();
      });
    if (_nextTime != null && _now != null) {
      var dif = _nextTime.difference(_now);
      if (mounted)
        setState(() {
          _now = null;
          _nextTime = null;
        });
      if (dif.inMilliseconds < 1000) whenExitDialog(context);

      print(dif.inMilliseconds);
    }
    return Future.value(false);
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WillPopScope(
        onWillPop: (){
          _onWillPop();
          return Future.value(false);
        },
        child: Scaffold(
          // appBar: buildCustomAppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomText(
                    "Aqar Application",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    size: 18,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                         
                            CustomTextFormField(
                              onSaved: (v) {
                                setState(() {
                                  _email = v;
                                });
                              },
                              prefixIcon: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20, right: 15),
                                    child: Icon(Icons.person,
                                        color: Colors.lightBlue),
                                  ),
                              lable: "Email",
                              onValidate: emailValidate,
                            ),
                          
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextFormField(
                              onSaved: (v) {
                                setState(() {
                                  _password = v;
                                });
                              },
                              prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.lightBlue),
                                ),
                              isPassword: true,
                              lable: "Password",
                              onValidate: passwordValidate,
                            
                          )
                        ],
                      )),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // CustomInkWell(
                  //   text: "نسيت كلمة المرور؟",
                  //   onTap: () =>
                  //       signInController.navigateToForgetPAssword(context),
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();
                              await userController.signIn(context, _email, _password);
                            },
                            child: Text("Login"),
                          ),
                        ),
                        SizedBox(width: 20,),
                                              Expanded(
                                                child: RaisedButton(
                          onPressed: () async {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUp()));
                          },
                          child: Text("Register"),
                        ),
                                              ),

                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 30, bottom: 10),
                  //   alignment: Alignment.bottomCenter,
                  //   child: CustomInkWell(
                  //     text: "لا تمتلك حساب ؟ سجل الآن",
                  //     onTap: () {
                  //       Navigator.of(context).pushReplacement(
                  //           MaterialPageRoute(builder: (context) => SignUp()));
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

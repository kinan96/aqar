import 'package:aqar/controller/signUpController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/signIn.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  initState() {
    // _getCities();
    super.initState();
  }


  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  String _password;
  int _typeId = 0;
  bool _emptyType = false;
  bool _acceptTerms = false;
  void _changeTermsCheck() {
    setState(() {
      _acceptTerms = !_acceptTerms;
    });
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<int, String> _types = {0: "Select Type",1:"Normal User",2:"Company"};
  List<DropdownMenuItem> _typeItems = [];
  _onCityChange(val) {
    setState(() {
      _typeId = val;
      if (val > 0) _emptyType = false;
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    _typeItems = signUpController.builDropDownItem(_types, _typeId);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: WillPopScope(
        onWillPop: (){
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignIn()));
          return Future.value(false);
        },
        child: Scaffold(
          key: _sc,
          appBar: buildCustomAppBar(onBack: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignIn()));
          }),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomText(
                      "User Register",
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
                                _firstName = v;
                              });
                            },
                            onValidate: (e) {
                            if (e.isEmpty) {
                              return "Please insert First Name";
                            }
                          },
                            textInputType: TextInputType.text,
                                                          prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child:
                                Icon(Icons.person, color: Colors.lightBlue),
                              ),

                            lable: "FirstName",

                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _lastName = v;
                              });
                            },
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child:
                                Icon(Icons.person, color: Colors.lightBlue),
                              ),
                            onValidate: (e) {
                            if (e.isEmpty) {
                              return "Please insert Last Name";
                            }
                          },
                            textInputType: TextInputType.text,
                            lable: "LastName",
                            
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _email = v;
                              });
                            },
                            onValidate: emailValidate,
                         prefixIcon:    Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child:
                                Icon(Icons.email, color: Colors.lightBlue),
                              ),
                            textInputType: TextInputType.emailAddress,
                            lable: "Email",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _phone = v;
                              });
                            },
                                                        prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.lightBlue),
                            ),

                            onValidate: mobileValidate,
                            textInputType: TextInputType.number,
                            lable: "Mobile",
                          ),
                          SizedBox(
                            height: 10,
                          ),
                                           
                          CustomTextFormField(
                            onSaved: (v) {
                              setState(() {
                                _password = v;
                              });
                            },
                            isPassword: true,
                            lable: "Password",
                                                          prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.lightBlue),
                              ),

                            onValidate: passwordValidate,
                          ),
                               Card(
                        elevation: 6.0,
                                                child: DecoratedDropDownButton(
                            isNotSelected: _emptyType,
                            items: _typeItems,
                            value: _typeId,
                            onChange: _onCityChange,
                          )),
                          
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              _acceptTerms
                                  ? ConditionAndTermsIcon(
                                      onTap: _changeTermsCheck,
                                      iconData: Icons.check_box,
                                    )
                                  : ConditionAndTermsIcon(
                                      onTap: _changeTermsCheck,
                                      iconData: Icons.check_box_outline_blank,
                                    ),
                              CustomInkWell(
                                onTap: () => signUpController
                                    .navigateToTermsAndCond(context),
                                text: "Accept terms and conditions",
                              ),
                              SizedBox(
                                width: 3,
                              ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      onPressed: () async {
                        _typeId == 0
                            ? setState(() {
                                _emptyType = true;
                              })
                            : _emptyType = false;

                        if (!_formKey.currentState.validate()) return;
                        if (_emptyType && !_acceptTerms)
                          _sc.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Select type and accept terms and conditions Firstly")));
                        else if (_emptyType)
                          _sc.currentState.showSnackBar(SnackBar(
                              content: Text("Select type Firstly")));
                        else if (!_acceptTerms)
                          _sc.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Accept terms and conditions Firstly")));
                        else {
                          _formKey.currentState.save();

                          await userController.signUp(context,
                              password: _password,
                              
                              userModel: UserModel(
                                  email: _email, firstName: _firstName,lastName: _lastName,type: _typeId==2?"Company":"Normal User", mobile: _phone));
                        }
                      },
                      child: Text("Register"),
                    ),
                  ),
            
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:aqar/controller/signUpController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/profileBody.dart';
import 'package:aqar/view/updatePassword.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  initState() {
    print("----- ${userController.userModel.cityModel.id} ------");
    _firstNameCTL = TextEditingController(text: userController.userModel.firstName);
    _lastNameCTL = TextEditingController(text: userController.userModel.lastName);
    _emailCTL = TextEditingController(text: userController.userModel.email);
    _mobileCTL = TextEditingController(
        text: userController.userModel.mobile
            .replaceAllMapped("+966", (match) => "0"));
    // _getCities();
    super.initState();
  }

  _getCities() async {
    Map<int, String> _citiesButtons = {0: "المدينة"};
    List<CityModel> _city = await userController.getListOfCites(_sc);
    if (_city != null)
      for (int i = 0; i < _city.length; i++)
        _citiesButtons[_city[i].id] = _city[i].name;
    setState(() {
      userController.appCities = _citiesButtons;
      _cities = _citiesButtons;
      _cityId = userController.userModel.cityModel.id;
    });
  }

  String _delete;
  String _firstName;
  String _lastName;
  String _email;
  String _phone;
  int _cityId = 0;
  bool _emptyCity = false;
  TextEditingController _firstNameCTL;
  TextEditingController _lastNameCTL;
  TextEditingController _emailCTL;
  TextEditingController _mobileCTL;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  Map<int, String> _cities = {0: "جاري تحميل المدن..."};
  List<DropdownMenuItem> _cityItems = [];
  _onCityChange(val) {
    setState(() {
      _cityId = val;
      if (val > 0) _emptyCity = false;
    });
  }

  File _image;
  _pickProfileImage() async {
    final _f = await ImagePicker().getImage(source: ImageSource.gallery);
    if(_f!=null)
    setState(() {
      _image = File(_f.path);
      _delete=null;
    });
    File _crop = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1.2));
        if(_crop!=null)
    setState(() {
      _image = _crop;
      _delete=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    _cityItems = signUpController.builDropDownItem(_cities, _cityId);
    return WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=> ProfileBody()));
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          key: _sc,
          appBar: buildCustomAppBar(
            title: "Edit Profile",
            onBack: (){
                      Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=> ProfileBody()));

            }
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                          width: MediaQuery.of(context).size.width / 3 + 20,
      height: (MediaQuery.of(context).size.width / 3) * 1.2 + 20,

                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        buildProfilePicture(context,
                            file: _image,
                            imageURL: _delete != null
                                ? "https://realestate112.000webhostapp.com/admin/img/logo.jpg"
                                : userController.userModel.image,
                            iconData: Icons.camera_alt,
                            onPressed: _pickProfileImage),
                    Container(
                      decoration: BoxDecoration(
                        color: appDesign.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                            
                            onTap: () async {
                              if (mounted)
                                setState(() {
                                  _delete = "image";
                                  _image = null;
                                });
                            },
                            child: Icon(Icons.close,color: Colors.blue,),
                          ),
                    )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                             CustomTextFormField(
                               controller: _firstNameCTL,
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
                              controller: _lastNameCTL,
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
                              controller: _emailCTL,
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
                              controller: _mobileCTL,
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
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // DecoratedDropDownButton(
                            //   isNotSelected: _emptyCity,
                            //   items: _cityItems,
                            //   value: _cityId,
                            //   onChange: _onCityChange,
                            // ),
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () async {
                              // setState(() {
                              //   _cityId == 0
                              //       ? _emptyCity = true
                              //       : _emptyCity = false;
                              // });

                              if (!_formKey.currentState.validate()) return;
                              // if (_emptyCity) return;
                              _formKey.currentState.save();
                              UserModel userModel = userController.userModel;
                              userModel.firstName = _firstNameCTL.text.trim();
                              userModel.lastName = _lastNameCTL.text.trim();
                              userModel.mobile = _phone.trim();
                              userModel.email = _email.trim();
                              // userModel.cityModel = CityModel(
                              //     id: _cityId,
                              //     name: userController.appCities[_cityId]);
                              userModel.imageFile = _image;
                              userController.changeuserModel(userModel);

                              FormData data = await userController.userModel
                                  .toUpdateProfileFormData(delete: _delete);

                              await userController.updateProfile(
                                  context, data,  userController.userModel.id);
                            },
                            child: Text("Update"),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=> ProfileBody()));
                            },
                            color: appDesign.bg,
                            child: Text("Cancel"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>UpdatePassword()));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: CustomText(
                        "Change Password",
                        color: appDesign.hint,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

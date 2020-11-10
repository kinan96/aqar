import 'dart:io';
import 'dart:math';
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/changePassword.dart';
import 'package:aqar/view/confirm.dart';
import 'package:aqar/view/signIn.dart';
import 'package:aqar/view/splash.dart';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController {
  BehaviorSubject<UserModel> _userModel = BehaviorSubject<UserModel>();
  Function(UserModel) get changeuserModel => _userModel.sink.add;
  UserModel get userModel => _userModel.value;
  Stream<UserModel> get userModelStream => _userModel.stream;
Map<int,String>appCities={0:"جاري تحميل المدن..."};
  dispose() {
    _userModel.close();
  }

  Future<List<CityModel>> getListOfCites(GlobalKey<ScaffoldState> sc) async {
    List<CityModel> _cities = [];
    try {
      
      Response response = await Dio().get("$baseUrl/city");
      print(response.data);
      if (response.data['status'] == 200) {
        for (Map<String, dynamic> city in response.data['data'])
        _cities.add(CityModel.fromJson(city));
      } else {
sc.currentState.showSnackBar(SnackBar(content: Text("${response.data['message']}")));
      }
    } catch (e) {
      
    }
    return _cities;
  }

  Future signUp(BuildContext context,
      {UserModel userModel, String password}) async {
        progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user",
          data: userModel.toSignUpJson(password: password,type:userModel.type),
          options: Options(
              receiveDataWhenStatusError: true, validateStatus: (i) => true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        await addSharedListOfString("savedUser", [userModel.email.trim(), password]);
        UserModel model = UserModel.fromJson(response);
        print(model.apiToken);
        userController.changeuserModel(model);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Confirm()));
      } else if (response.data['status'] == 400) {
              Navigator.pop(context);
        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
    }
  }

  Future sendCode(BuildContext context,{String email}) async {
    progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/resend_code",
          data: {"email":email??userController.userModel.email},
          options: Options(
              validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
          print(response.data);
      if (response.data['status'] == 200) {
        Navigator.of(context).pop();
        print(response.data);
        UserModel user = userController.userModel??UserModel(email: email);
        user.email= email??user.email;
        user.activationCode =
            int.tryParse(response.data['data']["activation_code"].toString());
        userController.changeuserModel(user);
        if(email!=null)
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Confirm(changePass: true,)));
      } else if (response.data['status'] == 400) {  
            Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future activate(BuildContext context, String code,
      {bool changePassword}) async {
        progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/active",
          data: {
            "activation_code": code
          },
        
          options: Options(
            headers: {"apiToken":userController.userModel.apiToken},
              validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        print(response.data);
        UserModel model = UserModel.fromJson(response);
        List<String>savedUser=await getSharedListOfStringOfKey("savedUser");
        if(savedUser!=null)
                await addSharedListOfString("savedUser", [userModel.email.trim(), savedUser[1]]);
        userController.changeuserModel(model);
      print("$model ------------ $savedUser");
        if (changePassword != null)
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => ChangePassword()));
        else {
 Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
        }
      } else if (response.data['status'] == 400) {      Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future signIn(BuildContext context, String email, String password,{bool open,Function onNotifi}) async {
    progressRatio.changeprogressRatio("0.0");
    if(open==null)
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/login",
          data: {
            "email": email,
            "password": password,
            "device_token":deviceInfo.deviceId.toString(),
              "device_type": deviceInfo.plateform.toString()
            
          },
          options: Options(
              validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
        
      if (response.data['status'] == 200) {
        print(response.data);

        UserModel model = UserModel.fromJson(response);
                await addSharedListOfString("savedUser", [email.trim(), password]);
print(model.activationCode);
          userController.changeuserModel(model);
        if(onNotifi!=null)
         await onNotifi();
         else
        if (model.activationCode != null&&model.activationCode.toString().length==4) {
          print(model.activationCode);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Confirm()));
        } else {
 Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
        }
      } else if (response.data['status'] == 400) { 
                print(response.data);

        if(open==null)
             Navigator.pop(context);

       showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING,actions:open==null?null: [  Container(
        width: MediaQuery.of(context).size.width-120,

        child: RaisedButton(
          child:Text("حسناً"),
          
          onPressed: ()async{
                    await removeSharedOfKey("savedUser");

                                          Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) =>Splash()));
          },
        ),
      )]);
 
      } else if (response.data['status'] == 401) {
                print(response.data);

        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
      print(e.toString());
    }
  }

  Future showProfile(GlobalKey<ScaffoldState>sc,
     int id) async {
    try {
      Response response = await Dio().get("$baseUrl/user/$id",
          options: Options(
              receiveDataWhenStatusError: true, validateStatus: (i) => true),
          onReceiveProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        UserModel model = UserModel.fromJson(response);
return model;
      } else if (response.data['status'] == 400) {
sc.currentState.showSnackBar(SnackBar(content: Text("${response.data['msg']}")));
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updatePassword(BuildContext context,String oldPassword, String newPassword) async {
    progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/update_password",
          data: {
            "new_password": newPassword,
            "old_password":oldPassword
          },
          options: Options(headers: {
            "apiToken": "${userController.userModel.apiToken}"
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        print(response.data);
Navigator.pop(context);
        UserModel model = UserModel.fromJson(response);      
                  await addSharedListOfString("savedUser", [model.email.trim(), newPassword]);

          userController.changeuserModel(model);
        if (model.activationCode != null&&model.activationCode.toString().length==4) {
                    print(model.activationCode);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Confirm()));
        } else {
          
        showMSG(context, "Message", "Password Updated Succefully",
              richAlertType: RichAlertType.SUCCESS,actions: [Container(
                width: MediaQuery.of(context).size.width-80,
                child: RaisedButton(
                  child :Text("OK"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              )]);
        }
      } else if (response.data['status'] == 400) {      Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future forgetPassword(BuildContext context, String newPassword) async {
    progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/resetPassword",
          data: {
            "password": newPassword,
            "email":userController.userModel.email.trim()
          },
          options: Options(validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        print(response.data);
Navigator.pop(context);
        UserModel model = UserModel.fromJson(response);      
                  await addSharedListOfString("savedUser", [model.email.trim(), newPassword]);

          userController.changeuserModel(model);
        if (model.activationCode != null&&model.activationCode.toString().length==4) {
                    print(model.activationCode);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Confirm()));
        } else {
          showMSG(context, "رسالة إدارية", "تم تعديل الباسسورد بنجاح",
              richAlertType: RichAlertType.SUCCESS,actions:  [Container(
                width: MediaQuery.of(context).size.width-60,
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child:Text( "تسجيل دخول"),
                        onPressed: ()async{
                                 await signIn(context, userController.userModel.email.trim(), newPassword);

                        },
                      ),
                    ),
SizedBox(width: 10,),
                     Expanded(
                       child: RaisedButton(
                        child:Text( "إلغاء")
                        ,
                        color: appDesign.white,
                        
                        onPressed: ()async{
                               Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>SignIn()));
                        },
                    ),
                     ),
                  ],
                ),
              )]);

        }
      } else if (response.data['status'] == 400) {      Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }



//   Future<UserModel> getProfile(BuildContext context,int id) async {
//     UserModel userModel;
//     progressRatio.changeprogressRatio("0.0");
//     // showLoadingContext(context);
//     try {
//       Response response = await Dio().get("$baseUrl/user/$id",
//       options: Options(
//         headers: {
//             "Authorization": "Bearer${userController.userModel.apiToken}"
//           },
//       ),
//      );
// print(response.data);
//       if (response.data['status'] == 200) {
// userModel =UserModel.fromJson(response);
// return userModel;
//       } else if(response.data['status']==400) {      Navigator.pop(context);

//         showMSG(context, "خطأ", response.data['message'],
//             richAlertType: RichAlertType.ERROR);
//       }
//       else{
//                   await removeSharedOfKey("savedUser");
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (context) => Splash()));

//       }
//       return userModel;
//     } catch (e) {
//       Navigator.pop(context);
//     }
//   }



  Future<bool> updateProfile(BuildContext context,FormData data,int id) async {
                progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
   try {
      Response response = await Dio().post("$baseUrl/user/$id",
          data: data,
          options: Options(headers: {
            "apiToken":userController.userModel.apiToken
          }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
          onSendProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
        Fluttertoast.showToast(msg: "updated succefully");
        Navigator.pop(context);
        print(response.data);
        UserModel model = UserModel.fromJson(response);
                List<String>savedUser=await getSharedListOfStringOfKey("savedUser");
                       if(savedUser!=null)

                await addSharedListOfString("savedUser", [model.email.trim(), savedUser[1]]);

          userController.changeuserModel(model);

        if (model.activationCode != null&&model.activationCode.toString().length==4) {
               print(model.activationCode);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Confirm()));

        } 
        return true;
      } else if (response.data['status'] == 400) {    
          Navigator.pop(context);

        showMSG(context, "رسالة إدارية", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
        return false;    
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await logOut(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
    return false;
    }

  Future logOut(BuildContext context) async {
    progressRatio.changeprogressRatio("0.0");
    showLoadingContext(context);
    try {
      Response response = await Dio().post("$baseUrl/user/logout",
      data: {"device_token":deviceInfo.deviceId},
      options: Options(
        headers: {"apiToken":userController.userModel.apiToken}
      ),
      onReceiveProgress: (sent,total){
            progressRatio.changeprogressRatio("${(total/sent*100).toStringAsFixed(0)}");
          });

      if (response.data['status'] == 200) {
          await removeSharedOfKey("savedUser");
          userController.changeuserModel(null);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
      } else if(response.data['status']==400) {      Navigator.pop(context);

        showMSG(context, "خطأ", response.data['msg'],
            richAlertType: RichAlertType.ERROR);
      }
      else{
                  await removeSharedOfKey("savedUser");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));

      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  // Future uploadAttachment(BuildContext context,File file,String type) async {
  //               progressRatio.changeprogressRatio("0.0");
  //   showLoadingContext(context);
  //  try {
  //  MultipartFile file1=   await MultipartFile.fromFile(file.path,
  //               filename: file.path.split('/').last.split(".").first);
  //     Response response = await Dio().post("$baseUrl/user/upload_attachment",
  //         data: FormData.fromMap({
  //           "attachment":file1,
  //           "type":filesize(file.lengthSync()).toString()
  //         }),
  //         options: Options(headers: {
  //           "Authorization": "Bearer${userController.userModel.apiToken}"
  //         }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
  //         onSendProgress: (sent,total){
  //           progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
  //         });
  //     if (response.data['status'] == 200) {
  //       Navigator.pop(context);
  //       print(response.data);
  //       UserModel model = UserModel.fromJson(response);

  //         userController.changeuserModel(model);
  //     } else if (response.data['status'] == 400) {      Navigator.pop(context);

  //       showMSG(context, "رسالة إدارية", response.data['message'],
  //           richAlertType: RichAlertType.WARNING);
  //     } else if (response.data['status'] == 401) {
  //       await removeSharedOfKey("savedUser");
  //       await logOut(context);
  //     }
  //   } catch (e) {Navigator.pop(context);} 
  //    }

  // Future removeAttatchment(BuildContext context,int id) async {
  //  progressRatio.changeprogressRatio("0.0");
  //   showLoadingContext(context);
  //  try {
  //     Response response = await Dio().post("$baseUrl/user/remove_attachment",
  //         data:{"id":id.toString()},
  //         options: Options(headers: {
  //           "Authorization": "Bearer${userController.userModel.apiToken}"
  //         }, validateStatus: (s) => true, receiveDataWhenStatusError: true),
  //         onSendProgress: (sent,total){
  //           progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
  //         });
  //     if (response.data['status'] == 200) {
  //       Navigator.pop(context);
  //       print(response.data);
  //       UserModel model = UserModel.fromJson(response);

  //         userController.changeuserModel(model);
  //     } else if (response.data['status'] == 400) {      Navigator.pop(context);

  //       showMSG(context, "رسالة إدارية", response.data['message'],
  //           richAlertType: RichAlertType.WARNING);
  //     } else if (response.data['status'] == 401) {
  //       await removeSharedOfKey("savedUser");
  //       await logOut(context);
  //     }
  //   } catch (e) {Navigator.pop(context);} }
    }

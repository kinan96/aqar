import 'dart:io';

import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/userController.dart';
import 'package:dio/dio.dart';
import 'package:latlong/latlong.dart';

import 'adModel.dart';


class UserModel {
  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.msg,
      this.mobile,
      this.email,
      this.image,
      this.approved,
      this.createdAt,
      this.online,
      this.status,
      this.updatedAt,
      this.deviceToken,
      this.cityModel,
      this.activationCode,
      this.imageFile,
      this.type,
      this.userName,
      this.ads,
      this.totalRating,
      this.apiToken});

  int id;
  CityModel cityModel;
  String firstName;
  String lastName;
  String userName;
  String apiToken;
  String deviceToken;
  File imageFile;
  String type;
  String status;
  bool online;
  bool approved;
  String createdAt;
  String msg;
  String updatedAt;
  List<AdModel>ads;
  double totalRating;
  String mobile;
  String email;
  String image;
  int activationCode;
   
  factory UserModel.fromError(Map<String, dynamic> json) => UserModel(
        msg: json["msg"],
      );
  factory UserModel.fromJson(Response json) {
    print(json);
    List<AdModel>_ads=[];
    if(json.data['data']['ads']!=null)
    {
      for(Map<String,dynamic>ad in json.data['data']['ads'])
      _ads.add(AdModel.fromSearchList(ad));
    }
    return UserModel(
        id: json.data['data']["id"],
        firstName: json.data['data']["first_name"],
                type: json.data['data']["type"],
        lastName: json.data['data']["last_name"],
        userName: json.data['data']["username"],
        mobile: json.data['data']["mobile"],
        deviceToken: json.data['data']["deviceToken"],
        totalRating: double.tryParse(json.data['data']["total_rating"].toString()) ?? 0,
        status: json.data['data']["status"],
        approved: json.data['data']["approved"].toString() == "true",
        online: json.data['data']["online"].toString() == "true",
        createdAt: json.data['data']["created_at"],
        updatedAt: json.data['data']["updated_at"],
        cityModel:json.data['data']["city"]!=null? CityModel.fromJson(json.data['data']["city"]):
         CityModel(
            id: int.tryParse(json.data['data']["city_id"].toString()) ?? 0,
            name: userController.appCities[
                int.tryParse(json.data['data']["city_id"].toString()) ?? 0]),  
        email: json.data['data']["email"],
        image: json.data['data']["image"],
        ads:_ads,
        activationCode: json.data['data']["activation_code"] != null
            ? int.tryParse(json.data['data']["activation_code"].toString()) ??
                null
            : null,
        apiToken: json.data['data']["apiToken"] == null
            ? userController.userModel != null
                ? userController.userModel.apiToken
                : null
            : "sa3d01${json.data['data']["apiToken"]}");
  }

  factory UserModel.fromMapModel(Map<String,dynamic> data) {
    List<AdModel>_ads=[];
    if(data['ads']!=null)
    {
      for(Map<String,dynamic>ad in data['ads'])
      _ads.add(AdModel.fromJson(ad));
    }
    return UserModel(
        id: data["id"],
        firstName: data["first_name"],
                        type: data["type"],

        lastName: data["last_name"],
        userName: data['username'],
        mobile: data["mobile"],
        deviceToken: data["deviceToken"],
        totalRating: double.tryParse(data["total_rating"].toString()) ?? 0,
        status: data["status"],
        approved: data["approved"].toString() == "true",
        online: data["online"].toString() == "true",
        createdAt: data["created_at"],
        updatedAt: data["updated_at"],
        cityModel:data["city"]!=null? CityModel.fromJson(data["city"]):
         CityModel(
            id: int.tryParse(data["city_id"].toString()) ?? 0,
            name: userController.appCities[
                int.tryParse(data["city_id"].toString()) ?? 0]),
        
        email: data["email"],
        image: data["image"],
        ads:_ads,
        activationCode: data["activation_code"] != null
            ? int.tryParse(data["activation_code"].toString()) ??
                null
            : null,
        apiToken: data["apiToken"] == null
            ? userController.userModel != null
                ? userController.userModel.apiToken
                : null
            : "sa3d01${data["apiToken"]}");
  }


  Map<String, dynamic> toSignUpJson({String password, String type}) => {
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "email": email,
        "password": password,
        "type":type,
        "device_token": deviceInfo.deviceId.toString(),
        "device_type": deviceInfo.plateform.toString()
      };

  Future<FormData> toUpdateProfileFormData({String delete}) async =>
      FormData.fromMap({
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
                "type":type,

        "email": email,
        "city_id":cityModel.id,
        "device_token": deviceInfo.deviceId.toString(),
        "device_type": deviceInfo.plateform.toString(),
        "image": imageFile != null
            ? await MultipartFile.fromFile(imageFile.path,
                filename: imageFile.path.split('/').last)
            : null,
        if (delete != null) "delete": delete
      });
}

class UserType {
  int id;
  String name;
  UserType({this.id, this.name});
  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(id: json['id'], name: json['name']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CityModel {
  int id;
  String name;
  LatLng latLng;
  CityModel({this.id, this.name,this.latLng});
  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(id: json['id'], name: json['name'],latLng:LatLng(double.tryParse(json['lat'].toString()),double.tryParse(json['lng'].toString())));
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "lat":latLng.latitude,
        "lng":latLng.longitude,
        "name": name,
      };
}

UserController userController = UserController();

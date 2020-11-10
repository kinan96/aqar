import 'dart:convert';
import 'dart:io';

import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/userController.dart';
import 'package:dio/dio.dart';
import 'package:latlong/latlong.dart';



class Attachment {
  int id;
  String type;
  String fileName;

  String url;
  Attachment({this.id, this.fileName, this.type, this.url});
  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
        id: json['id'],
        type: json['type'],
        fileName: json['file_name'],
        url: json['attachment']);
  }
}

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
Map<String, dynamic> saudiaCities = {

  "مكة المكرمة": {"lat": 21.422510, "lng": 39.826168}, //Mecca, Saudi Arabia
  "المدينة المنورة": {     //Medina, Saudi Arabia

    "lat": 24.470901,
    "lng": 39.612236
  },
    "الرياض": {"lat": 24.774265, "lng": 46.738586}, //Riyadh, Saudi Arabia
  "الدوادمي": {"lat": 24.507143, "lng": 44.408798}, //Al Duwadimi, Saudi Arabia
  "القطيف": {"lat": 26.565191, "lng": 49.996376}, //Al Qatif, Saudi Arabia
  "الظهران": {"lat": 26.288769, "lng": 50.114101}, //Dhahran, Saudi Arabia
  "الدمام": {"lat": 26.399250, "lng": 49.984360}, //Dammam, Saudi Arabia
  "الطائف": {"lat": 21.437273, "lng": 40.512714}, //Taif, Mecca, Saudi Arabia
  "المدينة الصناعية الأولى": {
    "lat": 26.396790,
    "lng": 50.140400
  }, //Industrial city 1, Dammam, Saudi Arabia
  "جازان": {"lat": 16.909683, "lng": 42.567902}, //Jazan, Saudi Arabia
  "جدة": {"lat": 21.543333, "lng": 39.172779}, //Jeddah, Tihamah, Saudi Arabia
  "حائل": {"lat": 27.523647, "lng": 41.696632}, //Hail, Saudi Arabia
  "حفر الباطن": {
    "lat": 28.446959,
    "lng": 45.948944
  }, //Hafar Al Batin, Saudi Arabia
  "حرمة": {
    "lat": 25.994478,
    "lng": 45.318161
  }, //Harmah, Central Region, Saudi Arabia

  "خميس مشيط": {
    "lat": 18.329384,
    "lng": 42.759365
  }, //Khamis Mushait, Asir, Saudi Arabia
  "عنيزة": {
    "lat": 26.094088,
    "lng": 43.973454
  }, //Unayzah, Al Qassim, Saudi Arabia
  "سكاكا": {"lat": 29.953894, "lng": 40.197044}, //Sakaka, Al Jawf, Saudi Arabia
  "عرعر": {"lat": 30.983334, "lng": 41.016666}, //Arar, Saudi Arabia
  "ينبع": {"lat": 24.186848, "lng": 38.026428}, //Yanbu, Saudi Arabia
};
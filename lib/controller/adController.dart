import 'dart:io';

import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:rxdart/rxdart.dart';

class AdController {
  BehaviorSubject<List> _adLocationData = BehaviorSubject<List>();
  Function(List) get changeadLocationData => _adLocationData.sink.add;
  List get adLocationData => _adLocationData.value;
  Stream<List> get adLocationDataStream => _adLocationData.stream;
  dispose() {
    _adLocationData.close();
  }

  Map<int, String> categories;
  Map<int, String> cities;
  Future getAdDetails(GlobalKey<ScaffoldState> sc, int id) async {
    try {
      Response response = await Dio().get("$baseUrl/ad/$id",
          options: Options(
              receiveDataWhenStatusError: true,
              validateStatus: (i) => true), onReceiveProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      print(response.data);
      if (response.data['status'] == 200) {
        AdModel model = AdModel.fromJson(response.data['data']);
        return model;
      } else if (response.data['status'] == 400) {
        sc.currentState
            .showSnackBar(SnackBar(content: Text("${response.data['msg']}")));
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<int, String>> getCategories({BuildContext context}) async {
    try {
      if (adController.categories != null) {
        return adController.categories;
      }

      Map<int, String> _categories = {0: "التصنيف الرئيسي"};
      Response response = await Dio().get("$baseUrl/category",
          options: Options(
              receiveDataWhenStatusError: true,
              validateStatus: (i) => true), onReceiveProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        print(response.data);
        for (Map<String, dynamic> cat in response.data['data'])
          _categories[cat['id']] = cat['name'];
        adController.categories = _categories;
        return _categories;
      } else if (response.data['status'] == 400) {
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
      return _categories;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<Map<int, String>> getCities({BuildContext context}) async {
    try {
      if (adController.cities != null) {
        return adController.cities;
      }

      Map<int, String> _cities = {0: "المدينة"};
      Response response = await Dio().get("$baseUrl/city");
      if (response.data['status'] == 200) {
        for (Map<String, dynamic> city in response.data['data'])
          _cities[city['id']] = city['name'];
        adController.cities = _cities;
        return _cities;
      } else if (response.data['status'] == 400) {
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
      return _cities;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<List<String>> uploadFiles(BuildContext context,
      {List<File> files}) async {
    try {
      List<String> uploadedFiles = [];
      progressRatio.changeprogressRatio("0.0");
      showLoadingContext(context);
      Map<String, dynamic> dataMap = {};
      for (int i = 0; i < files.length; i++)
        dataMap["file[$i]"] = await MultipartFile.fromFile(files[i].path);

      FormData data = FormData.fromMap(dataMap);
      Response response = await Dio().post("$baseUrl/upload_files",
          data: data,
          options: Options(
              headers: {"apiToken": userController.userModel.apiToken},
              validateStatus: (s) => true,
              receiveDataWhenStatusError: true), onSendProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        Navigator.pop(context);
        for (int i = 0; i < response.data['data'].length; i++)
          uploadedFiles.add(response.data['data'][i].toString());

        print(response.data);
        return uploadedFiles;
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
    return [];
  }

  Future uploadAd(BuildContext context,
      {List<String> images,
      String title,
      area,
      district,
      nearPlaces,
      street,
      propertyType,
      lift,
      kitchen,
      familyOrSingle,
      vellaOrapartment,
      pool,
      garage,
      note,
      price,
      age,
      room,
      bath,
      landType,
      meterPrice,
      postalCode,
      location,
      LatLng latLng,
      int cityId,
      int id}) async {
    try {
      progressRatio.changeprogressRatio("0.0");
      showLoadingContext(context);
      Map<String, dynamic> dataMap = {};
      print(dataMap);
      dataMap['images'] = images;
      dataMap['title'] = title;
      dataMap['note'] = note;
      dataMap['city_id'] = cityId;
      dataMap['price'] = price;
      dataMap['district'] = district;
      dataMap['street'] = street;
      dataMap['postal_code'] = postalCode;
      dataMap['property_type'] = propertyType;
      dataMap['lat'] = latLng.latitude;
      dataMap['lng'] = latLng.longitude;
      dataMap['building_age'] = age;
      dataMap['lift'] = lift;
      dataMap['room'] = room;
      dataMap['near_places']=nearPlaces;
      dataMap['bath'] = bath;
            dataMap['area'] = area;
            dataMap['address'] = location;
      dataMap['kitchen'] = kitchen;
      dataMap['social_status'] = familyOrSingle;
      dataMap['building_type'] = vellaOrapartment;
      dataMap['pool'] = pool;
      dataMap['garage'] = garage;
      dataMap['meter_price'] = meterPrice;
      dataMap['land_type'] = landType;
      Response response = await Dio().post(
          id != null ? "$baseUrl/ad/$id" : "$baseUrl/ad",
          data: dataMap,
          options: Options(
              headers: {"apiToken": userController.userModel.apiToken},
              validateStatus: (s) => true,
              receiveDataWhenStatusError: true), onSendProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        Navigator.pop(context);
        showMSG(context, "Alert",
            id==null?"Uplaoded Succefully":"Updated Succesfully",
            richAlertType: RichAlertType.SUCCESS,
            actions: [
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        child: Text("Ok"),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]);
        print(response.data);
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteAd(BuildContext context, {int id}) async {
    try {
      progressRatio.changeprogressRatio("Deleting...");
      showLoadingContext(context);
      Response response = await Dio().delete(
        "$baseUrl/ad/$id",
        options: Options(
            headers: {"apiToken": userController.userModel.apiToken},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
      );
      if (response.data['status'] == 200) {
        Navigator.pop(context);
        print(response.data);
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<AdModel> addComment(BuildContext context,
      {int adId, String comment}) async {
    try {
      progressRatio.changeprogressRatio("0.0");
      showLoadingContext(context);
      Response response = await Dio().post("$baseUrl/comment",
          data: {"ad_id": adId, "comment": comment},
          options: Options(
              headers: {"apiToken": userController.userModel.apiToken},
              validateStatus: (s) => true,
              receiveDataWhenStatusError: true), onSendProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        AdModel ad = AdModel.fromJson(response.data['data']);
        Navigator.pop(context);
        print(response.data);
        return ad;
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteComment(BuildContext context, {int id}) async {
    try {
      progressRatio.changeprogressRatio("حذف...");
      showLoadingContext(context);
      Response response = await Dio().delete(
        "$baseUrl/comment/$id",
        options: Options(
            // headers: {"apiToken": userController.userModel.apiToken},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
      );
      if (response.data['status'] == 200) {
        Navigator.pop(context);
        print(response.data);
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future addToFav(BuildContext context, {int adId, bool status}) async {
    try {
      // progressRatio.changeprogressRatio("0.0");
      // showLoadingContext(context);
      Response response = await Dio().post(
        "$baseUrl/favourite",
        data: {"ad_id": adId},
        options: Options(
            headers: {"apiToken": userController.userModel.apiToken},
            validateStatus: (s) => true,
            receiveDataWhenStatusError: true),
        //          onSendProgress: (sent, total) {
        //   progressRatio
        //       .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
        // }
      );
      if (response.data['status'] == 200) {
        // Navigator.pop(context);
        print(response.data);
        Fluttertoast.showToast(
            msg: status
                ? ""
                : "");
      } else if (response.data['status'] == 400) {
        // Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future rateAdOwner(BuildContext context, {int ratedId, double rate}) async {
    try {
      progressRatio.changeprogressRatio("0.0");
      showLoadingContext(context);
      Response response = await Dio().post("$baseUrl/rate",
          data: {"rated_id": ratedId, "rate": rate, "comment": ""},
          options: Options(
              headers: {"apiToken": userController.userModel.apiToken},
              validateStatus: (s) => true,
              receiveDataWhenStatusError: true), onSendProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        Navigator.pop(context);
        print(response.data);
        Fluttertoast.showToast(msg: "Rated Succefully");
      } else if (response.data['status'] == 400) {
        Navigator.pop(context);

        showMSG(context, "Alert", response.data['msg'],
            richAlertType: RichAlertType.WARNING);
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
        await userController.logOut(context);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<AdModel>> getFavAds({BuildContext context}) async {
    try {
      List<AdModel> _ads = [];
      Response response = await Dio().get("$baseUrl/favourite",
          options: Options(
              headers: {"apiToken": userController.userModel.apiToken}));
      if (response.data['status'] == 200) {
        for (Map<String, dynamic> ad in response.data['data'])
          _ads.add(AdModel.fromJson(ad));

        return _ads;
      } else if (response.data['status'] == 400) {
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}

AdController adController = AdController();

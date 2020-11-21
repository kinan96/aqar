import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeBodyController{
 Future<List<AdModel>> search({GlobalKey<ScaffoldState>sc,String title,int cityId,String sort,int skip}) async {
    try {
      String _url="$baseUrl/ad?title=${title!=null?title.trim():""}&city_id=${(cityId==null||cityId==0)?"":cityId}&sort=${(sort==null||sort=="all")?"":sort}";
              List<AdModel>_adResult=[];
      Response response = await Dio().get(_url,
          options: Options(
            headers: {"skip":skip},
              receiveDataWhenStatusError: true, validateStatus: (i) => true),
          onReceiveProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
       print(response);
      if (response.data['status'] == 200) {
               print(response.data);
for(Map<String,dynamic>ad in response.data['data'])
_adResult.add(AdModel.fromSearchList(ad));
return _adResult;
      } else if (response.data['status'] == 400) {
        if(sc!=null)
        sc.currentState.showSnackBar(SnackBar(content: Text(response.data['msg'].toString())));
;
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
   return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<String>> getSlider(BuildContext context) async {
    try {
              List<String>_images=[];
      Response response = await Dio().get("$baseUrl/slider",
          options: Options(
              receiveDataWhenStatusError: true, validateStatus: (i) => true),
          onReceiveProgress: (sent,total){
            progressRatio.changeprogressRatio("${(sent/total*100).toStringAsFixed(0)}");
          });
      if (response.data['status'] == 200) {
for(Map<String,dynamic>image in response.data['data'])
_images.add(image['image']);
return _images;
      } else if (response.data['status'] == 400) {
      showMSG(context, "Error", response.data['msg'].toString())
;
      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");

 await userController.logOut(context);
      }
   return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }


}
HomeBodyController homeBodyController=HomeBodyController();
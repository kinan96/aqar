import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/filterController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeBodyController {
  int _intOfPrice(int i) {
    if(i==null)
    return null;
    else
    if (i == 0)
      return 0;
    else if (i > 0 && i < 110)
      return (i * 1000).toInt();
    else if (i > 100 && i < 190)
      return ((i - 90) * 10000).toInt();
    else if (i == 190)
      return 1000000;
    else if (i > 190 && i < 290)
      return (10000000 + (((i - 200) / 10 + 1) * 100000)).toInt();
    else if (i > 280 && i < 380)
      return (((i - 280) / 10 + 1) * 1000000).toInt();
    else
      return null;
  }

  int _intOfArea(int i) {
    if(i==null)
    return null;
    else
    if (i == 0)
      return 0;
    else if (i < 5100)
      return i;
    else
      return null;
  }

  int _intOfAge(int i) {
    if(i==null)
    return null;
    else
    if (i == 0)
      return 0;
    else if (i < 11)
      return i;
      else if(i<19)
      return ((i-10)*5)+10;
    else
      return null;
  }

  int _intOfMeterPrice(int i) {
    if(i==null)
    return null;
    else
    if (i == 0)
      return 0;
    else if (i < 3100)
      return i;
    else
      return null;
  }

  Future<List<AdModel>> search(
      {GlobalKey<ScaffoldState> sc,
      String title,
      int cityId,
      String sort,
      int skip}) async {
    try {
      String _url =
          "$baseUrl/ad?title=${title != null ? title.trim() : ""}&city_id=${(cityId == null || cityId == 0) ? "" : cityId}&building_type=${filterController.propertyType??""}&property_type=${filterController.rentOrSale??""}&min_price=${_intOfPrice(filterController.priceFrom)==0?"":_intOfPrice(filterController.priceFrom)??""}&max_price=${_intOfPrice(filterController.priceTo)==0?"":_intOfPrice(filterController.priceTo)??""}&min_bath=${filterController.bathFrom==0?"":filterController.bathFrom??""}&max_bath=${filterController.bathTo??""}&min_room=${filterController.roomFrom==0?"":filterController.roomFrom??""}&max_room=${filterController.roomTo??""}&min_meter_price=${_intOfMeterPrice(filterController.meterPriceFrom)==0?"":_intOfMeterPrice(filterController.meterPriceFrom)??""}&max_meter_price=${_intOfMeterPrice(filterController.meterPriceTo)??""}&min_area=${_intOfArea(filterController.areaFrom)==0?"":_intOfArea(filterController.areaFrom)??""}&max_area=${_intOfArea(filterController.areaTo)??""}&min_building_age=${_intOfAge(filterController.ageFrom)==0?"":_intOfAge(filterController.ageFrom)??""}&max_building_age=${_intOfAge(filterController.ageTo)==0?"":_intOfAge(filterController.ageTo)??""}&social_status=${filterController.familyOrSingle==null?"":filterController.familyOrSingle}&lift=${filterController.lift==null?"":filterController.lift?"Yes":"No"}&garage=${filterController.garage==null?"":filterController.garage?"Yes":"No"}&pool=${filterController.pool==null?"":filterController.pool?"Yes":"No"}&kitchen=${filterController.kitchen==null?"":filterController.kitchen?"Yes":"No"}";
      List<AdModel> _adResult = [];
      print(_url);
      filterController.changeadsAfterFilter(null);
      Response response = await Dio().get(_url,
          options: Options(
              headers: {"skip": skip},
              receiveDataWhenStatusError: true,
              validateStatus: (i) => true), onReceiveProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      print(response);
      if (response.data['status'] == 200) {
        print(response.data);
        for (Map<String, dynamic> ad in response.data['data'])
          _adResult.add(AdModel.fromSearchList(ad));
        filterController.changeadsAfterFilter(_adResult);
        return _adResult;
      } else if (response.data['status'] == 400) {
        if (sc != null)
          sc.currentState.showSnackBar(
              SnackBar(content: Text(response.data['msg'].toString())));
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
      List<String> _images = [];
      Response response = await Dio().get("$baseUrl/slider",
          options: Options(
              receiveDataWhenStatusError: true,
              validateStatus: (i) => true), onReceiveProgress: (sent, total) {
        progressRatio
            .changeprogressRatio("${(sent / total * 100).toStringAsFixed(0)}");
      });
      if (response.data['status'] == 200) {
        for (Map<String, dynamic> image in response.data['data'])
          _images.add(image['image']);
        return _images;
      } else if (response.data['status'] == 400) {
        showMSG(context, "Error", response.data['msg'].toString());
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

HomeBodyController homeBodyController = HomeBodyController();

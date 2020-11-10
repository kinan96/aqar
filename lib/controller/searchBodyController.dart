import 'package:aqar/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rxdart/rxdart.dart';

class SearchBodyController {
  List<CityModel> cities;
  BehaviorSubject<List<Marker>> _searchedListOfAdMarkers =
      BehaviorSubject<List<Marker>>();
  Function(List<Marker>) get changesearchedListOfAdMarkers =>
      _searchedListOfAdMarkers.sink.add;
  List<Marker> get searchedListOfAdMarkers => _searchedListOfAdMarkers.value;
  Stream<List<Marker>> get searchedListOfAdMarkersStream =>
      _searchedListOfAdMarkers.stream;
  BehaviorSubject<bool> _loading = BehaviorSubject<bool>();
  Function(bool) get changeloading => _loading.sink.add;
  bool get loading => _loading.value;
  Stream<bool> get loadingStream => _loading.stream;
  BehaviorSubject<bool> _backToCities = BehaviorSubject<bool>();
  Function(bool) get changebackToCities => _backToCities.sink.add;
  bool get backToCities => _backToCities.value;
  Stream<bool> get backToCitiesStream => _backToCities.stream;


  BehaviorSubject<int> _searchCategoryIdFilter = BehaviorSubject<int>();
  Function(int) get changesearchCategoryIdFilter =>
      _searchCategoryIdFilter.sink.add;
  int get searchCategoryIdFilter => _searchCategoryIdFilter.value;
  Stream<int> get searchCategoryIdFilterStream =>
      _searchCategoryIdFilter.stream;
  BehaviorSubject<int> _searchCityIdFilter = BehaviorSubject<int>();
  Function(int) get changesearchCityIdFilter => _searchCityIdFilter.sink.add;
  int get searchCityIdFilter => _searchCityIdFilter.value;
  Stream<int> get searchCityIdFilterStream => _searchCityIdFilter.stream;
  BehaviorSubject<String> _searchOrderIdFilter = BehaviorSubject<String>();
  Function(String) get changesearchOrderIdFilter =>
      _searchOrderIdFilter.sink.add;
  String get searchOrderIdFilter => _searchOrderIdFilter.value;
  Stream<String> get searchOrderIdFilterStream => _searchOrderIdFilter.stream;
  BehaviorSubject<List<Widget>> _searchedListOfAds =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get changesearchedListOfAds =>
      _searchedListOfAds.sink.add;
  List<Widget> get searchedListOfAds => _searchedListOfAds.value;
  Stream<List<Widget>> get searchedListOfAdsStream => _searchedListOfAds.stream;
  BehaviorSubject<int> _searchedCount = BehaviorSubject<int>();
  Function(int) get changesearchedCount => _searchedCount.sink.add;
  int get searchedCount => _searchedCount.value;
  Stream<int> get searchedCountStream => _searchedCount.stream;
  BehaviorSubject<bool> _fromCategoryPage = BehaviorSubject<bool>();
  Function(bool) get changefromCategoryPage => _fromCategoryPage.sink.add;
  bool get fromCategoryPage => _fromCategoryPage.value;
  Stream<bool> get fromCategoryPageStream => _fromCategoryPage.stream;
  dispose() {
    _searchedListOfAdMarkers.close();
    _searchedListOfAds.close();
    _fromCategoryPage.close();
    _searchedCount.close();
    _backToCities.close();
    _searchCategoryIdFilter.close();
    _searchCityIdFilter.close();
    _loading.close();
    _searchOrderIdFilter.close();
  }

  }



SearchBodyController searchBodyController = SearchBodyController();
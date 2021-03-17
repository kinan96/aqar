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

  BehaviorSubject<double> _mapZoom = BehaviorSubject<double>();
  Function(double) get changemapZoom => _mapZoom.sink.add;
  double get mapZoom => _mapZoom.value;
  Stream<double> get mapZoomStream => _mapZoom.stream;


  BehaviorSubject<int> _searchCityIdFilter = BehaviorSubject<int>();
  Function(int) get changesearchCityIdFilter => _searchCityIdFilter.sink.add;
  int get searchCityIdFilter => _searchCityIdFilter.value;
  Stream<int> get searchCityIdFilterStream => _searchCityIdFilter.stream;
  BehaviorSubject<List<Widget>> _searchedListOfAds =
      BehaviorSubject<List<Widget>>();
  Function(List<Widget>) get changesearchedListOfAds =>
      _searchedListOfAds.sink.add;
  dispose() {
    _searchedListOfAdMarkers.close();
    _searchedListOfAds.close();
    _backToCities.close();
    _searchCityIdFilter.close();
    _loading.close();
    _mapZoom.close();
  }

  }



SearchBodyController searchBodyController = SearchBodyController();
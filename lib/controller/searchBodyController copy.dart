import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:loading_animations/loading_animations.dart';
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
  dispose() {
    _searchedListOfAdMarkers.close();
    _backToCities.close();
    _loading.close();
  }
}

SearchBodyController searchBodyController = SearchBodyController();

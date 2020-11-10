import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/categoryModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:rxdart/rxdart.dart';

class SearchBodyController {
  List<CategoryModel> categories;
  List<CityModel> cities;
  Map<String, String> arrange = {
    "all": "الكل",
    "new": "الأحدث",
    "old": "الأقدم",
    "rate": "الأعلى تقييماً"
  };
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

  Future<List<Widget>> getCategories(
      {BuildContext context,
      TextEditingController textEditingController}) async {
    try {
      if (searchBodyController.categories != null) {
        return [
          FilterListTile(
            text: "الكل",
            filterStream: searchBodyController.searchCategoryIdFilterStream,
            sinkToStream: searchBodyController.changesearchCategoryIdFilter,
            id: 0,
            onSelect: () async {
              Navigator.pop(context);
              searchBodyController.changesearchedListOfAds([
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingBouncingGrid.square(),
                  ),
                )
              ]);
              List _searched = await homeBodyController.search(
                  cityId: searchBodyController.searchCityIdFilter,
                  title: textEditingController.text,
                  sort: searchBodyController.searchOrderIdFilter);
              searchBodyController.changesearchedListOfAds(List.generate(
                  _searched[1].length,
                  (index) => CustomAdCard(adModel: _searched[1][index])));
              searchBodyController.changesearchedCount(_searched[0]);
            },
          )
        ]..addAll(List.generate(
            searchBodyController.categories.length,
            (index) => FilterListTile(
                  text: searchBodyController.categories[index].name,
                  filterStream:
                      searchBodyController.searchCategoryIdFilterStream,
                  id: searchBodyController.categories[index].id,
                  onSelect: () async {
                    Navigator.pop(context);
                    searchBodyController.changesearchedListOfAds([
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LoadingBouncingGrid.square(),
                        ),
                      )
                    ]);
                    List _searched = await homeBodyController.search(
                        cityId: searchBodyController.searchCityIdFilter,
                        title: textEditingController.text,
                        sort: searchBodyController.searchOrderIdFilter);
                    searchBodyController.changesearchedListOfAds(List.generate(
                        _searched[1].length,
                        (index) => CustomAdCard(adModel: _searched[1][index])));
                    searchBodyController.changesearchedCount(_searched[0]);
                  },
                  sinkToStream:
                      searchBodyController.changesearchCategoryIdFilter,
                )));
      }

      List<CategoryModel> _categories = [];
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
          _categories.add(CategoryModel.fromJson(cat));
        searchBodyController.categories = _categories;
        return [
          FilterListTile(
            text: "الكل",
            filterStream: searchBodyController.searchCategoryIdFilterStream,
            sinkToStream: searchBodyController.changesearchCategoryIdFilter,
            id: 0,
            onSelect: () async {
              Navigator.pop(context);
              searchBodyController.changesearchedListOfAds([
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingBouncingGrid.square(),
                  ),
                )
              ]);
              List _searched = await homeBodyController.search(
                  cityId: searchBodyController.searchCityIdFilter,
                  title: textEditingController.text,
                  sort: searchBodyController.searchOrderIdFilter);
              searchBodyController.changesearchedListOfAds(List.generate(
                  _searched[1].length,
                  (index) => CustomAdCard(adModel: _searched[1][index])));
              searchBodyController.changesearchedCount(_searched[0]);
            },
          )
        ]..addAll(List.generate(
            _categories.length,
            (index) => FilterListTile(
                  text: _categories[index].name,
                  filterStream:
                      searchBodyController.searchCategoryIdFilterStream,
                  id: _categories[index].id,
                  onSelect: () async {
                    Navigator.pop(context);
                    searchBodyController.changesearchedListOfAds([
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LoadingBouncingGrid.square(),
                        ),
                      )
                    ]);
                    List _searched = await homeBodyController.search(
                        cityId: searchBodyController.searchCityIdFilter,
                        title: textEditingController.text,
                        sort: searchBodyController.searchOrderIdFilter);

                    searchBodyController.changesearchedListOfAds(List.generate(
                        _searched[1].length,
                        (index) => CustomAdCard(adModel: _searched[1][index])));
                    searchBodyController.changesearchedCount(_searched[0]);
                  },
                  sinkToStream:
                      searchBodyController.changesearchCategoryIdFilter,
                )));
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

  Future<List<Widget>> getListOfCites(
      {BuildContext context,
      TextEditingController textEditingController}) async {
    List<CityModel> _cities = [];
    try {
      if (searchBodyController.cities != null) {
        return [
          FilterListTile(
            text: "الكل",
            filterStream: searchBodyController.searchCityIdFilterStream,
            sinkToStream: searchBodyController.changesearchCityIdFilter,
            id: 0,
            onSelect: () async {
              Navigator.pop(context);
              searchBodyController.changesearchedListOfAds([
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LoadingBouncingGrid.square(),
                  ),
                )
              ]);
              List _searched = await homeBodyController.search(
                  cityId: searchBodyController.searchCityIdFilter,
                  title: textEditingController.text,
                  sort: searchBodyController.searchOrderIdFilter);
              searchBodyController.changesearchedListOfAds(List.generate(
                  _searched[1].length,
                  (index) => CustomAdCard(adModel: _searched[1][index])));
              searchBodyController.changesearchedCount(_searched[0]);
            },
          )
        ]..addAll(List.generate(
            searchBodyController.cities.length,
            (index) => FilterListTile(
                  text: searchBodyController.cities[index].name,
                  filterStream: searchBodyController.searchCityIdFilterStream,
                  sinkToStream: searchBodyController.changesearchCityIdFilter,
                  id: searchBodyController.cities[index].id,
                  onSelect: () async {
                    Navigator.pop(context);
                    searchBodyController.changesearchedListOfAds([
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LoadingBouncingGrid.square(),
                        ),
                      )
                    ]);
                    List _searched = await homeBodyController.search(
                        cityId: searchBodyController.searchCityIdFilter,
                        title: textEditingController.text,
                        sort: searchBodyController.searchOrderIdFilter);
                    searchBodyController.changesearchedListOfAds(List.generate(
                        _searched[1].length,
                        (index) => CustomAdCard(adModel: _searched[1][index])));
                    searchBodyController.changesearchedCount(_searched[0]);
                  },
                )));
      }
      Response response = await Dio().get("$baseUrl/city");
      if (response.data['status'] == 200) {
        for (Map<String, dynamic> city in response.data['data'])
          _cities.add(CityModel.fromJson(city));
        searchBodyController.cities = _cities;
      } else {}
    } catch (e) {}
    return [
      FilterListTile(
        text: "الكل",
        filterStream: searchBodyController.searchCityIdFilterStream,
        sinkToStream: searchBodyController.changesearchCityIdFilter,
        id: 0,
        onSelect: () async {
          Navigator.pop(context);
          searchBodyController.changesearchedListOfAds([
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LoadingBouncingGrid.square(),
              ),
            )
          ]);
          List _searched = await homeBodyController.search(
              cityId: searchBodyController.searchCityIdFilter,
              title: textEditingController.text,
              sort: searchBodyController.searchOrderIdFilter);
          searchBodyController.changesearchedListOfAds(List.generate(
              _searched[1].length,
              (index) => CustomAdCard(adModel: _searched[1][index])));
          searchBodyController.changesearchedCount(_searched[0]);
        },
      )
    ]..addAll(List.generate(
        _cities.length,
        (index) => FilterListTile(
              text: _cities[index].name,
              filterStream: searchBodyController.searchCategoryIdFilterStream,
              id: _cities[index].id,
              onSelect: () async {
                Navigator.pop(context);
                searchBodyController.changesearchedListOfAds([
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingBouncingGrid.square(),
                    ),
                  )
                ]);
                List _searched = await homeBodyController.search(
                    cityId: searchBodyController.searchCityIdFilter,
                    title: textEditingController.text,
                    sort: searchBodyController.searchOrderIdFilter);
                searchBodyController.changesearchedListOfAds(List.generate(
                    _searched[1].length,
                    (index) => CustomAdCard(adModel: _searched[1][index])));
                searchBodyController.changesearchedCount(_searched[0]);
              },
              sinkToStream: searchBodyController.changesearchCategoryIdFilter,
            )));
  }
}

SearchBodyController searchBodyController = SearchBodyController();

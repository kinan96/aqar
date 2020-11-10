import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:loading_animations/loading_animations.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with TickerProviderStateMixin {
  initState() {
    _getCities();
    super.initState();
  }

  _getCities() async {
        searchBodyController.changebackToCities(false);
    searchBodyController.changeloading(true);
    List<CityModel> _city = await userController.getListOfCites(_sc);

    if (mounted) if (_city != null && _city.length > 0)
      setState(() {
        searchBodyController.changeloading(false);
        _markers = List.generate(
            _city.length,
            (index) => homeMarker(
                cityModel: _city[index],
                connect: true,
                context: context,
                hasStatus: false,
                onPressed: () async {
                
                }));
                searchBodyController.changesearchedListOfAdMarkers(_markers);
                                      searchBodyController.changebackToCities(false);
        _cityMarkers = _markers;
      });
  }

  List<Marker> _cityMarkers;
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  DateTime _now;
  DateTime _nextTime;
  // Future<Position> _getCurrentLocation() async {
  //   Position position =
  //       await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //   return position;
  // }
  MapController _mapController = MapController();
  LatLng _center = LatLng(24.774265, 46.738586);
  double _zoom = 4.5;
  List<Marker> _markers = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_now == null) {
            if (mounted)
              setState(() {
                _now = DateTime.now();
              });
          } else if (mounted)
            setState(() {
              _nextTime = DateTime.now();
            });
          if (_nextTime != null && _now != null) {
            var dif = _nextTime.difference(_now);
            if (mounted)
              setState(() {
                _now = null;
                _nextTime = null;
              });
            if (dif.inMilliseconds < 1000) whenExitDialog(context);

            print(dif.inMilliseconds);
          }
          return Future.value(false);
        },
        child: Scaffold(
          body: StreamBuilder<bool>(
            stream: searchBodyController.backToCitiesStream,
            initialData: false,
            builder: (context, back) => StreamBuilder<bool>(
                stream: searchBodyController.loadingStream,
                initialData: false,
                builder: (context, load) => Stack(
                      children: [
                        StreamBuilder<List<Marker>>(
                            stream: searchBodyController
                                .searchedListOfAdMarkersStream,
                            initialData: [],
                            builder: (context, snapshot) {
                              return FlutterMap(
                                mapController: _mapController,
                                options: new MapOptions(
                                  center: _center,
                                  zoom: _zoom,
                                ),
                                layers: [
                                  new TileLayerOptions(
                                      urlTemplate:
                                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                      subdomains: ['a', 'b', 'c']),
                                  new MarkerLayerOptions(
                                      markers: snapshot.hasData &&
                                              snapshot.data.length > 0
                                          ? snapshot.data
                                          : _markers),
                                ],
                              );
                            }),
                        load.data
                            ? Center(
                                child: LoadingBouncingGrid.circle(
                                  backgroundColor: Colors.blue,
                                ),
                              )
                            : SizedBox(),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: back.data ? 1 : 0,
                            child: !back.data
                                ? SizedBox()
                                : IconButton(
                                      icon:Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child:  Icon(
                                        Icons.arrow_back_ios,
                                        size: 25,
                                        color: Colors.blue,
                                      )),
                                      onPressed: back.data
                                          ? () {
                                              searchBodyController
                                                  .changesearchCityIdFilter(null);
                                              searchBodyController
                                                  .changesearchedListOfAdMarkers(
                                                      _cityMarkers);
                                              if (mounted)
                                                setState(() {
                                                  _mapController.move(
                                                      _center, _zoom);
                                                  searchBodyController
                                                      .changebackToCities(false);
                                                });
                                            }
                                          : null),
                                ),
                          ),
                        
                      ],
                    )),
          ),
        ));
  }
}

Marker homeMarker(
    {CityModel cityModel,
    Function onPressed,
    bool connect,
    bool hasStatus,
    BuildContext context}) {
  return Marker(
    width: 50,
    height: 50,
    point:
      cityModel.latLng,
    builder: (ctx) => InkWell(
      onTap: onPressed,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          child: Text(
          cityModel.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.deepPurple[900],
                fontSize: 10,
                fontWeight: FontWeight.bold),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.blue[100],
            borderRadius: BorderRadius.all(Radius.circular(90)),
          )),
    ),
  );
}


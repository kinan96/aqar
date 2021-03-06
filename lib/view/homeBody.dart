import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/adPage.dart';
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
                  searchBodyController
                      .changesearchCityIdFilter(_city[index].id);
                  searchBodyController.changemapZoom(11);
                  _mapController.move(_city[index].latLng, 11);

                  if (mounted)
                    setState(() {
                      _markers = [];
                      searchBodyController.changeloading(true);
                      searchBodyController.changebackToCities(true);
                    });
                  List<AdModel> ads = await homeBodyController.search(
                      cityId: _city[index].id, sc: _sc);
                  searchBodyController.changeloading(false);
                  setState(() {
                    _markers = List.generate(
                        ads.length,
                        (index) => homeMarker(
                            adModel: ads[index],
                            connect: true,
                            context: context,
                            hasStatus: false,
                            onPressed: () async {}));

                    searchBodyController
                        .changesearchedListOfAdMarkers(_markers);
                  });
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
  MapController _mapController = MapController();
  LatLng _center = LatLng(24.774265, 46.738586);
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
                        StreamBuilder(
                          stream: searchBodyController.mapZoomStream,
                          initialData: 4.5,
                          builder: (context, zoom) =>
                              StreamBuilder<List<Marker>>(
                                  stream: searchBodyController
                                      .searchedListOfAdMarkersStream,
                                  initialData: [],
                                  builder: (context, snapshot) {
                                    return FlutterMap(
                                      mapController: _mapController,
                                      options: new MapOptions(
                                        center: _center,
                                        zoom: zoom.data,
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
                        ),
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
                                    icon: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Icon(
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
                                                searchBodyController
                                                    .changemapZoom(4.5);
                                                _mapController.move(
                                                    _center, 4.5);
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
    AdModel adModel,
    Function onPressed,
    bool connect,
    bool hasStatus,
    BuildContext context}) {
  return Marker(
    width: 50,
    height: 50,
    point:
        adModel != null ? LatLng(adModel.lat, adModel.lng) : cityModel.latLng,
    builder: (ctx) => InkWell(
      onTap: adModel != null
          ? () {
            print("object");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdPage(
                            adModel: adModel,
                          )));
            }
          : onPressed,
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          child: Text(
            adModel != null ? "${adModel.price} S.R" : cityModel.name,
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

class CustomAdCard extends StatelessWidget {
  AdModel adModel;
  CustomAdCard({
    this.adModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: MediaQuery.of(context).size.width / 3 ,
      decoration: BoxDecoration(
        color: appDesign.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdPage(
                        adModel: adModel,
                      )));
        },
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Image(
                image: NetworkImage(
                  adModel != null
                      ? adModel.image != null
                          ? adModel.image
                          : adModel.images.first
                      : "https://cdn.wallpapersafari.com/35/57/5Qupky.png",
                ),
                width: MediaQuery.of(context).size.width / 3 -20,
                height: MediaQuery.of(context).size.width / 3,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                   Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                adModel != null ? adModel.title : "",
                                size: 20,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2,),
                  Expanded(
                    child: Row(
                      children: [
                       
                        Expanded(
                          child: adModel.meterPrice == null
                              ? Column(
                                  children: [
                                    TitleAndDiscripWidget(
                                      titleText: "Number of Rooms",
                                      discripText: adModel.room,
                                      heightSpace: 0,
                                                                            discripSize: 14,

                                      titleSize: 11,
                                    ),
                                    TitleAndDiscripWidget(
                                      titleText: "Number of Baths",
                                      titleSize: 11,
                                                                            discripSize: 14,

                                      heightSpace: 0,
                                      discripText: adModel.bath,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                     TitleAndDiscripWidget(
                                      titleText: "Meter Price",
                                      discripText: adModel.meterPrice.toString(),
                                      heightSpace: 0,
                                                                            discripSize: 14,

                                      titleSize: 11,
                                    ),
                                    TitleAndDiscripWidget(
                                      titleText: "Land Type",
                                      titleSize: 11,
                                      heightSpace: 0,
                                      discripSize: 14,
                                      discripText: adModel.landType,
                                    ),
                                  ],
                                ),
                        ),
                         Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                           
                            
                              Row(
                                children: [
                                  Text(
                                   "for ",
                                   style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                  ),
                                  Expanded(
                                    child: CustomText(
                                      adModel != null ? adModel.propertyType ?? "" : "",
                                      size: 14,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ), Spacer(),   Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: appDesign.hint,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      adModel != null ? adModel.city.name : "",
                                      maxLines: 1,
                                    
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        height: 1,
                                        color: appDesign.hint,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                           
                                    Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    adModel != null
                                        ? adModel.price.toString()
                                        : "0.0",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),SizedBox(width: 5,),
                                  Text(
                                   adModel.propertyType=="Rent"?"S.R/Year" :"S.R",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

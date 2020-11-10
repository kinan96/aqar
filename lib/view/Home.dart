import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/homeController.dart';
import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/categoryModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/allAdsPage.dart';
import 'package:aqar/view/chat.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/favouriteAds.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:aqar/view/moreBody.dart';
import 'package:aqar/view/pleaseSignUp.dart';
import 'package:aqar/view/pleaseSignUpBody.dart';
import 'package:aqar/view/profileBody.dart';
import 'package:aqar/view/searchBody.dart';
import 'package:aqar/view/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rich_alert/rich_alert.dart';
import 'addAdPage.dart';
import 'allNotificationsPage.dart';

class Home extends StatefulWidget {
  int index;
  Home({this.index});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    _getCities() async {
        searchBodyController.changebackToCities(false);
    searchBodyController.changeloading(true);
    List<CityModel> _city = await userController.getListOfCites(_scaffold);

    if (mounted) if (_city != null && _city.length > 0)
      setState(() {
        searchBodyController.changeloading(false);
   List<Marker>     _markers = List.generate(
            _city.length,
            (index) => homeMarker(
                cityModel: _city[index],
                connect: true,
                context: context,
                hasStatus: false,
                onPressed: () async {
                  searchBodyController
                      .changesearchCityIdFilter(_city[index].id);
                  if (mounted)
                    setState(() {
                      searchBodyController.changeloading(true);
                      searchBodyController.changebackToCities(true);
                    });
                  List ads = await homeBodyController.search(
                      cityId: _city[index].id, sc: _scaffold);
                      searchBodyController.changeloading(false);
                 List<Marker>   _markers = List.generate(
                        ads[1].length,
                        (index) => homeMarker(
                            adModel: ads[1][index],
                            connect: true,
                            context: context,
                            hasStatus: false,
                            onPressed: () async {}));
                    searchBodyController
                        .changesearchedListOfAdMarkers(_markers);
                }));
                searchBodyController.changesearchedListOfAdMarkers(_markers);
                                      searchBodyController.changebackToCities(false);
      });
  }

  initState() {
                searchBodyController.changebackToCities(false);
    searchBodyController.changeloading(false);
    _pageController = PageController(initialPage: widget.index ?? 0);
    _pageIndex = widget.index ?? 0;
    homeController.changeSelectedBNBItem(_pageIndex);
    super.initState();
  }

  DateTime _now;
  DateTime _nextTime;
  String _searchKey;
  Future<bool> _onWillPop() async {
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
  }

  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  TextEditingController _searchCTL = TextEditingController();
  int _pageIndex;
  List<String> _titles = ["Aqar Application", "Chat"];
  PageController _pageController;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: _scaffold,
          drawer: CustomDrawer(
            scaffold: _scaffold,
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(_pageIndex == 0 ? 120 : 60),
            child: Container(
              color: Colors.blue,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _scaffold.currentState.openDrawer();
                          }),
                      Text(
                        _titles[_pageIndex],
                        style: TextStyle(
                            color: Colors.white,
                            height: 2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      NotificationsWidget()
                    ],
                  ),
                  _pageIndex == 0
                      ? CustomTextFormField(
                          controller: _searchCTL,
                          onSaved: (v) async {
                            searchBodyController.changeloading(true);
                            List ads = await homeBodyController.search(
                                cityId: searchBodyController.searchCityIdFilter,
                                title: _searchCTL.text,
                                sc: _scaffold);
                            searchBodyController.changeloading(false);
                            searchBodyController.changebackToCities(true);
                            List<Marker> _markers = List.generate(
                                ads[1].length,
                                (index) => homeMarker(
                                    adModel: ads[1][index],
                                    connect: true,
                                    context: context,
                                    hasStatus: false,
                                    onPressed: () async {}));
                            searchBodyController
                                .changesearchedListOfAdMarkers(_markers);
                          },
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllAdsPage()));
                              },
                              child: Icon(Icons.filter_list,
                                  color: Colors.blueAccent),
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.search, color: Colors.lightBlue),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
          body: StreamBuilder<int>(
              stream: homeController.selectedBNBItemStream,
              initialData: 0,
              builder: (context, index) {
                switch (index.data) {
                  case 0:
                    return HomeBody();
                    break;
                  case 1:
                    return AllChats();
                    break;

                  default:
                    return HomeBody();
                }
              }),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (userController.userModel == null)
                  showModalBottomSheet(
                      context: context, builder: (context) => PleaseSignUp());
                else
                  _scaffold.currentState.showBottomSheet((context) => Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Choose Your Advertising Type",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddAdPage(
                                                  type: "land",
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.pin_drop),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Land",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddAdPage(
                                                  type: "Property",
                                                )));
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.business),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Vella or Apartment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            )
                          ],
                        ),
                      ));
                // Navigator.push(context,MaterialPageRoute(builder: (context)=>AddAdPage()));
              },
              child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                CustomBottomNavigationBarItem(
                  imageAsset: 'assets/images/home.png',
                  index: 0,
                  onTap: ()async {
                    setState(() {
                      homeController.changeSelectedBNBItem(0);
                      _pageIndex = 0;
                    });
                    await _getCities();
                  },
                ),
                CustomBottomNavigationBarItem(
                  iconData: Icons.chat,
                  index: 1,
                  onTap: () {
                    setState(() {
                      homeController.changeSelectedBNBItem(1);
                      _pageIndex = 1;
                    });
                  },
                ),
                // CustomBottomNavigationBarItem(
                //   imageAsset: 'assets/images/profile.png',
                //   index: 2,
                //   onTap: () {
                //     setState(() {
                //       homeController.changeSelectedBNBItem(2);
                //       _pageIndex = 2;
                //     });
                //   },
                // ),
                // CustomBottomNavigationBarItem(
                //   imageAsset: 'assets/images/more.png',
                //   index: 3,
                //   onTap: () {
                //     setState(() {
                //       homeController.changeSelectedBNBItem(3);
                //       _pageIndex = 3;
                //     });
                //   },
                // ),
              ],
            ),
          )),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffold;
  CustomDrawer({
    Key key,
    this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                // Text('Main Menu'),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      'assets/images/logo.png',
                      // width: MediaQuery.of(context).size.width / 2,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.crop_landscape, color: Colors.lightBlue),
            title: Text(
              'All Properties',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AllAdsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.lightBlue),
            title: Text(
              'New Property',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              if (userController.userModel == null)
                showModalBottomSheet(
                    context: context, builder: (context) => PleaseSignUp());
              else {
                Navigator.pop(context);
                scaffold.currentState.showBottomSheet((context) => Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Choose Your Advertising Type",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddAdPage(
                                                type: "land",
                                              )));
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.pin_drop),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Land",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              )),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddAdPage(
                                                type: "Property",
                                              )));
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.business),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Vella or Apartment",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.lightBlue),
            title: Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileBody()));
            },
          ),
                    ListTile(
            leading: Icon(Icons.favorite, color: Colors.lightBlue),
            title: Text(
              'Favourite Properties',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FavouriteAds()));
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.lightBlue),
            title: Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              if (userController.userModel == null)
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignIn()));
              else
                showMSG(context, "Alert", "Do you want logOut ?",
                    richAlertType: RichAlertType.ERROR,
                    actions: [
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: RaisedButton(
                                child: Text("Yes"),
                                onPressed: () async {
                                  await userController.logOut(context);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: RaisedButton(
                                child: Text("No"),
                                color: Colors.white,
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ]);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AllAdsPage extends StatefulWidget {
  String title;
  AllAdsPage({this.title});
  @override
  _AllAdsPageState createState() => _AllAdsPageState();
}

class _AllAdsPageState extends State<AllAdsPage> {
  @override
  void initState() {
    _search();
    super.initState();
  }

  _search() async {
    List ads = await homeBodyController.search(sc: _sc);
    if (ads != null && mounted) {
      setState(() {
        _ads = ads[1];
      });
    }
  }

  String _type = "";
  String _socialType = "";
  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  List<Widget> _allAds = [];
  List<AdModel> _ads;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sc,
        appBar: buildCustomAppBar(title: widget.title ?? "Ads Filter"),
        body: Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
          child: _ads == null
              ? Center(child: LoadingBouncingGrid.square())
              : _ads.length == 0
                  ? CustomText(
                      "No Ads yet",
                      size: 13,
                      textAlign: TextAlign.center,
                      color: appDesign.hint,
                    )
                  : Column(
                      children: [
                        CustomText("Filters :"),
                        Container(
                          height: 150,
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                                   Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Column(
                            children: [
                              CustomText("Type"),
                              RadioListTile(
                                  value: "Rent",
                                  groupValue: _type,
                                  title: Text("Rent"),
                                  onChanged: (t) {
                                    setState(() {
                                      _type = t;
                                    });
                                  }),
                              RadioListTile(
                                  value: "Own",
                                  groupValue: _type,
                                  title: Text("Own"),
                                  onChanged: (t) {
                                    setState(() {
                                      _type = t;
                                    });
                                  }),
                            ],
                          ),
                        ),/////// 
                           Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Column(
                            children: [
                              CustomText("Family or Single"),
                              RadioListTile(
                                  value: "Family",
                                  groupValue: _socialType,
                                  title: Text("Family"),
                                  onChanged: (t) {
                                    setState(() {
                                      _socialType = t;
                                    });
                                  }),
                              RadioListTile(
                                  value: "Single",
                                  groupValue: _socialType,
                                  title: Text("Single"),
                                  onChanged: (t) {
                                    setState(() {
                                      _socialType = t;
                                    });
                                  }),
                            ],
                          ),
                        ),/////// 
                        
                          ],
                          ),
                        ),
                   
                        Expanded(
                          child: ListView.separated(
                              itemBuilder: (context, i) =>
                                  CustomAdCard(adModel: _ads[i]),
                              separatorBuilder: (context, i) => SizedBox(
                                    height: 0,
                                  ),
                              itemCount: _ads.length),
                        ),
                      ],
                    ),
        ));
  }
}

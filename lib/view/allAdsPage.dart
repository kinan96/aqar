import 'package:aqar/controller/filterController.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AllAdsPage extends StatefulWidget {
  String title;
    bool noAppBar;
  AllAdsPage({this.title,this.noAppBar});
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
    List<AdModel> ads = await homeBodyController.search(sc: _sc);
    if (ads != null && mounted) {
      setState(() {
        filterController.changeadsAfterFilter(ads);
        _ads = ads;
      });
    }
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  List<AdModel> _ads;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _sc,
        appBar:widget.noAppBar!=null?null: buildCustomAppBar(title: widget.title ?? "Ads Filter"),
        body: Padding(
          padding: EdgeInsets.only(top:widget.noAppBar!=null?20: 0, left: 20, right: 20, bottom: 20),
          child:  StreamBuilder<List<AdModel>>(
                    stream: filterController.adsAfterFilterStream,
                    initialData: null,
                    builder: (context, snapshot) {
                      return snapshot.data == null
              ? Center(child: LoadingBouncingGrid.square())
              : snapshot.data.length == 0
                  ? CustomText(
                      "No Ads yet",
                      size: 13,
                      textAlign: TextAlign.center,
                      color: appDesign.hint,
                    )
                  : ListView.separated(
                          itemBuilder: (context, i) =>
                              CustomAdCard(adModel: snapshot.data[i]),
                          separatorBuilder: (context, i) => SizedBox(
                                height: 0,
                              ),
                          itemCount: snapshot.data.length);
                    }
                  ),
        ));
  }
}

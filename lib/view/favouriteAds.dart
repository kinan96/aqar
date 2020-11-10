import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/notificationController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/notificationModel.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:aqar/view/notificationPage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class FavouriteAds extends StatefulWidget {
  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();
}

class _FavouriteAdsState extends State<FavouriteAds> {
  @override
  void initState() {
    _getAdDetails();
    super.initState();
  }
List<Widget>_ads;
  _getAdDetails() async {
    List<AdModel> adModel = await adController.getFavAds();
    if (mounted&&adModel!=null)
      setState(() {
        _ads = List.generate(adModel.length, (index) => CustomAdCard(adModel: adModel[index],));
      });
        

  }
GlobalKey<ScaffoldState>_sc=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sc,
      appBar: buildCustomAppBar(title: "Favourites"),
      body:Padding(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
        child:_ads==null?Center(child: LoadingBouncingGrid.square()):_ads.length==0?CustomText(
               "No Favourite Ad yet",
                  size: 13,
                  textAlign: TextAlign.center,
                  color: appDesign.hint,
                ) :ListView.separated(itemBuilder:(context,i)=> _ads[i], separatorBuilder:(context,i)=>SizedBox(height: 0,), itemCount: _ads.length),
      )
      );
  }
}


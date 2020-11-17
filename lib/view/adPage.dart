import 'dart:io';

import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adOwnerPage.dart';
import 'package:aqar/view/addAdPage.dart';
import 'package:aqar/view/allAdComments.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class AdPage extends StatefulWidget {
  AdModel adModel;
  AdPage({this.adModel});
  @override
  _AdPageState createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {



  AdModel _adModel;
  List<String> _links;
  bool _fav;
  List<Widget> _images;
  @override
  void initState() {
    _getAdDetails();
    super.initState();
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  _getAdDetails() async {
    AdModel adModel = await adController.getAdDetails(_sc, widget.adModel.id);
    if (mounted)
      setState(() {
        _adModel = adModel;
        _links = adModel.images;
        _images = [];
        for (int i = 0; i < _links.length; i++)
          _images.add(InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageViewer(
                            images: _adModel.images,
                            position: i,
                          )));
            },
            child: Image(
              image: NetworkImage(_links[i]),
              
              fit: BoxFit.fill,
            ),
          ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appDesign.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAdImageSlider(
              images: _images,
              fav: widget.adModel.isFavourite,
              adModel: _adModel,
            ),
            _adModel == null
                ? LinearProgressIndicator()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 10),
                        child: CustomText(
                          "Main Details",
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      AdHeaderDetails(
                        price: _adModel.price.toString(),
                        name: _adModel.title,
                        cat: _adModel.meterPrice == null
                            ? _adModel.buildingType
                            : "Land",
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              TitleAndDiscripWidget(
                                titleText: "Description",
                                iconData: Icons.description,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.note,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Type",
                                iconData: Icons.map,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.propertyType,
                              ),
                              CustomText(
                                "Special Details",
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _adModel.meterPrice!= null
                                  ? Column(
                                      children: [
                                        TitleAndDiscripWidget(
                                          titleText: "Land Type",
                                          iconData: Icons.landscape,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.landType??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Meter Price",
                                          iconData: Icons.monetization_on,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText:
                                              "${_adModel.meterPrice.toString()} S.R",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        TitleAndDiscripWidget(
                                          titleText: "Age",
                                          iconData: Icons.assignment,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.buildingAge??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Lift",
                                          iconData: Icons.arrow_upward,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.lift??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Room",
                                          iconData: Icons.room,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.room??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Bath",
                                          iconData:
                                              Icons.airline_seat_legroom_normal,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.bath??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Kitchen",
                                          iconData: Icons.kitchen,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.kitchen??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Family or Single",
                                          titleColor: appDesign.hint,
                                          iconData: Icons.people,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.socialStatus??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Apartment Type",
                                          iconData: Icons.location_city,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.buildingType??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Pool",
                                          iconData: Icons.pool,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.pool??"",
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TitleAndDiscripWidget(
                                          titleText: "Garage",
                                          iconData: Icons.directions_car,
                                          titleColor: appDesign.hint,
                                          titleSize: 15,
                                          titleFontWeight: FontWeight.w600,
                                          discripSize: 18,
                                          discripFontWeight: FontWeight.bold,
                                          discripText: _adModel.garage??"",
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                "Address and Location",
                                color: Colors.blue,
                                size: 20,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Address",
                                iconData: Icons.location_searching,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripWidget:  Text(
                                        _adModel.address??"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Near Places",
                                iconData: Icons.add_location,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripWidget:  Text(
                                        _adModel.nearPlaces??"",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              TitleAndDiscripWidget(
                                titleText: "City",
                                iconData: Icons.call_split,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.city.name??"",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Area",
                                iconData: Icons.call_split,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.area??"",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "District",
                                iconData: Icons.call_split,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.district??"",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Street",
                                iconData: Icons.call_split,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.street??"",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Postal Code",
                                iconData: Icons.mail,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripSize: 18,
                                discripFontWeight: FontWeight.bold,
                                discripText: _adModel.postalCode??"",
                              ),
                              TitleAndDiscripWidget(
                                titleText: "Ad Owner Details",
                                iconData: Icons.person,
                                titleColor: appDesign.hint,
                                titleSize: 15,
                                titleFontWeight: FontWeight.w600,
                                discripWidget: CustomAdOwnerCard(
                                  adModel: _adModel,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )),
                      AdPageComments(
                        adModel: _adModel,
                      ),
                      userController.userModel == null
                          ? SizedBox()
                          : Column(
                              children: [
                                _adModel != null &&
                                        userController.userModel != null &&
                                        userController.userModel.id ==
                                            _adModel.user.id
                                    ? Container(
                                        color: appDesign.bg,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: FlatButton(
                                                    color: Colors.blue,
                                                    onPressed:_adModel==null?null: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      AddAdPage(
                                                                        type: _adModel.meterPrice !=
                                                                                null
                                                                            ? "Land"
                                                                            : "Property",
                                                                        adModel:
                                                                            _adModel,
                                                                      )));
                                                    },
                                                    child: Text("Edit"))),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: FlatButton(
                                                    onPressed: () async {
                                                      showMSG(
                                                          context,
                                                          "Alert",
                                                          "Do you want to delete this Ad ?",
                                                          richAlertType:
                                                              RichAlertType
                                                                  .ERROR,
                                                          actions: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  60,
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        RaisedButton(
                                                                      child: Text(
                                                                          "Yes"),
                                                                      onPressed:
                                                                          () async {
                                                                        await adController.deleteAd(
                                                                            context,
                                                                            id: _adModel.id);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => Home()));
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        RaisedButton(
                                                                      color:
                                                                          appDesign
                                                                              .bg,
                                                                      child: Text(
                                                                          "No"),
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ]);
                                                    },
                                                    child: Text("Delete"))),
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class AdPageComments extends StatefulWidget {
  AdModel adModel;
  AdPageComments({
    this.adModel,
    Key key,
  }) : super(key: key);

  @override
  _AdPageCommentsState createState() => _AdPageCommentsState();
}

class _AdPageCommentsState extends State<AdPageComments> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _commntCTL = TextEditingController();
  List<Widget> _comments = [];
  @override
  void initState() {
    _comments = List.generate(
        widget.adModel.comments.length,
        (index) => CustomCommentWidget(
              commentModel: widget.adModel.comments[index],
              adModel: widget.adModel,
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: appDesign.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(child: CustomText("Comments")),
                  CustomInkWell(
                    child: Text(
                      "All",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllAdComments(
                                adModel: widget.adModel,
                              )));
                    },
                  )
                ],
              ),
            ),
            _comments.length == 0
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: CustomText(
                      "No comments yet",
                      size: 13,
                      color: appDesign.hint,
                    ))
                : Container(
                    height: 80,
                    child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return _comments[i];
                        },
                        separatorBuilder: (context, i) => SizedBox(
                              width: 10,
                            ),
                        itemCount: _comments.length),
                  ),
            userController.userModel == null
                ? SizedBox()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 10),
                        child: CustomText(
                          "Add Comment",
                          size: 14,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: appDesign.white),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormField(
                                  controller: _commntCTL,
                                  decoration:
                                      InputDecoration(hintText: "Write here"),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_commntCTL.text == null ||
                                        _commntCTL.text.trim().isEmpty)
                                      Fluttertoast.showToast(
                                          msg: "can\'t add empty comment");

                                    if (_commntCTL.text != null &&
                                        _commntCTL.text.trim().isNotEmpty) {
                                      AdModel adModel =
                                          await adController.addComment(context,
                                              adId: widget.adModel.id,
                                              comment: _commntCTL.text.trim());
                                      if (mounted)
                                        setState(() {
                                          _comments = List.generate(
                                              adModel.comments.length,
                                              (index) => CustomCommentWidget(
                                                    commentModel:
                                                        adModel.comments[index],
                                                    adModel: widget.adModel,
                                                  ));
                                          _commntCTL.clear();
                                        });
                                      await Future.delayed(
                                          Duration(milliseconds: 100));
                                      _scrollController.jumpTo(_scrollController
                                          .position.maxScrollExtent);
                                    }
                                  },
                                  child:Icon(Icons.send,color: Colors.blue,)
                                )
                              ],
                            ),
                          ))
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

class CustomCommentWidget extends StatefulWidget {
  bool expanded;
  CommentModel commentModel;
  AdModel adModel;
  CustomCommentWidget({
    this.expanded,
    this.adModel,
    this.commentModel,
    Key key,
  }) : super(key: key);

  @override
  _CustomCommentWidgetState createState() => _CustomCommentWidgetState();
}

class _CustomCommentWidgetState extends State<CustomCommentWidget> {
  bool _deleted = false;
  @override
  Widget build(BuildContext context) {
    return _deleted
        ? SizedBox()
        : Container(
            margin: EdgeInsets.all(5),
            width: widget.expanded != null
                ? null
                : MediaQuery.of(context).size.width * .8,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: appDesign.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  onTap: () {
                    // widget.commentModel.user.id==userController.userModel.id?
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Home(index: 2,))):
                    //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AdOwnerPage(
                    //    adModel: AdModel(user: ),
                    //  )));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image(
                        image: NetworkImage(
                          widget.commentModel.user.image,
                        ),
                        
                        width: 60,
                        fit: BoxFit.fill,
                        height: 60,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomText(
                            widget.commentModel.user.firstName,
                            maxLines: 1,
                          )),
                          userController.userModel != null &&
                                  (widget.adModel.user.id ==
                                          userController.userModel.id ||
                                      widget.commentModel.user.id ==
                                          userController.userModel.id)
                              ? InkWell(
                                  onTap: () async {
                                    showMSG(context, "Alert",
                                        "Do you want to delete this comment",
                                        richAlertType: RichAlertType.ERROR,
                                        actions: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                60,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: RaisedButton(
                                                    child: Text("Yes"),
                                                    onPressed: () async {
                                                      await adController
                                                          .deleteComment(
                                                              context,
                                                              id: widget
                                                                  .commentModel
                                                                  .id);
                                                      if (mounted)
                                                        setState(() {
                                                          _deleted = true;
                                                        });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: RaisedButton(
                                                    color: appDesign.bg,
                                                    child: Text("No"),
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
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                  ))
                              : SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomText(
                        widget.commentModel.comment,
                        size: 13,
                        maxLines: widget.expanded != null ? 100 : 1,
                        color: appDesign.hint,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

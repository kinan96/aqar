import 'dart:async';
import 'dart:io';
import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/homeController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/chatModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adOwnerPage.dart';
import 'package:aqar/view/chatPage.dart';
import 'package:aqar/view/editProfile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animations/loading_animations.dart';
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rich_alert/rich_alert.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class OflineConnectWidget extends StatelessWidget {
  const OflineConnectWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "لا يوجد إتصال بالإنترنت",
            style: TextStyle(color: appDesign.white),
          ),
        ],
      ),
    );
  }
}

AppBar buildCustomAppBar(
    {String title,
    Widget iconImage,
    int id,
    Widget icon,
    bool withoutBack,
    Function onBack,
    Function onIconPressed}) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        withoutBack != null
            ? SizedBox()
            : BackButton(
                color: Colors.blue,
                onPressed: onBack,
              ),
        title == null
            ? SizedBox()
            : Text(
                title,
                style: TextStyle(color: appDesign.black),
              ),
        Spacer(),
        iconImage == null
            ? SizedBox()
            : Container(
                height: 60,
                width: 55,
                child: InkWell(
                  onTap: onIconPressed,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: iconImage ?? SizedBox()),
                ),
              )
      ],
    ),
  );
}

class CustomText extends StatelessWidget {
  String text;
  double size;
  FontWeight fontWeight;
  TextDirection textDirection;
  TextAlign textAlign;
  int maxLines;
  MainAxisAlignment mainAxisAlignment;
  Color color;
  CustomText(this.text,
      {this.color,
      this.textDirection,
      this.maxLines,
      this.textAlign,
      this.mainAxisAlignment,
      this.fontWeight,
      this.size});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines ?? 1,

            // textDirection:textDirection?? TextDirection.ltr,
            textAlign: textAlign,
            style: TextStyle(
              color: color ?? appDesign.black,
              fontWeight: fontWeight ?? FontWeight.bold,
              fontSize: size ?? 15,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  bool isPassword;
  Function newValidate;
  TextEditingController controller;
  String lable;
  Widget prefixIcon;
  TextInputType textInputType;
  Function onSaved;
  bool multiLine;
  Function onPressed;
  Function onValidate;
  Widget suffixIcon;
  CustomTextFormField(
      {Key key,
      this.multiLine,
      this.onPressed,
      this.suffixIcon,
      this.prefixIcon,
      this.isPassword,
      this.lable,
      this.newValidate,
      this.onSaved,
      this.controller,
      this.textInputType,
      this.onValidate})
      : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _passVisible = false;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      child: InkWell(
        onTap: widget.onPressed == null
            ? null
            : () {
                widget.onPressed();
              },
        child: TextFormField(
          obscureText: widget.isPassword == null ? false : !_passVisible,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          autovalidate: _autoValidate,
          controller: widget.controller,
          enabled: widget.onPressed == null,
          onFieldSubmitted: widget.onSaved,
          onChanged: (v) {
            setState(() {
              _autoValidate = true;
            });
          },
          autocorrect: false,
          textDirection: widget.textInputType == TextInputType.phone
              ? TextDirection.ltr
              : TextDirection.ltr,
          minLines: 1,
          maxLines: widget.multiLine != null ? 6 : 1,
          validator:widget.newValidate ?? emptyValidate,// widget.onValidate,
          keyboardType: widget.textInputType,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
              labelText: widget.lable,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon ??
                  (widget.isPassword == null
                      ? SizedBox()
                      : InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          onTap: () {
                            setState(() {
                              _passVisible = !_passVisible;
                            });
                          },
                          child: Icon(
                            _passVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                        ))),
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}

class CustomInkWell extends StatelessWidget {
  String text;
  Widget child;
  Function onTap;
  CustomInkWell({Key key, this.text, this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: text != null
            ? Text(text,
                style: TextStyle(
                    color: appDesign.hint,
                    fontSize: 12,
                    fontWeight: FontWeight.bold))
            : child ?? SizedBox(),
      ),
    );
  }
}

class ConfirmationCode extends StatelessWidget {
  const ConfirmationCode({
    Key key,
    @required BoxDecoration pinPutDecoration,
    @required TextEditingController pinPutController,
    @required FocusNode pinPutFocusNode,
  })  : _pinPutDecoration = pinPutDecoration,
        _pinPutController = pinPutController,
        _pinPutFocusNode = pinPutFocusNode,
        super(key: key);

  final BoxDecoration _pinPutDecoration;
  final TextEditingController _pinPutController;
  final FocusNode _pinPutFocusNode;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Locale("en", "US"),
      delegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Text("كود التفعيل"),
            ),
            // PinPut(
            //   fieldsCount: 4,
            //   fieldsAlignment: MainAxisAlignment.center,
            //   submittedFieldDecoration: _pinPutDecoration.copyWith(
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            //   selectedFieldDecoration: _pinPutDecoration,
            //   controller: _pinPutController,
            //   validator: codeValidate,
            //   focusNode: _pinPutFocusNode,
            //   keyboardType: TextInputType.number,
            //   eachFieldPadding: EdgeInsets.symmetric(horizontal: 20),
            //   withCursor: true,
            //   eachFieldMargin: EdgeInsets.symmetric(horizontal: 10),
            //   textStyle: TextStyle(
            //       decoration: TextDecoration.underline,
            //       height: 2.5,
            //       color: appDesign.black,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}

class DecoratedDropDownButton extends StatelessWidget {
  List<DropdownMenuItem> items;
  EdgeInsets margin;
  bool isNotSelected;
  int value;
  Function onChange;
  DecoratedDropDownButton(
      {this.isNotSelected, this.margin, this.onChange, this.items, this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: appDesign.white,
        border: Border.all(color: isNotSelected ? Colors.red : appDesign.white),
        // borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          DropdownButton(
            items: items,
            onChanged: onChange,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.withOpacity(0.6),
            ),
            underline: SizedBox(),
            isExpanded: true,
            value: value,
          ),
        ],
      ),
    );
  }
}

class ConditionAndTermsIcon extends StatelessWidget {
  Function onTap;
  IconData iconData;
  ConditionAndTermsIcon({this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        iconData,
        color: Colors.blue,
        size: 30,
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends StatelessWidget {
  String imageAsset;
  Function onTap;
  IconData iconData;
  int selectedIndex;
  int index;
  double size;
  CustomBottomNavigationBarItem(
      {this.imageAsset,
      this.selectedIndex,
      this.onTap,
      this.index,
      this.size,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        // borderRadius: BorderRadius.all(Radius.circular(45)),
        child: StreamBuilder(
          stream: homeController.selectedBNBItemStream,
          builder: (context, a) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: iconData != null
                ? Icon(
                    iconData,
                    color: index == a.data ? Colors.blue : appDesign.hint,
                    size: 23,
                  )
                : Image.asset(
                    imageAsset,
                    width: 20,
                    height: 20,
                    color: index == a.data ? Colors.blue : appDesign.hint,
                  ),
          ),
        ),
        onTap: () async {
          homeController.changeSelectedBNBItem(index);
          onTap();
        },
      ),
    );
  }
}

class CustomImageSlider extends StatefulWidget {
  /// Children in slideView to slide
  final List<String> children;

  /// If automatic sliding is required
  final bool autoSlide;

  /// If manual sliding is required
  final bool allowManualSlide;

  /// Animation curves of sliding
  final Curve curve;

  /// Time for automatic sliding
  final Duration duration;

  /// Width of the slider
  final double width;

  /// Height of the slider
  final double height;

  /// Shows the tab indicating circles at the bottom
  final bool showTabIndicator;

  /// Cutomize tab's colors
  final Color tabIndicatorColor;

  /// Customize selected tab's colors
  final Color tabIndicatorSelectedColor;
  final BorderRadius borderRadius;

  /// Size of the tab indicator circles
  final double tabIndicatorSize;

  /// Height of the indicators from the bottom
  final double tabIndicatorHeight;

  /// tabController for walkthrough or other implementations
  final TabController tabController;

  CustomImageSlider(
      {@required this.children,
      @required this.width,
      this.borderRadius,
      @required this.height,
      this.curve,
      this.tabIndicatorColor = Colors.white,
      this.tabIndicatorSelectedColor = Colors.black,
      this.tabIndicatorSize = 12,
      this.tabIndicatorHeight = 10,
      this.allowManualSlide = true,
      this.autoSlide = false,
      this.showTabIndicator = false,
      @required this.tabController,
      this.duration = const Duration(seconds: 3)});

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider>
    with SingleTickerProviderStateMixin {
  /// Setting timer and physics on init!
  @override
  void initState() {
    for (String link in widget.children)
      _widgets.add(Container(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius:
              widget.borderRadius ?? BorderRadius.all(Radius.circular(25)),
          child: Image(
            image: NetworkImage(link),
            width: widget.width,
            fit: BoxFit.fitWidth,
          ),
        ),
      ));
    if (widget.autoSlide) {
      timer = Timer.periodic(widget.duration, (Timer t) {
        widget.tabController.animateTo(
            (widget.tabController.index + 1) % widget.tabController.length,
            curve: widget.curve);
      });
    }
    if (widget.allowManualSlide) {
      scrollPhysics = ScrollPhysics();
    } else {
      scrollPhysics = NeverScrollableScrollPhysics();
    }
    super.initState();
  }

  List<Widget> _widgets = [];

//Declared Timer and physics.
  Timer timer;
  ScrollPhysics scrollPhysics;

  @override
  Widget build(BuildContext context) {
    // Container has a stack with the tab indicators and the tab bar view!
    return Container(
        child: Column(children: [
      Container(
        width: widget.width,
        height: widget.height,
        child: TabBarView(
          controller: widget.tabController,
          children: _widgets,
          physics: scrollPhysics,
        ),
      ),
      widget.showTabIndicator
          ? Container(
              width: widget.width,
              child: Center(
                  child: TabPageSelector(
                controller: widget.tabController,
                color: widget.tabIndicatorColor,
                selectedColor: widget.tabIndicatorSelectedColor,
                indicatorSize: widget.tabIndicatorSize,
              )))
          : Container(
              width: 0,
              height: 0,
            ),
    ]));
  }
}

class TitleAndDiscripWidget extends StatelessWidget {
  String titleText;
  Color titleColor;
  Color discrepColor;
  IconData iconData;
  double heightSpace;
  double discripSize;
  FontWeight discripFontWeight;
  String discripText;
  Widget titleWidget;
  double titleSize;
  FontWeight titleFontWeight;
  Widget discripWidget;
  TitleAndDiscripWidget(
      {this.discripText,
      this.titleText,
      this.iconData,
      this.discripWidget,
      this.discrepColor,
      this.titleColor,
      this.titleWidget,
      this.discripFontWeight,
      this.discripSize,
      this.heightSpace,
      this.titleSize,
      this.titleFontWeight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  iconData != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, right: 5),
                          child: Icon(
                            iconData,
                            color: Colors.blue,
                            size: 18,
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    child: titleWidget ??
                        Text(
                          titleText,
                          // maxLines: 3,
                          style: TextStyle(
                              fontWeight: titleFontWeight ?? FontWeight.bold,
                              fontSize: titleSize ?? 17,
                              color: titleColor ?? appDesign.hint),
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: heightSpace ?? 7,
              ),
              discripWidget ??
                  Text(
                    discripText,
                    style: TextStyle(
                        fontWeight: discripFontWeight ?? FontWeight.w500,
                        fontSize: discripSize ?? 16,
                        color: discrepColor ?? appDesign.black),
                  ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        )
      ],
    );
  }
}

class CustomRefreshFooter extends StatelessWidget {
  const CustomRefreshFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("");
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text("");
        } else if (mode == LoadStatus.canLoading) {
          body = Text("");
        } else {
          body = Text("");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}

Center buildProfilePicture(BuildContext context,
    {File file, String imageURL, IconData iconData, Function onPressed}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width / 3 + 20,
      height: (MediaQuery.of(context).size.width / 3) * 1.2 + 20,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: (MediaQuery.of(context).size.width / 3) * 1.2,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.blue, width: 3)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image(
                  image:
                      file != null ? FileImage(file) : NetworkImage(imageURL),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              bottom: 0,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                    decoration: BoxDecoration(
                        color: appDesign.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: 40,
                    height: 40,
                    child: Icon(
                      iconData,
                      color: Colors.blue,
                    )),
              ))
        ],
      ),
    ),
  );
}

class FilterButtonWithDesc extends StatelessWidget {
  Function onTap;
  String text;
  IconData iconData;
  FilterButtonWithDesc({
    this.onTap,
    this.text,
    this.iconData,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              iconData,
              color: appDesign.hint,
              size: 25,
            ),
            Text(
              text,
              style: TextStyle(color: appDesign.hint, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class NormalSmallButton extends StatelessWidget {
  IconData icon;
  Function onPressed;
  bool justPop;
  Color color;
  NormalSmallButton({this.onPressed, this.color, this.justPop, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: appDesign.bg,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: InkWell(
          onTap: justPop != null
              ? () {
                  Navigator.of(context).pop();
                }
              : onPressed,
          child: Icon(
            icon ?? Icons.arrow_back_ios,
            color: color ?? Colors.blue,
          )),
    );
  }
}

class CustomAdOwnerCard extends StatelessWidget {
  bool adOwnerPage;
  AdModel adModel;
  int id;
  CustomAdOwnerCard({
    this.adOwnerPage,
    this.id,
    this.adModel,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: adOwnerPage != null
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
        color: appDesign.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                onTap: adOwnerPage != null
                    ? null
                    : () {
                        userController.userModel != null &&
                                userController.userModel != null &&
                                userController.userModel.id == adModel.user.id
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()))
                            : 
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdOwnerPage(
                                          adModel: adModel,
                                        )));
                      },
                child: Image(
                  image: NetworkImage(
                    adModel.user.image,
                  ),
                  width: adOwnerPage != null
                      ? MediaQuery.of(context).size.width / 3 - 10
                      : MediaQuery.of(context).size.width / 3 - 10,
                  height: adOwnerPage != null
                      ? MediaQuery.of(context).size.width / 2 - 10
                      : MediaQuery.of(context).size.width / 3 - 10,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomText(
                    adModel.user.firstName + " " + adModel.user.lastName,
                    size: 20,
                    maxLines: 1,
                  ),
                  Spacer(),
                  CustomText(
                    adModel.user.mobile,
                    size: 20,
                    maxLines: 1,
                  ),
                  Spacer(),
           Row(children: [


    Expanded(
      child: CustomText(
                      adModel.user.email,
                      size: 20,
                      maxLines: 1,
                    ),
    ),
SizedBox(width: 10,),                   InkWell(
                            onTap:userController.userModel!=null&&  userController.userModel.id==adModel.user.id? null: () async {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ChatPage(
                                from:adOwnerPage!=null?"owner":"ad" ,
                                chatModel: ChatModel(
                                image: adModel.user.image,
                                adModel: adModel,
                                receiverId: adModel.user.id,
                                title: adModel.user.firstName+" "+adModel.user.lastName,
                                room:id?? int.tryParse("${adModel.id}${userController.userModel.id}${adModel.user.id}")
                              ),)));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.chat,color: Colors.white,),
                              )
                            ),
                          ),
           ])
              
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class RattingProfile extends StatelessWidget {
  double rate;
  double starSize;
  RattingProfile({
    this.rate,
    this.starSize,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Localizations(
      delegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale("en", "US"),
      child: RatingBar(
        onRatingUpdate: (r) {},
        allowHalfRating: true,
        glow: false,
        ignoreGestures: true,
        initialRating: rate,
        itemCount: 5,
        itemSize: starSize ?? 20,
        unratedColor: appDesign.hint,
        ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              color: Colors.amber,
            ),
            half: Icon(
              Icons.star_half,
              color: Colors.amber,
            ),
            empty: Icon(
              Icons.star_border,
              color: Colors.amber,
            )),
      ),
    );
  }
}

class CustomAdImageSlider extends StatefulWidget {
  AdModel adModel;
  List<Widget> images;
  bool fav;
  CustomAdImageSlider({
    this.images,
    this.fav,
    this.adModel,
    Key key,
  }) : super(key: key);

  @override
  _CustomAdImageSliderState createState() => _CustomAdImageSliderState();
}

class _CustomAdImageSliderState extends State<CustomAdImageSlider> {
  initState() {
    _fav = widget.fav;
    super.initState();
  }

  bool _fav;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        overflow: Overflow.visible,
        // alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
              child: widget.images == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LoadingBouncingGrid.square(),
                      ),
                    )
                  : CarouselSlider(
                      items: widget.images,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        height: MediaQuery.of(context).size.height / 2,
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(seconds: 3),
                      ),
                    )),
          Positioned(
            bottom: -2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 25,
              decoration: BoxDecoration(
                  color: appDesign.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
            ),
          ),
          Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 10,
                    right: 20,
                    left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalSmallButton(
                      icon: Icons.arrow_back_ios,
                      justPop: true,
                    ),
                    widget.adModel == null
                        ? SizedBox()
                        : Row(
                            children: [
                              NormalSmallButton(
                                icon: Icons.share,
                                onPressed: () async {
                                  if (widget.adModel != null) {
                                    Share.share("${widget.adModel.title}\n${widget.adModel.note}\n${widget.adModel.price}\n${widget.adModel.city.name}\n${widget.adModel.district}\n${widget.adModel.street}\n${widget.adModel.user.mobile}\n${widget.adModel.user.email}");
                                  }
                                },
                              ),
                           
                            ],
                          )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class PriceRow extends StatelessWidget {
  String price;
  PriceRow({
    this.price,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          price,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          "S.R",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )
      ],
    );
  }
}

class AdHeaderDetails extends StatelessWidget {
  String name;
  String price;
  String area;
  String propertyType;
  AdHeaderDetails({
    this.name,
    this.propertyType,
    this.price,
this.area,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 3,
                  child: CustomText(
                    "$name",
                    size: 18,
                    maxLines: 2,
                  )),
              Column(
                children: [
                  PriceRow(
                    price: "$price",
                  ),
                 
                ],
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
           
                  Expanded(
                    flex: 9,
                    child: TitleAndDiscripWidget(
                                  titleText: "Type",
                                  iconData: Icons.map,
                                  titleColor: appDesign.hint,
                                  titleSize: 15,
                                  titleFontWeight: FontWeight.w600,
                                  discripSize: 18,
                                  discripFontWeight: FontWeight.bold,
                                  discripText: propertyType,
                                ),
                  ),
                                         SizedBox(
                                width: 10,
                              ),

                              Expanded(
                                flex: 3,
                                child: TitleAndDiscripWidget(
                                  titleText: "Area",
                                  iconData: Icons.call_split,
                                  titleColor: appDesign.hint,
                                  titleSize: 15,
                                  titleFontWeight: FontWeight.w600,
                                  discripSize: 18,
                                  discripFontWeight: FontWeight.bold,
                                  discripText: area +" m2" ?? "",
                                ),
                              ),
                            
            ],
          )
        ],
      ),
    );
  }
}

Future whenExitDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return RichAlertDialog(
          //uses the custom alert dialog
          actions: [
            FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: appDesign.white, fontWeight: FontWeight.bold),
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            SizedBox(
              width: 10,
            ),
            FlatButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                })
          ],
          alertTitle: richTitle("Do you want to signOut ?"),
          alertSubtitle: richSubtitle("You will signOut when you confirm"),
          alertType: RichAlertType.WARNING,
        );
      });
}

class FilterListTile extends StatelessWidget {
  Stream filterStream;
  var id;
  String text;
  Function onSelect;
  Function sinkToStream;
  FilterListTile({
    this.filterStream,
    this.id,
    this.sinkToStream,
    this.text,
    this.onSelect,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: filterStream,
        builder: (context, index) => InkWell(
              onTap: () {
                sinkToStream(id);
                onSelect();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomText(
                      text,
                      maxLines: 1,
                    )),
                    Icon(
                      (index.hasData && id == index.data)
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
            ));
  }
}

class ImageViewer extends StatefulWidget {
  List<String> images;
  String title;
  int position;
  ImageViewer({this.images, this.position, this.title});
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  PageController _pageController;
  int _cuurentIndex;
  @override
  void initState() {
    _pageController = PageController(initialPage: widget.position ?? 0);
    _cuurentIndex = widget.position ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned.fill(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() {
                      _cuurentIndex = i;
                    });
                  },
                  children: List.generate(
                      widget.images.length,
                      (index) =>
                          Image(image: NetworkImage(widget.images[index]))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  color: Colors.blue.withOpacity(0.2),
                  child: Text(
                    "${_cuurentIndex + 1} / ${widget.images.length}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

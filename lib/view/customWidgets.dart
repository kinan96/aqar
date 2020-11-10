import 'dart:async';
import 'dart:io';
import 'package:aqar/controller/homeController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
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
          validator: widget.onValidate,
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
                  iconData!=null?Padding(
                    padding: const EdgeInsets.only(bottom:5.0,right: 5),
                    child: Icon(iconData,color: Colors.blue,size: 18,),
                  ):SizedBox(),
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
                  "Exit",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                })
          ],
          alertTitle: richTitle("Are you sure ?"),
          alertSubtitle: richSubtitle(""),
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


import 'package:aqar/controller/adController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/signIn.dart';
import 'package:aqar/view/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateSheet extends StatefulWidget {
  int id;
  RateSheet({this.id});
  @override
  _RateSheetState createState() => _RateSheetState();
}

class _RateSheetState extends State<RateSheet> {
  double _rate = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return Container(
      color: Color(0xff737373),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Rate the User",
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: appDesign.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        RatingBar(
                          itemSize: 40,
                          onRatingUpdate: (r) {
                            if (mounted)
                              setState(() {
                                _rate = r;
                              });
                          },
                          itemCount: 5,
                          allowHalfRating: false,
                          initialRating: _rate,
                          direction: Axis.horizontal,
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
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Rate"),
                                  onPressed: ()async {
                                   await adController.rateAdOwner(context,rate: _rate,ratedId:widget.id );
                                   Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: RaisedButton(
                                    color: appDesign.white,
                                    child: Text(
                                      "Cancel",
                                      style:
                                          TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    }),
                              ),
                            ],
                          ),

                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

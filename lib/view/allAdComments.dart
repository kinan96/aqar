import 'package:aqar/controller/adController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class AllAdComments extends StatefulWidget {
  AdModel adModel;
  AllAdComments({this.adModel});
  @override
  _AllAdCommentsState createState() => _AllAdCommentsState();
}

class _AllAdCommentsState extends State<AllAdComments> {
  List<Widget>_comments=[];
  @override
  void initState() {
    _getAdDetails();
    super.initState();
  }
  AdModel _adModel;
  _getAdDetails() async {
    AdModel adModel = await adController.getAdDetails(_sc, widget.adModel.id);
    if (mounted)
      setState(() {
        _adModel = adModel;
        _comments=List.generate(_adModel.comments.length, (index) => CustomCommentWidget(commentModel: _adModel.comments[index],adModel: _adModel,expanded: true,));

      });
  }
GlobalKey<ScaffoldState>_sc=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sc,
      appBar: buildCustomAppBar(title: "All comments"),
      body:Padding(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
        child:_adModel==null?Center(child: LoadingBouncingGrid.square()):_comments.length==0?CustomText(
               "No comments yet",
                  size: 13,
                  textAlign: TextAlign.center,
                  color: appDesign.hint,
                ) :ListView.separated(itemBuilder:(context,i)=> _comments[i], separatorBuilder:(context,i)=>SizedBox(height: 0,), itemCount: _comments.length),
      )
      );
  }
}


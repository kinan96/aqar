import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class SearchCatFilterModalSheet extends StatefulWidget {
  TextEditingController textEditingController;
  SearchCatFilterModalSheet({this.textEditingController});
  @override
  _SearchCatFilterModalSheetState createState() => _SearchCatFilterModalSheetState();
}

class _SearchCatFilterModalSheetState extends State<SearchCatFilterModalSheet> {
  initState(){
_getListOfFilters();
    super.initState();
  }
_getListOfFilters()async{
  List<Widget>_filter=await searchBodyController.getCategories(context: context,textEditingController: widget.textEditingController);
  if(mounted)
  setState(() {
    _filters=_filter;
  });
}
List<Widget>_filters;
  bool empty = false;
  String reason = "";
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: Color(0xff737373),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       CustomText(
                          "الأقسام",
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(
                        height: 150,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:_filters??[Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LoadingBouncingGrid.square(),
                            ),)]
                          ),
                        ),
                      ),
                    ],
                  ))),
        ),
      ],
    );
  }
}


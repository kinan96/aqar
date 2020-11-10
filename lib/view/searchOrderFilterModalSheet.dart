import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class SearchOrderFilterModalSheet extends StatefulWidget {
  TextEditingController textEditingController;
  SearchOrderFilterModalSheet({this.textEditingController});
  @override
  _SearchOrderFilterModalSheetState createState() => _SearchOrderFilterModalSheetState();
}

class _SearchOrderFilterModalSheetState extends State<SearchOrderFilterModalSheet> {
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
                          "الترتيب",
                          size: 20,
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(
                        height: 150,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:List.generate(
            searchBodyController.arrange.length,
            (index) => FilterListTile(
                  text: searchBodyController.arrange.values.toList()[index],
                  filterStream:
                      searchBodyController.searchOrderIdFilterStream,
                  id:searchBodyController.arrange.keys.toList()[index],
                  onSelect: () async{
                    Navigator.pop(context);
                searchBodyController.changesearchedListOfAds([
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingBouncingGrid.square(),
                    ),
                  )
                ]);
                  List _searched = await homeBodyController.search(
                      cityId: searchBodyController.searchCityIdFilter,
                      title: widget.textEditingController.text,
                      sort: searchBodyController.searchOrderIdFilter);
                  searchBodyController.changesearchedListOfAds(
                     List.generate(_searched[1].length, (index) => CustomAdCard(adModel:
                _searched[1][index])));
            searchBodyController.changesearchedCount(_searched[0]);
                              },
                  sinkToStream:
                      searchBodyController.changesearchOrderIdFilter,
                ))
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


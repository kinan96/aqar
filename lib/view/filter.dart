import 'package:aqar/controller/baseUrl.dart';
import 'package:aqar/controller/filterController.dart';
import 'package:aqar/controller/homeBodyController.dart';
import 'package:aqar/controller/searchBodyController.dart';
import 'package:aqar/controller/signUpController.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:aqar/view/Home.dart';
import 'package:aqar/view/adPage.dart';
import 'package:aqar/view/addAdPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:aqar/view/homeBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:numberpicker/numberpicker.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
  String _propertyType;
  String _type;
  String _familyOrSingle;
  Map<int, String> _ageMap = {
    0: "Age",
    1: "0-5",
    2: "0-10",
    3: "0-15",
    4: "0-20",
    5: "0-25",
    6: "0-30",
    7: "0-35",
    8: "0-40",
    9: "0-45",
    10: "0-50"
  };
  List<DropdownMenuItem> _ageButtons = [];
  int _ageId = 0;
  _onAgeChange(val) {
    setState(() {
      _ageId = val;
      if (val > 0) {
        filterController.changeageTo(val * 5);
        filterController.changeageFrom(0);
      } else {
        filterController.changeageTo(null);
        filterController.changeageFrom(0);
      }
    });
  }

  Map<int, String> _roomMap = {
    0: "Number Of Rooms",
    1: "0-5",
    2: "0-10",
    3: "0-15",
    4: "0-20"
  };
  List<DropdownMenuItem> _roomButtons = [];
  int _roomId = 0;
  _onroomChange(val) {
    setState(() {
      _roomId = val;
      if (val > 0) {
        filterController.changeroomTo(val * 5);
        filterController.changeroomFrom(0);
      } else {
        filterController.changeroomTo(null);
        filterController.changeroomFrom(0);
      }
    });
  }

  Map<int, String> _bathMap = {
    0: "Number Of Baths",
    1: "0-5",
    2: "5-10",
    3: "0-15",
    4: "0-20"
  };
  List<DropdownMenuItem> _bathButtons = [];
  int _bathId = 0;
  _onbathChange(val) {
    setState(() {
      _bathId = val;
      if (val > 0) {
        filterController.changebathTo(val * 5);
        filterController.changebathFrom(0);
      } else {
        filterController.changebathTo(null);
        filterController.changebathFrom(0);
      }
    });
  }
  @override
  void initState() {
if(filterController.propertyType=="Villa"||filterController.propertyType=="Apartment")
{
  for(int i=0;i<_ageMap.length;i++)
  if(_ageMap[i]=="0-${filterController.ageTo}")
  setState(() {
    _ageId=i;
  });
  for(int i=0;i<_roomMap.length;i++)
  if(_roomMap[i]=="0-${filterController.roomTo}")
  setState(() {
    _roomId=i;
  });
  for(int i=0;i<_bathMap.length;i++)
  if(_bathMap[i]=="0-${filterController.bathTo}")
  setState(() {
    _bathId=i;
  });

}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ageButtons = signUpController.builDropDownItem(_ageMap, _ageId);
    _roomButtons = signUpController.builDropDownItem(_roomMap, _roomId);
    _bathButtons = signUpController.builDropDownItem(_bathMap, _bathId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text(
          "Filters",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      //////////////////////////////////////////////////////////////
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomRadioList(
                iconData: Icons.map,
                choices: ["All", "Rent", "Sale"],
                addToStream: filterController.changerentOrSale,
                stream: filterController.rentOrSaleStream,
                title: "Type",
              ),
              CustomRadioList(
                iconData: Icons.location_city,
                type: true,
                choices: ["All", "Villa", "Apartment", "Land"],
                addToStream: filterController.changepropertyType,
                stream: filterController.propertyTypeStream,
                title: "Property Type",
              ),
              StreamBuilder(
                stream: filterController.rentOrSaleStream,
                builder: (context, type) => type.data == null ||
                        type.data == "Sale"
                    ? SizedBox()
                    : StreamBuilder<String>(
                        stream: filterController.propertyTypeStream,
                        builder: (context, snapshot) {
                          return snapshot.data != null &&
                                  snapshot.data != "Land"
                              ? CustomRadioList(
                                  iconData: Icons.people,
                                  choices: ["All", "Family", "Single"],
                                  addToStream:
                                      filterController.changefamilyOrSingle,
                                  stream: filterController.familyOrSingleStream,
                                  title: "Family Or Single",
                                )
                              : SizedBox();
                        }),
              ),
              CustomFromToPicker(
                from: 0,
                to: 380,
                step: 10,
                currentFrom: filterController.priceFrom,
                currentTo: filterController.priceTo,
                fromStream: filterController.priceFromStream,
                changeFrom: filterController.changepriceFrom,
                centerText: "To",
                toStream: filterController.priceToStream,
                changeTo: filterController.changepriceTo,
                title: "Price",
                childrenType: "S.R",
                titleIcon: Icons.monetization_on,
              ),
              CustomFromToPicker(
                from: 0,
                to: 5100,
                step: 100,
                currentFrom: filterController.areaFrom,
                currentTo: filterController.areaTo,
                fromStream: filterController.areaFromStream,
                changeFrom: filterController.changeareaFrom,
                centerText: "To",
                toStream: filterController.areaToStream,
                changeTo: filterController.changeareaTo,
                title: "Area",
                childrenType: "m2",
                titleIcon: Icons.aspect_ratio,
              ),
              StreamBuilder<String>(
                  stream: filterController.propertyTypeStream,
                  builder: (context, snapshot) {
                    return snapshot.data == null || snapshot.data != "Land"
                        ? SizedBox()
                        : CustomFromToPicker(
                            from: 0,
                            to: 3100,
                            step: 100,
                            currentFrom: filterController.meterPriceFrom,
                            currentTo: filterController.meterPriceTo,
                            fromStream: filterController.meterPriceFromStream,
                            changeFrom: filterController.changemeterPriceFrom,
                            centerText: "To",
                            toStream: filterController.meterPriceToStream,
                            changeTo: filterController.changemeterPriceTo,
                            title: "Meter Price",
                            childrenType: "S.R",
                            titleIcon: Icons.monetization_on,
                          );
                  }),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<String>(
                  stream: filterController.propertyTypeStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    return snapshot.data == "Land" || snapshot.data == null
                        ? SizedBox()
                        : Column(
                            children: [
                              Card(
                                elevation: 6,
                                child: DecoratedDropDownButton(
                                  isNotSelected: false,
                                  items: _ageButtons,
                                  value: _ageId,
                                  onChange: _onAgeChange,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 6,
                                child: DecoratedDropDownButton(
                                  isNotSelected: false,
                                  items: _roomButtons,
                                  value: _roomId,
                                  onChange: _onroomChange,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 6,
                                child: DecoratedDropDownButton(
                                  isNotSelected: false,
                                  items: _bathButtons,
                                  value: _bathId,
                                  onChange: _onbathChange,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BooleanTile(
                                title: "Garage",
                                stream: filterController.garageStream,
                                streamFunc: filterController.changegarage,
                              ),
                              BooleanTile(
                                title: "Pool",
                                stream: filterController.poolStream,
                                streamFunc: filterController.changepool,
                              ),
                              BooleanTile(
                                title: "Kitchen",
                                stream: filterController.kitchenStream,
                                streamFunc: filterController.changekitchen,
                              ),
                              BooleanTile(
                                title: "Lift",
                                stream: filterController.liftStream,
                                streamFunc: filterController.changelift,
                              )
                            ],
                          );
                  })
            ],
          ),
        ),
      ),
      /////////////////////////////////////////////////////////////
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                     Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home(index: 2,)));

              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                height: 40,
                child: Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                filterController.changerentOrSale(null);
                filterController.changepropertyType(null);
                filterController.changefamilyOrSingle(null);
                filterController.changepriceTo(null);
                filterController.changepriceFrom(0);
                filterController.changeareaFrom(0);
                filterController.changeareaTo(null);
                filterController.changemeterPriceFrom(0);
                filterController.changemeterPriceTo(null);
                filterController.changeageFrom(0);
                filterController.changeageTo(null);
                filterController.changeroomFrom(0);
                filterController.changeroomTo(null);
                filterController.changebathFrom(0);
                filterController.changebathTo(null);
                filterController.changekitchen(null);
                filterController.changegarage(null);
                filterController.changepool(null);
                filterController.changelift(null);
       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home(index: 2,)));

              },
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                height: 40,
                child: Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomRadioList extends StatelessWidget {
  IconData iconData;
  String title;
  List<String> choices;
  Stream stream;
  Function addToStream;
  bool type;
  CustomRadioList({
    this.title,
    this.type,
    this.addToStream,
    this.choices,
    this.iconData,
    this.stream,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        initialData: null,
        builder: (context, snapshot) {
          return TitleAndDiscripWidget(
            titleWidget: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        iconData,
                        color: Colors.blue,
                        size: 25,
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            heightSpace: 0,
            discripWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  choices.length,
                  (index) => NormalradioButton(
                    groupKind: snapshot.data,
                    kind: choices[index] == "All" ? null : choices[index],
                    text: choices[index] == "Rent"
                        ? "Rent / Year"
                        : choices[index],
                    onTap: () {
                      choices[index] == "All"
                          ? addToStream(null)
                          : addToStream(choices[index]);
                      if (type != null && choices[index] == "All") {
                        filterController.changefamilyOrSingle(null);
                        filterController.changemeterPriceFrom(0);
                        filterController.changemeterPriceTo(null);
                        filterController.changeageFrom(0);
                        filterController.changeageTo(null);
                        filterController.changeroomFrom(0);
                        filterController.changeroomTo(null);
                        filterController.changebathFrom(0);
                        filterController.changebathTo(null);
                        filterController.changekitchen(null);
                        filterController.changegarage(null);
                        filterController.changepool(null);
                        filterController.changelift(null);
                      }
                      if (choices[index] == "All" ||
                          choices[index] == "Sale" ||
                          choices[index] == "Land")
                        filterController.changefamilyOrSingle(null);
                      if (choices[index] == "Land") {
                        filterController.changefamilyOrSingle(null);
                        filterController.changeageFrom(0);
                        filterController.changeageTo(null);
                        filterController.changeroomFrom(0);
                        filterController.changeroomTo(null);
                        filterController.changebathFrom(0);
                        filterController.changebathTo(null);
                        filterController.changekitchen(null);
                        filterController.changegarage(null);
                        filterController.changepool(null);
                        filterController.changelift(null);
                      }
                      if (choices[index] == "Villa" ||
                          choices[index] == "Apartment") {
                        filterController.changemeterPriceFrom(null);
                        filterController.changemeterPriceTo(null);
                      }
                      if (filterController.propertyType == null ||
                          filterController.rentOrSale == null ||
                          filterController.rentOrSale == "Sale" ||
                          filterController.propertyType == "Land")
                        filterController.changefamilyOrSingle(null);
                    },
                  ),
                )),
          );
        });
  }
}

class BooleanTile extends StatelessWidget {
  String title;
  Stream stream;
  Function streamFunc;
  BooleanTile({
    this.title,
    this.stream,
    this.streamFunc,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: stream,
        builder: (context, snapshot) {
          return ListTile(
            title: Text(
              "$title",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18),
            ),
            trailing: Switch(
              value: snapshot.data ?? false,
              onChanged: streamFunc,
              activeColor: Colors.green,
            ),
          );
        });
  }
}

class CustomFromToPicker extends StatelessWidget {
  String title;
  IconData titleIcon;
  Stream fromStream;
  Stream toStream;
  Function changeFrom;
  Function changeTo;
  int currentFrom;
  int currentTo;
  int from;
  int to;
  int step;
  String childrenType;
  String centerText;
  CustomFromToPicker({
    this.title,
    this.toStream,
    this.currentFrom,
    this.currentTo,
    this.from,
    this.step,
    this.to,
    this.changeFrom,
    this.fromStream,
    this.changeTo,
    this.centerText,
    this.childrenType,
    this.titleIcon,
    Key key,
  }) : super(key: key);
  String _price(int i) {
    if (i == 0)
      return "0";
    else if (i > 0 && i < 110)
      return "$i\K S.R";
    else if (i > 100 && i < 190)
      return "${((i - 90) * 10).toInt()}K S.R";
    else if (i == 190)
      return "1M S.R";
    else if (i > 190 && i < 290)
      return "1.${((i - 200) / 10 + 1).toInt()}M S.R";
    else if (i > 280 && i < 380)
      return "${((i - 280) / 10 + 1).toInt()}M S.R";
    else
      return "10M+ S.R";
  }

  String _area(int i) {
    if (i == 0)
      return "0";
    else if (i < 5100)
      return "$i m2";
    else
      return "5000 m2+";
  }

  String _meterPrice(int i) {
    if (i == 0)
      return "0";
    else if (i < 3100)
      return "$i S.R";
    else
      return "3000 S.R+";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                children: [
                  Icon(
                    titleIcon,
                    color: Colors.blue,
                    size: 25,
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Row(
          children: [
            StreamBuilder<int>(
                stream: fromStream,
                initialData: currentFrom ?? 0,
                builder: (context, snapshot) {
                  return Expanded(
                      child: NumberPicker.integer(
                    step: step,
                    itemExtent: 30,
                    initialValue: snapshot.data ?? 0,
                    textMapper: title == "Price"
                        ? (i) => _price(int.parse(i))
                        : title == "Area"
                            ? (i) => _area(int.parse(i))
                            : title == "Meter Price"
                                ? (i) => _meterPrice(int.parse(i))
                                : (i) => "$i${i != "0" ? childrenType : ""}",
                    textStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                    selectedTextStyle: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                    minValue: from,
                    maxValue: to,
                    onChanged: (i) => changeFrom(i),
                  ));
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "$centerText",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            StreamBuilder<int>(
              stream: fromStream,
              initialData:currentFrom?? 0,
              builder: (context, fromSnapShot) => StreamBuilder<int>(
                  stream: toStream,
                  initialData: currentTo ?? to??0,
                  builder: (context, snapshot) {
                    return Expanded(
                        child: NumberPicker.integer(
                      initialValue: snapshot.data ?? 0,
                      step: step,
                      itemExtent: 30,
                      textMapper: title == "Price"
                          ? (i) => _price(int.parse(i))
                          : title == "Area"
                              ? (i) => _area(int.parse(i))
                              : title == "Meter Price"
                                  ? (i) => _meterPrice(int.parse(i))
                                  : (i) => "$i${i != "0" ? childrenType : ""}",
                      textStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                      selectedTextStyle: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      minValue: from,
                      maxValue: to,
                      onChanged: (i) => fromSnapShot.data < i
                          ? changeTo(i)
                          : changeTo(fromSnapShot.data),
                    ));
                  }),
            ),
          ],
        ),
      ],
    );
  }
}


import 'package:aqar/controller/filterController.dart';
import 'package:aqar/view/addAdPage.dart';
import 'package:aqar/view/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:numberpicker/numberpicker.dart';

class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String _propertyType;
  String _type;
  String _familyOrSingle;
  @override
  Widget build(BuildContext context) {
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
                to: 900,
                step: 100,
                fromStream: filterController.priceFromStream,
                changeFrom: filterController.changepriceFrom,
                centerText: "To",
                toStream: filterController.priceToStream,
                changeTo: filterController.changepriceTo,
                title: "Price",
                childrenType: "K S.R",
                titleIcon: Icons.monetization_on,
              ),
              CustomFromToPicker(
                from: 0,
                to: 10000,
                step: 1000,
                fromStream: filterController.areaFromStream,
                changeFrom: filterController.changeareaFrom,
                centerText: "To",
                toStream: filterController.areaToStream,
                changeTo: filterController.changeareaTo,
                title: "Area",
                childrenType: "m2",
                titleIcon: Icons.aspect_ratio,
              ),
              CustomFromToPicker(
                from: 0,
                to: 2000,
                step: 100,
                fromStream: filterController.meterPriceFromStream,
                changeFrom: filterController.changemeterPriceFrom,
                centerText: "To",
                toStream: filterController.meterPriceToStream,
                changeTo: filterController.changemeterPriceTo,
                title: "Meter Price",
                childrenType: "S.R",
                titleIcon: Icons.monetization_on,
              ),
              CustomFromToPicker(
                from: 0,
                to: 50,
                step: 10,
                fromStream: filterController.ageFromStream,
                changeFrom: filterController.changeageFrom,
                centerText: "To",
                toStream: filterController.ageToStream,
                changeTo: filterController.changeageTo,
                title: "Age",
                childrenType: "Year",
                titleIcon: Icons.assignment,
              ),
              CustomFromToPicker(
                from: 0,
                to: 20,
                step: 5,
                fromStream: filterController.roomFromStream,
                changeFrom: filterController.changeroomFrom,
                centerText: "To",
                toStream: filterController.roomToStream,
                changeTo: filterController.changeroomTo,
                title: "Number Of Rooms",
                childrenType: "",
                titleIcon: Icons.room,
              ),
              CustomFromToPicker(
                from: 0,
                to: 10,
                step: 2,
                fromStream: filterController.bathFromStream,
                changeFrom: filterController.changebathFrom,
                centerText: "To",
                toStream: filterController.bathToStream,
                changeTo: filterController.changebathTo,
                title: "Number Of Baths",
                childrenType: "",
                titleIcon: Icons.airline_seat_legroom_normal,
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
          ),
        ),
      ),
      /////////////////////////////////////////////////////////////
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                print(filterController.priceFrom.toString() +
                    filterController.priceTo.toString());
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
              onTap: () {
                filterController.changerentOrSale(null);
                filterController.changepropertyType(null);
                filterController.changefamilyOrSingle(null);
                filterController.changepriceTo(null);
                filterController.changepriceFrom(null);
                filterController.changeareaFrom(null);
                filterController.changeareaTo(null);
                filterController.changemeterPriceFrom(null);
                filterController.changemeterPriceTo(null);
                filterController.changeageFrom(null);
                filterController.changeageTo(null);
                filterController.changeroomFrom(null);
                filterController.changeroomTo(null);
                filterController.changebathFrom(null);
                filterController.changebathTo(null);
                filterController.changekitchen(null);
                filterController.changegarage(null);
                filterController.changepool(null);
                filterController.changelift(null);
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
  CustomRadioList({
    this.title,
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

                      if (filterController.propertyType == null||filterController.rentOrSale==null ||
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
  int from;
  int to;
  int step;
  String childrenType;
  String centerText;
  CustomFromToPicker({
    this.title,
    this.toStream,
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
                initialData: from,
                builder: (context, snapshot) {
                  return Expanded(
                      child: NumberPicker.integer(
                    step: step,
                    itemExtent: 30,
                    initialValue: snapshot.data ?? 0,
                    textMapper: (i) => "$i${i != "0" ? childrenType : ""}",
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
                    onChanged: changeFrom,
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
                stream: toStream,
                initialData: to,
                builder: (context, snapshot) {
                  return Expanded(
                      child: NumberPicker.integer(
                    initialValue: snapshot.data ?? 0,
                    step: step,
                    itemExtent: 30,
                    textMapper: (i) => "$i${i != "0" ? childrenType : ""}",
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
                    onChanged: changeTo,
                  ));
                }),
          ],
        ),
      ],
    );
  }
}

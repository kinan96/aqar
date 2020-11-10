import 'dart:io';

import 'package:aqar/controller/adController.dart';
import 'package:aqar/controller/signUpController.dart';
import 'package:aqar/controller/validators.dart';
import 'package:aqar/model/adModel.dart';
import 'package:aqar/model/design.dart';
import 'package:aqar/model/userModel.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:permission/permission.dart';
import 'customWidgets.dart';

class AddAdPage extends StatefulWidget {
  AdModel adModel;
  String type;
  AddAdPage({this.adModel, this.type});
  @override
  _AddAdPageState createState() => _AddAdPageState();
}

class _AddAdPageState extends State<AddAdPage> {
  TextEditingController _title = TextEditingController();
  TextEditingController _area = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _street = TextEditingController();
  String _propertyType;
  String _lift;
  String _kitchen;
  String _familyOrSingle;
  String _vellaOrApartment;
  String _pool;
  String _garage;
  TextEditingController _price = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _room = TextEditingController();
  TextEditingController _baths = TextEditingController();
  TextEditingController _landType = TextEditingController();
  TextEditingController _meterPrice = TextEditingController();
  TextEditingController _postal = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _note = TextEditingController();

  initState() {
    adController.changeadLocationData(null);
    _getCities();
    _propertyType = "Rent";
    _kitchen = "Yes";
    _lift="Yes";
    _familyOrSingle = "Family";
    _vellaOrApartment = "Vella";
    _pool = "Yes";
    _garage = "Yes";
    if (widget.adModel != null) {
      _location.text = widget.adModel.address;
      adController.changeadLocationData([
        _location.text,
        LatLng(widget.adModel.lat,
           widget.adModel.lng)
      ]);
      _propertyType = widget.adModel.propertyType;
      _kitchen = widget.adModel.kitchen;
      _lift = widget.adModel.lift;
      _garage = widget.adModel.garage;
      _pool = widget.adModel.pool;
      _vellaOrApartment = widget.adModel.buildingType;
      _familyOrSingle = widget.adModel.socialStatus;
      _title = TextEditingController(text: widget.adModel.title);
      _area = TextEditingController(text: widget.adModel.area);
      _district = TextEditingController(text: widget.adModel.district);
      _street = TextEditingController(text: widget.adModel.street);
      _age = TextEditingController(text: widget.adModel.area);
      _room = TextEditingController(text: widget.adModel.room);
      _baths = TextEditingController(text: widget.adModel.bath);
      _landType = TextEditingController(text: widget.adModel.landType);
      _meterPrice =
          TextEditingController(text: widget.adModel.meterPrice.toString());
      _postal = TextEditingController(text: widget.adModel.postalCode);
      _note = TextEditingController(text: widget.adModel.note);

      _price = TextEditingController(text: widget.adModel.price.toString());
      _imagesUrl = widget.adModel.images;
    }

    super.initState();
  }

  _getCities() async {
    List<CityModel> _cit = await userController.getListOfCites(_sc);
    if (_cit != null && mounted)
      setState(() {
        _city[0] = "Select City";
        for (CityModel cityModel in _cit) _city[cityModel.id] = cityModel.name;
        if (widget.adModel != null) {
          _cityId = widget.adModel.city.id;
        }
      });
  }

  GlobalKey<ScaffoldState> _sc = GlobalKey<ScaffoldState>();
  MapController _mapController = MapController();
  LatLng _center = LatLng(24.774265, 46.738586);
  double _zoom = 4.5;
  List<File> _imagesFiles = [];
  List<String> _imagesUrl = [];
  List<Widget> _imagesWidgets = [];
  Map<int, String> _city = {0: "Cities Loading..."};
  int _cityId = 0;
  List<DropdownMenuItem> _cityItems = [];
  bool _emptyImage = false;
  bool _emptyCity = false;
  _onCityChange(val) {
    setState(() {
      _cityId = val;
      if (val > 0) _emptyCity = false;
    });
  }

  _pickImage() async {
    await Permission.requestPermissions([PermissionName.Storage]);
    final i = await ImagePicker().getImage(source: ImageSource.gallery);
    if (i != null) {
      final f = await ImageCropper.cropImage(sourcePath: i.path);
      if (f != null)
        setState(() {
          _imagesFiles.add(File(f.path));
          _emptyImage = false;
        });
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _cityItems = signUpController.builDropDownItem(_city, _cityId);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _sc,
        appBar: buildCustomAppBar(),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width / 2,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomText(
                  widget.adModel != null
                      ? "Edit ${widget.type} Ad"
                      : "Add ${widget.type} Ad",
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  size: 18,
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          lable: "Title",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.title, color: Colors.lightBlue),
                          ),
                          controller: _title,
                          onValidate: titleValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Description",
                          textInputType: TextInputType.multiline,
                          multiLine: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.description,
                                color: Colors.lightBlue),
                          ),
                          controller: _note,
                          onValidate: noteValidate,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TitleAndDiscripWidget(
                          titleText: "City",
                          heightSpace: 0,
                          discripWidget: Card(
                            elevation: 6,
                            child: DecoratedDropDownButton(
                              isNotSelected: _emptyCity,
                              items: _cityItems,
                              value: _cityId,
                              onChange: _onCityChange,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Area",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.add_location,
                                color: Colors.lightBlue),
                          ),
                          controller: _area,
                          onValidate: emptyValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "District",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.add_location,
                                color: Colors.lightBlue),
                          ),
                          controller: _district,
                          onValidate: emptyValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Street",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child:
                                Icon(Icons.streetview, color: Colors.lightBlue),
                          ),
                          controller: _street,
                          onValidate: emptyValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Postal code",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.local_post_office,
                                color: Colors.lightBlue),
                          ),
                          textInputType: TextInputType.number,
                          controller: _postal,
                          onValidate: emptyValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Price",
                          textInputType: TextInputType.number,
                          controller: _price,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.attach_money,
                                color: Colors.lightBlue),
                          ),
                          onValidate: priceValidate,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          lable: "Location",
                          controller: _location,
                          onValidate: (v){
                            if(adController.adLocationData==null)
                            return "Select Ad Location";
                            else
                            return null;
                          },
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              enableDrag: false,
                              // isDismissible: false,
                              builder: (context) => StreamBuilder<List>(
                                  stream: adController.adLocationDataStream,
                                  initialData: [],
                                  builder: (context, snapshot) {
                                    return FlutterMap(
                                      mapController: _mapController,
                                      options: new MapOptions(
                                        onTap: (latLng) async {
                                          try {
                                            List<Address> addresses =
                                                await Geocoder
                                                    .local
                                                    .findAddressesFromCoordinates(
                                                        Coordinates(
                                                            latLng.latitude,
                                                            latLng.longitude));
                                            if (mounted)
                                              setState(() {
                                                _location.text =
                                                    addresses.first.addressLine;
                                              });
                                            adController.changeadLocationData(
                                                [_location.text, latLng]);
                                          } catch (e) {}
                                        },
                                        center: _center,
                                        zoom: _zoom,
                                      ),
                                      layers: [
                                        new TileLayerOptions(
                                            urlTemplate:
                                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                            subdomains: ['a', 'b', 'c']),
                                        new MarkerLayerOptions(markers: [
                                          adController.adLocationData == null
                                              ? Marker()
                                              : Marker(
                                                  width: 20,
                                                  height: 30,
                                                  point: adController
                                                      .adLocationData[1],
                                                  builder: (context) => Image(
                                                        image: AssetImage(
                                                          "assets/images/marker.png",
                                                        ),
                                                        width: 20,
                                                        height: 30,
                                                        color: Colors.blue,
                                                        fit: BoxFit.fill,
                                                      ))
                                        ]),
                                      ],
                                    );
                                  }),
                            );
                          },
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 20, right: 15),
                            child: Icon(Icons.place, color: Colors.lightBlue),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TitleAndDiscripWidget(
                          titleText: "Type",
                          heightSpace: 0,
                          discripWidget: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NormalradioButton(
                                groupKind: _propertyType,
                                kind: "Rent",
                                text: "Rent",
                                onTap: () {
                                  setState(() {
                                    _propertyType = "Rent";
                                  });
                                },
                              ),
                              // Spacer(),
                              NormalradioButton(
                                groupKind: _propertyType,
                                kind: "Own",
                                text: "Own",
                                onTap: () {
                                  setState(() {
                                    _propertyType = "Own";
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        widget.type == "land"
                            ? Column(
                                children: [
                                  CustomTextFormField(
                                    lable: "Meter Price",
                                    textInputType: TextInputType.number,
                                    controller: _meterPrice,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.attach_money,
                                          color: Colors.lightBlue),
                                    ),
                                    onValidate: priceValidate,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    lable: "Land Type",
                                    controller: _landType,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.loyalty,
                                          color: Colors.lightBlue),
                                    ),
                                    multiLine: true,
                                    onValidate: emptyValidate,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  CustomTextFormField(
                                    lable: "Age / years",
                                    textInputType: TextInputType.number,
                                    controller: _age,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.calendar_today,
                                          color: Colors.lightBlue),
                                    ),
                                    onValidate: emptyValidate,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    lable: "Rooms",
                                    textInputType: TextInputType.number,
                                    controller: _room,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.hotel,
                                          color: Colors.lightBlue),
                                    ),
                                    onValidate: emptyValidate,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    lable: "Baths",
                                    textInputType: TextInputType.number,
                                    controller: _baths,
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(
                                          Icons.airline_seat_legroom_extra,
                                          color: Colors.lightBlue),
                                    ),
                                    onValidate: emptyValidate,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Family or Single",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _familyOrSingle,
                                          kind: "Family",
                                          text: "Family",
                                          onTap: () {
                                            setState(() {
                                              _familyOrSingle = "Family";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _familyOrSingle,
                                          kind: "Single",
                                          text: "Single",
                                          onTap: () {
                                            setState(() {
                                              _familyOrSingle = "Single";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Vella or Apartment",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _vellaOrApartment,
                                          kind: "Vella",
                                          text: "Vella",
                                          onTap: () {
                                            setState(() {
                                              _vellaOrApartment = "Vella";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _vellaOrApartment,
                                          kind: "Apartment",
                                          text: "Apartment",
                                          onTap: () {
                                            setState(() {
                                              _vellaOrApartment = "Apartment";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Lift",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _lift,
                                          kind: "Yes",
                                          text: "Yes",
                                          onTap: () {
                                            setState(() {
                                              _lift = "Yes";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _lift,
                                          kind: "No",
                                          text: "No",
                                          onTap: () {
                                            setState(() {
                                              _lift = "No";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Kitchen",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _kitchen,
                                          kind: "Yes",
                                          text: "Yes",
                                          onTap: () {
                                            setState(() {
                                              _kitchen = "Yes";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _kitchen,
                                          kind: "No",
                                          text: "No",
                                          onTap: () {
                                            setState(() {
                                              _kitchen = "No";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Pool",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _pool,
                                          kind: "Yes",
                                          text: "Yes",
                                          onTap: () {
                                            setState(() {
                                              _pool = "Yes";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _pool,
                                          kind: "No",
                                          text: "No",
                                          onTap: () {
                                            setState(() {
                                              _pool = "No";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  TitleAndDiscripWidget(
                                    titleText: "Garage",
                                    heightSpace: 0,
                                    discripWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NormalradioButton(
                                          groupKind: _garage,
                                          kind: "Yes",
                                          text: "Yes",
                                          onTap: () {
                                            setState(() {
                                              _garage = "Yes";
                                            });
                                          },
                                        ),
                                        // Spacer(),
                                        NormalradioButton(
                                          groupKind: _garage,
                                          kind: "No",
                                          text: "No",
                                          onTap: () {
                                            setState(() {
                                              _garage = "No";
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                      ],
                    )),
                SizedBox(
                  height: 20,
                ),
                CustomText(
                  "Images",
                  color: appDesign.hint,
                ),
                _imagesFiles.length + _imagesUrl.length == 0
                    ? SizedBox()
                    : AspectRatio(
                        aspectRatio: 315 / 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) => _buildImageBox(
                              pos: i,
                              file: i < _imagesFiles.length
                                  ? _imagesFiles[i]
                                  : null,
                              url: i < _imagesFiles.length
                                  ? null
                                  : i - _imagesFiles.length < _imagesUrl.length
                                      ? _imagesUrl[i - _imagesFiles.length]
                                      : null),
                          itemCount: _imagesFiles.length + _imagesUrl.length,
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                CustomInkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                _emptyImage ? Colors.red : Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/images/addmore.png",
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Add Image",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_cityId == 0)
                        setState(() {
                          _emptyCity = true;
                          Fluttertoast.showToast(msg:"Select Your City");
                        });
                      if (_imagesUrl.length + _imagesFiles.length == 0)
                        setState(() {
                          _emptyImage = true;
                          Fluttertoast.showToast(msg: "Add an Image");
                        });
                      if (!_formKey.currentState.validate()) return;
                      if (_cityId == 0 ||
                          _imagesUrl.length + _imagesFiles.length == 0) return;
                      _formKey.currentState.save();
                      List<String> _uploaded = [];
                      if (_imagesFiles.length > 0)
                        _uploaded = await adController.uploadFiles(context,
                            files: _imagesFiles);
                      _uploaded..addAll(_imagesUrl);
                      print(_uploaded);
                      await adController.uploadAd(
                        context,
                        title: _title.text.trim(),
                        price: _price.text.trim(),
                        note: _note.text.trim(),
                        images: _uploaded,
                        cityId: _cityId,
                        id: widget.adModel != null ? widget.adModel.id : null,
                        age: _age.text != null ? _age.text.trim() : null,
                        area: _area.text != null ? _area.text.trim() : null,
                        district: _district.text != null
                            ? _district.text.trim()
                            : null,
                        street:
                            _street.text != null ? _street.text.trim() : null,
                        propertyType:
                            _propertyType != null ? _propertyType.trim() : null,
                        lift: _lift != null ? _lift.trim() : null,
                        kitchen: _kitchen != null ? _kitchen.trim() : null,
                        familyOrSingle: _familyOrSingle != null
                            ? _familyOrSingle.trim()
                            : null,
                        vellaOrapartment: _vellaOrApartment != null
                            ? _vellaOrApartment.trim()
                            : null,
                        pool: _pool != null ? _pool.trim() : null,
                        garage: _garage != null ? _garage.trim() : null,
                        room: _room.text != null ? _room.text.trim() : null,
                        bath: _baths.text != null ? _baths.text.trim() : null,
                        landType: _landType.text != null
                            ? _landType.text.trim()
                            : null,
                        meterPrice: _meterPrice.text != null
                            ? _meterPrice.text.trim()
                            : null,
                        postalCode:
                            _postal.text != null ? _postal.text.trim() : null,
                        location: adController.adLocationData != null
                            ? adController.adLocationData[0].trim()
                            : null,
                        latLng: adController.adLocationData != null
                            ? adController.adLocationData[1]
                            : null,
                      );
                    },
                    child: Text(
                        widget.adModel != null ? "Update Ad" : "Upload Ad"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildImageBox({int pos, String url, File file}) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: ExtendedImage(
                  image: file != null ? FileImage(file) : NetworkImage(url),
                  enableLoadState: true,
                )),
            IconButton(
                icon: Icon(Icons.close),
                color: appDesign.white,
                onPressed: () {
                  setState(() {
                    file != null
                        ? _imagesFiles.removeAt(pos)
                        : _imagesUrl.removeAt(pos - _imagesFiles.length);
                    if (_imagesFiles.length + _imagesUrl.length == 0)
                      _emptyImage = true;
                  });
                })
          ],
        ));
  }
}

class NormalradioButton extends StatelessWidget {
  Function onTap;
  String text;
  var kind;
  var groupKind;
  NormalradioButton({this.kind, this.text, this.onTap, this.groupKind});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            kind == groupKind
                ? Icon(
                    Icons.radio_button_checked,
                    color: Colors.blue,
                    size: 22,
                  )
                : Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: 22,
                  ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  height: 2,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:aqar/model/userModel.dart';

class AdModel {
  String title,
      note,
      area,
      district,
      street,username,
      postalCode,
      nearPlaces,
      propertyType,//rent/won
      address
      ; // for property
  String buildingAge,
      lift,
      room,
      bath,
      kitchen,
      socialStatus,//familyor
      buildingType,//Villaor
      pool,
      garage; // for general
  double meterPrice;
  String landType; // for land
  int id;
  bool isFavourite;
  String image;
  List<String> images;
  List<AdModel> similarAds;
  String status;
  double price,lat,lng;
  UserModel user;
  CityModel city;
  String createdAt;
  String published;
  String url;
  List<CommentModel> comments;
  AdModel(
      {this.id,
      this.buildingAge,
      this.propertyType,
      this.area,
      this.bath,
      this.note,this.username,
      this.district,
      this.socialStatus,
      this.garage,
      this.nearPlaces,
      this.address,
      this.kitchen,
      this.landType,
      this.meterPrice,
      this.lift,
      this.pool,
      this.postalCode,
      this.buildingType,
      this.street,
      this.room,
      this.lat,
      this.lng,
      this.similarAds,
      this.isFavourite,
      this.price,
      this.images,
      this.status,
      this.user,
      this.city,
      this.published,
      this.url,
      this.comments,
      this.image,
      this.createdAt,
      this.title});
  factory AdModel.fromJson(Map<String, dynamic> json, {bool card}) {
    List<AdModel> _similar = [];
    List<String> _images = [];
    List<CommentModel> _comments = [];
    if (json['similar_ads'] != null) {
      for (Map<String, dynamic> ad in json['similar_ads'])
        _similar.add(AdModel.fromJson(ad));
    }
    if (json['comments'] != null) {
      for (Map<String, dynamic> comment in json['comments'])
        _comments.add(CommentModel.fromJson(comment));
    }

    if (json['images'] != null) {
      for (var image in json['images']) _images.add(image.toString());
    }

    return AdModel(
        id: int.tryParse(json['id'].toString()),
        city: card != null
            ? CityModel(name: json['city'])
            : CityModel.fromJson(json['city']),
        image: json['image'],
        images: _images,
        area: json['area'],
        bath:json['bath'],
        username: json['username'],
        buildingAge: json['building_age'],
        buildingType: json['building_type'],
        district: json['district'],
        garage: json['garage'],
        kitchen: json['kitchen'],
        landType: json['land_type'],
        lat:double.tryParse(json['lat'].toString()),
        lift: json['lift'],
        lng:double.tryParse(json['lng'].toString()),
        address: json['address'],
        meterPrice:double.tryParse(json['meter_price'].toString()),
        note: json['note'],
        pool: json['pool'],
       nearPlaces: json['near_places'],
        postalCode: json['postal_code'],
        propertyType: json['property_type'],
        room: json['room'],
        socialStatus: json['social_status'],
        street: json['street'],
        status: json['status'],
        isFavourite: json['is_favourite'].toString() == "true",
        similarAds: _similar,
        comments: card != null ? null : _comments,
        published: json['published'],
        url: json['url'],
        price: double.tryParse(json['price'].toString()) ?? 0,
        user: card != null
            ? UserModel(firstName: json['firstName'])
            : UserModel.fromMapModel(json['user']),
        createdAt: json['created_at'],
        title: json['title']);
  }
}

class CommentModel {
  int id;
  UserModel user;
  String comment;
  String published;

  CommentModel({this.id, this.comment, this.published, this.user});
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        id: json['id'],
        comment: json['comment'],
        published: json['published'],
        user: UserModel.fromMapModel(json['user']));
  }
}

class AdType {
  int id;
  String name;

  AdType({this.id, this.name});
  factory AdType.fromJson(Map<String, dynamic> json) {
    return AdType(id: json['id'], name: json['name']);
  }
}

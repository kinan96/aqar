class SettingsModel{
   String licence;
  String android;
  String ios;
  String whatsapp;
  String facebook;
  String blockedAds;
  String instagram;
  String twitter;
  String snapchat;
  String contact;
  String about;
  String percent;
  double percentRatio;
  SettingsModel(
      {this.android,
      this.contact,
      this.facebook,this.blockedAds,
      this.instagram,
      this.ios,
      this.licence,
      this.about,
      this.percent,
      this.percentRatio,
      this.snapchat,
      this.twitter,
      this.whatsapp});
      factory SettingsModel.fromJson(Map<String,dynamic>json){
        return SettingsModel(
          android: json['android'],
          contact: json['contact'],
          facebook: json['facebook'],
          instagram: json['instagram'],
          ios: json['ios'],
          about: json['about'],
          licence: json['licence'],
          percent: json['percent'],
          blockedAds: json['block'],
          percentRatio: (double.tryParse(json['percent_ratio'].toString())??0)/100,
          snapchat: json['snapchat'],
           twitter: json['twitter'],
           whatsapp: json['whatsapp']
        );
      }
}
import 'package:aqar/model/adModel.dart';
import 'package:rxdart/rxdart.dart';

class FilterController{
  BehaviorSubject<List<AdModel>> _adsAfterFilter = BehaviorSubject<List<AdModel>>();
  Function(List<AdModel>) get changeadsAfterFilter => _adsAfterFilter.sink.add;
  List<AdModel> get adsAfterFilter => _adsAfterFilter.value;
  Stream<List<AdModel>> get adsAfterFilterStream => _adsAfterFilter.stream;
  
  
  BehaviorSubject<String> _title = BehaviorSubject<String>();
  Function(String) get changetitle => _title.sink.add;
  String get title => _title.value;
  Stream<String> get titleStream => _title.stream;



  BehaviorSubject<String> _rentOrSale = BehaviorSubject<String>();
  Function(String) get changerentOrSale => _rentOrSale.sink.add;
  String get rentOrSale => _rentOrSale.value;
  Stream<String> get rentOrSaleStream => _rentOrSale.stream;
  BehaviorSubject<String> _propertyType = BehaviorSubject<String>();
  Function(String) get changepropertyType => _propertyType.sink.add;
  String get propertyType => _propertyType.value;
  Stream<String> get propertyTypeStream => _propertyType.stream;
  BehaviorSubject<String> _familyOrSingle = BehaviorSubject<String>();
  Function(String) get changefamilyOrSingle => _familyOrSingle.sink.add;
  String get familyOrSingle => _familyOrSingle.value;
  Stream<String> get familyOrSingleStream => _familyOrSingle.stream;


  BehaviorSubject<int> _priceFrom = BehaviorSubject<int>();
  Function(int) get changepriceFrom => _priceFrom.sink.add;
  int get priceFrom => _priceFrom.value;
  Stream<int> get priceFromStream => _priceFrom.stream;
  BehaviorSubject<int> _priceTo = BehaviorSubject<int>();
  Function(int) get changepriceTo => _priceTo.sink.add;
  int get priceTo => _priceTo.value;
  Stream<int> get priceToStream => _priceTo.stream;
  BehaviorSubject<int> _meterPriceFrom = BehaviorSubject<int>();
  Function(int) get changemeterPriceFrom => _meterPriceFrom.sink.add;
  int get meterPriceFrom => _meterPriceFrom.value;
  Stream<int> get meterPriceFromStream => _meterPriceFrom.stream;
  BehaviorSubject<int> _meterPriceTo = BehaviorSubject<int>();
  Function(int) get changemeterPriceTo => _meterPriceTo.sink.add;
  int get meterPriceTo => _meterPriceTo.value;
  Stream<int> get meterPriceToStream => _meterPriceTo.stream;
  BehaviorSubject<int> _areaFrom = BehaviorSubject<int>();
  Function(int) get changeareaFrom => _areaFrom.sink.add;
  int get areaFrom => _areaFrom.value;
  Stream<int> get areaFromStream => _areaFrom.stream;
  BehaviorSubject<int> _areaTo = BehaviorSubject<int>();
  Function(int) get changeareaTo => _areaTo.sink.add;
  int get areaTo => _areaTo.value;
  Stream<int> get areaToStream => _areaTo.stream;
  BehaviorSubject<int> _ageFrom = BehaviorSubject<int>();
  Function(int) get changeageFrom => _ageFrom.sink.add;
  int get ageFrom => _ageFrom.value;
  Stream<int> get ageFromStream => _ageFrom.stream;
  BehaviorSubject<int> _ageTo = BehaviorSubject<int>();
  Function(int) get changeageTo => _ageTo.sink.add;
  int get ageTo => _ageTo.value;
  Stream<int> get ageToStream => _ageTo.stream;

  BehaviorSubject<int> _roomFrom = BehaviorSubject<int>();
  Function(int) get changeroomFrom => _roomFrom.sink.add;
  int get roomFrom => _roomFrom.value;
  Stream<int> get roomFromStream => _roomFrom.stream;
  BehaviorSubject<int> _roomTo = BehaviorSubject<int>();
  Function(int) get changeroomTo => _roomTo.sink.add;
  int get roomTo => _roomTo.value;
  Stream<int> get roomToStream => _roomTo.stream;
  BehaviorSubject<int> _bathFrom = BehaviorSubject<int>();
  Function(int) get changebathFrom => _bathFrom.sink.add;
  int get bathFrom => _bathFrom.value;
  Stream<int> get bathFromStream => _bathFrom.stream;
  BehaviorSubject<int> _bathTo = BehaviorSubject<int>();
  Function(int) get changebathTo => _bathTo.sink.add;
  int get bathTo => _bathTo.value;
  Stream<int> get bathToStream => _bathTo.stream;

  BehaviorSubject<bool> _garage = BehaviorSubject<bool>();
  Function(bool) get changegarage => _garage.sink.add;
  bool get garage => _garage.value;
  Stream<bool> get garageStream => _garage.stream;
  BehaviorSubject<bool> _pool = BehaviorSubject<bool>();
  Function(bool) get changepool => _pool.sink.add;
  bool get pool => _pool.value;
  Stream<bool> get poolStream => _pool.stream;
  BehaviorSubject<bool> _kitchen = BehaviorSubject<bool>();
  Function(bool) get changekitchen => _kitchen.sink.add;
  bool get kitchen => _kitchen.value;
  Stream<bool> get kitchenStream => _kitchen.stream;
  BehaviorSubject<bool> _lift = BehaviorSubject<bool>();
  Function(bool) get changelift => _lift.sink.add;
  bool get lift => _lift.value;
  Stream<bool> get liftStream => _lift.stream;

  dispose(){
    _lift.close();
    _adsAfterFilter.close();
    _kitchen.close();
    _pool.close();
_priceFrom.close();
_rentOrSale.close();
_ageTo.close();
_meterPriceFrom.close();
_meterPriceTo.close();
_ageFrom.close();
_roomTo.close();
_roomFrom.close();
_bathFrom.close();
_bathTo.close();
_garage.close();
_priceTo.close();
_areaFrom.close();
_familyOrSingle.close();
_propertyType.close();
_areaTo.close();
  }
}
FilterController filterController = FilterController();
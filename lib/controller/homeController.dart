import 'package:aqar/view/homeBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class HomeController{
  BehaviorSubject<int> _selectedBNBItem = BehaviorSubject<int>();
  Function(int) get changeSelectedBNBItem => _selectedBNBItem.sink.add;
  int get selectedBNBItem => _selectedBNBItem.value;
  Stream<int> get selectedBNBItemStream => _selectedBNBItem.stream;
  BehaviorSubject<bool> _hasNewNotifi = BehaviorSubject<bool>();
  Function(bool) get changehasNewNotifi => _hasNewNotifi.sink.add;
  bool get hasNewNotifi => _hasNewNotifi.value;
  Stream<bool> get hasNewNotifiStream => _hasNewNotifi.stream;
  dispose() {
    _selectedBNBItem.close();
    _hasNewNotifi.close();
  }

}
HomeController homeController=HomeController();
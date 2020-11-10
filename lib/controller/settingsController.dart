import 'package:aqar/controller/base_url.dart';
import 'package:aqar/controller/shared_preferences_helper.dart';
import 'package:aqar/model/settingsModel.dart';
import 'package:aqar/model/userModel.dart';
import 'package:dio/dio.dart';

class SettingController {
 SettingsModel settingsModel;
  Future<SettingsModel> getSettings() async {
    try {
      Response response = await Dio().get("$baseUrl/setting",
          options: Options(
            ));
      if (response.data['status'] == 200) {
        settingController.settingsModel=SettingsModel.fromJson(response.data['data']);
        return SettingsModel.fromJson(response.data['data']);
      } else if (response.data['status'] == 400) {

      } else if (response.data['status'] == 401) {
        await removeSharedOfKey("savedUser");
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}

SettingController settingController = SettingController();

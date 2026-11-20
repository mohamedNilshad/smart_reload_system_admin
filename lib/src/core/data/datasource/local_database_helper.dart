
import 'dart:developer';

import 'package:smart_reload_system_admin/src/core/constants/app_strings.dart';
import 'package:smart_reload_system_admin/src/core/constants/constant.dart';
import 'package:smart_reload_system_admin/src/core/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelperDatasource{
  SharedPreferences prefs;
  DatabaseHelperDatasource(this.prefs);

  Future<bool> saveLocalData({required String key, required String value}) async {
    try{
      await prefs.setString(key, value);
      return true;
    }catch(e, st){
      log(e.toString(), error: e, stackTrace: st);
      return false;
    }
  }

  Future<String?> getLocalData({required String key}) async {
    try{
      String? result = prefs.getString(key);
      return result;
    }catch(e, st){
      log(e.toString(), error: e, stackTrace: st);
      return e.toString();
    }
  }

  Future<bool> isLoginSessionExpired() async {
    String? time = await getLocalData(key: AppStrings.lastClosedTimestampKey);
    if(time != null){
      final now = DateTime.now();
      return HelperFunctions.isTimeDifferenceMoreThan(DateTime.parse(time), now, minutesThreshold: expireMinute);
    }
    return false;
  }

}
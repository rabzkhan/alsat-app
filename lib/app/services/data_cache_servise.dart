import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class DataCacheService {
  DataCacheService({required this.apiEndPoint});

  final String apiEndPoint;

  Future<dynamic> getData() async {
    String endpointValueKey = '$apiEndPoint/value';
    int? saveTime = await getValueTime();
    if (saveTime == null) {
      return null;
    }
    if (saveTime > DateTime.now().microsecondsSinceEpoch) {
      setValueTime(expiryTimeMinute: 0);
      setData(null);
      return null;
    }

    final localBD = await SharedPreferences.getInstance();
    log("${localBD.getString(endpointValueKey)}");
    String? savedStringJSON = localBD.getString(endpointValueKey);
    if (savedStringJSON == null) {
      return null;
    }
    dynamic savedJSON = json.decode(savedStringJSON);
    return savedJSON;
  }

  Future<int?> getValueTime() async {
    String endpointDateKey = '$apiEndPoint/date';
    final localBD = await SharedPreferences.getInstance();
    int? savedValueTime = localBD.getInt(endpointDateKey);
    return savedValueTime;
  }

  Future<bool> setValueTime({int expiryTimeMinute = 2}) async {
    String endpointDateKey = '$apiEndPoint/date';
    final localBD = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    return await localBD.setInt(endpointDateKey,
        now.add(Duration(minutes: expiryTimeMinute)).millisecondsSinceEpoch);
  }

  Future setData(dynamic map, {int expiryTimeMinute = 2}) async {
    String endpointDateKey = '$apiEndPoint/value';
    final localBD = await SharedPreferences.getInstance();
    if (map == null) {
      localBD.remove(endpointDateKey);
      return true;
    } else {
      String jsonString = json.encode(map);
      bool result = await localBD.setString(endpointDateKey, jsonString);
      result = await setValueTime(expiryTimeMinute: expiryTimeMinute);
      return result;
    }
  }
}

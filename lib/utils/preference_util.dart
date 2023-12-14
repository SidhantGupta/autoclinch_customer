import 'dart:convert';

import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:map_place_picker/map_place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  SharedPreferenceUtil._();
  static final SharedPreferenceUtil _instance = SharedPreferenceUtil._();
  factory SharedPreferenceUtil() {
    return _instance;
  }

  Future<bool> storeUserDetails(LoginData? logindata) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String? user = jsonEncode(logindata?.toJson());
    //debugPrint('MJM storeUserDetails: user: $user');
    return sharedUser.setString('user', user);
  }

  Future<LoginData?> getUserDetails() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic>? userMap;
    try {
      userMap = jsonDecode(sharedUser.getString('user') ?? "");
    } catch (e) {
      return null;
    }
    return userMap != null ? LoginData.fromJson(userMap) : null;
  }

  Future<bool> storeToken(String? token) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // String? _token_data = jsonEncode(token?.toJson());
    //debugPrint('MJM storeUserDetails: user: $token');
    return sharedUser.setString('token', token!);
  }

  Future<String> getToken() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String token = "";
    token = sharedUser.getString('token') ?? "";

    return token;
  }

  Future<bool> storeVehicleName(String? token) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // String? _token_data = jsonEncode(token?.toJson());
    //debugPrint('MJM storeUserDetails: user: $token');
    return sharedUser.setString('vname', token!);
  }

  Future<String> getVehicleName() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String token = "";
    token = sharedUser.getString('vname') ?? "";

    return token;
  }

  Future<bool> storeEmergencyName(String? token) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // String? _token_data = jsonEncode(token?.toJson());
    //debugPrint('MJM storeUserDetails: user: $token');
    return sharedUser.setString('emname', token!);
  }

  Future<String> getEmergencyName() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String token = "";
    token = sharedUser.getString('emname') ?? "";

    return token;
  }

  Future<bool> storeEmergencyNumber(String? token) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    // String? _token_data = jsonEncode(token?.toJson());
    //debugPrint('MJM storeUserDetails: user: $token');
    return sharedUser.setString('emnumber', token!);
  }

  Future<String> getEmergencyNumber() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String token = sharedUser.getString('emnumber') ?? "";

    return token;
  }

  Future<bool> storeMapAddress(MapAddress? mapAddress) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String? mapAddresStr = jsonEncode(mapAddress?.toJson());
    //debugPrint('MJM storeMapAddress: map_address: $mapAddresStr');
    return sharedUser.setString('map_address', mapAddresStr);
  }

  Future<MapAddress?> getMapAddress() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    Map<String, dynamic>? userMap;
    try {
      userMap = jsonDecode(sharedUser.getString('map_address') ?? "");
    } catch (e) {
      return null;
    }
    return userMap != null ? MapAddress.fromJson(userMap) : null;
  }

  Future<bool> storeServiceType(String type) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.setString('service_type', type);
  }

  Future<String> getServiceType() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getString('service_type') ?? "";
  }
}

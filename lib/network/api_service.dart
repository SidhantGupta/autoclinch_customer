import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/network/model/register_response.dart';
import 'package:autoclinch_customer/network/model/service_history.dart';
import 'package:autoclinch_customer/network/model/service_model.dart';
import 'package:autoclinch_customer/network/model/vehicle_model.dart';
import 'package:autoclinch_customer/screens/home/bookings_screen.dart';
import 'package:autoclinch_customer/utils/constants.dart' show BASE_URL;
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '/network/model/help_faq_response.dart' show HelpFaqResponse;
import '/network/model/home_response.dart' show HomeResponse;
import '/network/model/payments_outstanding_response.dart' show PaymentOutstandingResponse;
import '/network/model/payments_vehicle_response.dart' show PaymentVehicleResponse;
import '/network/model/trackig_response.dart' show TrackingReponse;
import '/notifiers/loader_notifier.dart' show LoadingNotifier;
import 'model/GetPackageResponse.dart';
import 'model/allreviews_response.dart';
import 'model/attendence.dart';
import 'model/bookings_response.dart';
import 'model/forgot_pwd_response.dart';
import 'model/purchase_model.dart';
import 'model/vehiclelist_response.dart';
import 'model/vendor_details_response.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService _instance = ApiService._privateConstructor();
  factory ApiService() {
    return _instance;
  }

  final String API_URL = '${BASE_URL}api/v1/';

  BuildContext? context;

  http.MultipartRequest getMultipartRequest(
    final String _url, {
    bool isAddCustomerToUrl = true,
  }) {
    String url = apiUrl(_url, isAddCustomerToUrl);
    return http.MultipartRequest("POST", Uri.parse(url));
  }

  Future<T?> execute<T>(final String _url,
      {Map? params,
      bool isGet = false,
      bool showSuccessAlert = false,
      LoadingNotifier? loadingNotifier,
      http.MultipartRequest? multipartRequest,
      bool isThrowExc = false,
      bool isAddCustomerToUrl = true}) async {
    if (await checkInternet() == false) {
      if (isThrowExc) {
        return Future.error("No Internet Connection");
      }
      showToast("No Internet Connection");
      return null;
    }
    loadingNotifier?.isLoading = true;
    String url = apiUrl(_url, isAddCustomerToUrl);
    if (params == null) {
      params = Map();
    }

    params.removeWhere((key, value) => value == null);

    final header = <String, String>{};
    var user = await SharedPreferenceUtil().getUserDetails();
    if (user?.token != null && user!.token!.trim().isNotEmpty) {
      header['Authorization'] = 'Bearer ${user.token}';
    }

    // log("api headers: $header");

    Uri uri = Uri.parse(url);
    if (kDebugMode) log(uri.toString());
    http.Response resp;
    if (multipartRequest != null) {
      multipartRequest.headers.addAll(header);
      // multipartRequest.fields.removeWhere((key, value) => value == null);
      // _printMultipartParameters(multipartRequest);
      var response = await multipartRequest.send();
      resp = await http.Response.fromStream(response);
    } else {
      // log("api url: $url \n params: $params");
      resp = await (isGet ? http.get(uri, headers: header) : http.post(uri, body: params, headers: header));
    }
    String response = resp.body.trim().isNotEmpty ? resp.body : "{}";
    log(" $url $response");

    var responseJson;
    try {
      responseJson = json.decode(response);
    } catch (e) {
      loadingNotifier?.isLoading = false;

      // throw Exception(e);
    }

    if (responseJson == null) {
      if (isThrowExc) {
        return Future.error("Something went wrong!");
      }
      showToast("Something went wrong!");
      return null;
    }

// responseJson['isExpired'] is bool &&
    if (responseJson['isExpired'] == true && context != null) {
      Navigator.of(context!).pushNamedAndRemoveUntil('/login', (route) => false);
      if (isThrowExc) {
        return Future.error("Token Expired!");
      }
      return null;
    }

    String? _message;
    if (responseJson['message'] is String) {
      _message = responseJson['message'];
    }

    bool isSuccess = responseJson['success'] ?? responseJson['status'] ?? true;
    if (showSuccessAlert && context != null && isSuccess) {
      showAlert(_message);
    } else {
      showToast(_message);
    }
    loadingNotifier?.isLoading = false;

    return fromJsonToModel<T>(responseJson);
  }

  String apiUrl(final String url, bool isAddCustomerToUrl) {
    String _url = url;
    if (!url.startsWith("http")) {
      _url = "$API_URL${isAddCustomerToUrl ? 'customerapp/' : ''}$url";
    }
    return _url;
  }

  // void _printMultipartParameters(http.MultipartRequest multipartRequest) {
  //   debugPrint("mulipart url: ${multipartRequest.url.toString()} \n params: " + multipartRequest.fields.toString());
  //   multipartRequest.files.forEach((element) {
  //     debugPrint("params mulipart file: ${element.field} : ${element.filename} contentType: ${element.contentType}");
  //   });
  // }

  // void printWrapped(String text) {
  //   debugPrint('Response: ');
  //   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  //   pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  // }

  // T fromJsonToModel<T, K>(dynamic json) {
  T fromJsonToModel<T>(dynamic json) {
    // if (json is Iterable) {
    //   return _fronJsonToList<K>(json as List?) as T;
    // } else {
    json as Map<String, dynamic>;
    if (T == CommonResponse) {
      return CommonResponse.fromJson(json) as T;
    } else if (T == LoginResponse) {
      return LoginResponse.fromJson(json) as T;
    } else if (T == RegisterResponse) {
      return RegisterResponse.fromJson(json) as T;
    } else if (T == ForgotPasswordResponse) {
      return ForgotPasswordResponse.fromJson(json) as T;
    } else if (T == CommonResponse2) {
      return CommonResponse2.fromJson(json) as T;
    } else if (T == HomeResponse) {
      return HomeResponse.fromJson(json) as T;
    } else if (T == VendorDetailsResponse) {
      return VendorDetailsResponse.fromJson(json) as T;
    } else if (T == VehicleListModel) {
      return VehicleListModel.fromJson(json) as T;
    } else if (T == HelpFaqResponse) {
      return HelpFaqResponse.fromJson(json) as T;
    } else if (T == BookingResponse) {
      return BookingResponse.fromJson(json) as T;
    } else if (T == AllReviewResponse) {
      return AllReviewResponse.fromJson(json) as T;
    } else if (T == PaymentVehicleResponse) {
      return PaymentVehicleResponse.fromJson(json) as T;
    } else if (T == TrackingReponse) {
      return TrackingReponse.fromJson(json) as T;
    } else if (T == PaymentOutstandingResponse) {
      return PaymentOutstandingResponse.fromJson(json) as T;
    } else if (T == StatusModel) {
      return StatusModel.fromJson(json) as T;
    } else if (T == ServiceModel) {
      return ServiceModel.fromJson(json) as T;
    } else if (T == AttendanceModel) {
      return AttendanceModel.fromJson(json) as T;
    } else if (T == PaymentModel) {
      return PaymentModel.fromJson(json) as T;
    } else if (T == VehicleModel) {
      return VehicleModel.fromJson(json) as T;
    } else if (T == ServiceHistoryModel) {
      return ServiceHistoryModel.fromJson(json) as T;
    } else if (T == GetPackageResponse) {
      return GetPackageResponse.fromJson(json) as T;
    } else {
      //debugPrint('MJM Api response model not added');
      return json as T;
    }

    // }
  }

  Future<bool> checkInternet() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ////('connected');
        isConnected = true;
      }
    } on SocketException catch (_) {
      // ////('not connected');
      isConnected = false;
    }
    return isConnected;
  }

  void showToast(String? message) {
    if (message == null || message.trim().isEmpty || message.trim().toLowerCase() == 'success') {
      return;
    }
    try {
      Fluttertoast.cancel();
    } catch (e) {}
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showAlert(String? message) {
    if (context == null || message == null || message.trim().isEmpty) {
      return;
    }
    try {
      showDialog(
        context: context!,
        builder: (context) => AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))],
        ),
      );
    } catch (e) {}
  }

  List<K> _fronJsonToList<K>(List? jsonList) {
    List<K> output = List.empty();
    if (jsonList != null) {
      for (Map<String, dynamic> json in jsonList) {
        output.add(fromJsonToModel(json));
      }
    }
    return output;
  }
}

import '/network/model/vehiclelist_response.dart' show VehicleData;

class PaymentVehicleResponse {
  final bool success;
  final PaymentVehicleData? data;

  PaymentVehicleResponse({required this.success, required this.data});

  factory PaymentVehicleResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVehicleResponse(
        success: json['success'], data: json['data'] == null ? null : PaymentVehicleData.fromjson(json['data']));
  }
}

class PaymentVehicleData extends PaymentGatewaysData {
  final String tempId, totalAmount, timeout, requestId, bookingId;
  final bool? isAccepted;
  final List<VehicleData> vehicles;

  PaymentVehicleData(
      {required this.tempId,
      required this.requestId,
      required this.totalAmount,
      required this.bookingId,
      required this.vehicles,
      required this.isAccepted,
      required RazorpayCheck? razorpay,
      required this.timeout,
      required GpayUpi? gpay})
      : super(
          gpay: gpay,
          razorpay: razorpay,
        );

  factory PaymentVehicleData.fromjson(Map<String, dynamic> json) {
    return PaymentVehicleData(
      tempId: json['temp_id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '',
      bookingId: json['booking_id_new']?.toString() ?? '',
      timeout: json['timeout']?.toString() ?? '3',
      isAccepted: json['is_accepted'],
      gpay: json['gpay'] != null ? GpayUpi.fromjson(json['gpay']) : null,
      razorpay: json['razorpay'] != null ? RazorpayCheck.fromjson(json['razorpay']) : null,
      vehicles: (json['vehicle_list'] is Iterable)
          ? (json['vehicle_list'] as Iterable).map((e) => VehicleData.fromJson(e)).toList()
          : [],
    );
  }

  void repolaceVehicles(List<VehicleData> _vehicles) {
    if (_vehicles.isNotEmpty) {
      vehicles.clear();
      vehicles.addAll(_vehicles);
    }
  }
}

abstract class PaymentGatewaysData {
  final GpayUpi? gpay;
  final RazorpayCheck? razorpay;

  PaymentGatewaysData({this.gpay, this.razorpay});
}

class GpayUpi {
  final bool isEnabled;
  final String upiId;

  GpayUpi({required this.isEnabled, required this.upiId});

  factory GpayUpi.fromjson(Map<String, dynamic> json) {
    return GpayUpi(
      isEnabled: json['is_enabled'],
      upiId: json['upi_id']?.toString() ?? '',
    );
  }
}

class RazorpayCheck {
  final bool isEnabled;
  final String id;

  RazorpayCheck({required this.isEnabled, required this.id});

  factory RazorpayCheck.fromjson(Map<String, dynamic> json) {
    return RazorpayCheck(
      isEnabled: json['is_enabled'],
      id: json['id']?.toString() ?? '',
    );
  }
}

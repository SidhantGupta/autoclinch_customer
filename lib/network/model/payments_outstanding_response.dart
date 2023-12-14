import 'package:autoclinch_customer/network/model/payments_vehicle_response.dart';


class PaymentOutstandingResponse {
  final bool success;
  final PaymentOutstandingData? data;

  PaymentOutstandingResponse({required this.success, required this.data});

  factory PaymentOutstandingResponse.fromJson(Map<String, dynamic> json) {
    return PaymentOutstandingResponse(success: json['success'], data: json['data'] == null ? null : PaymentOutstandingData.fromjson(json['data']));
  }
}

class PaymentOutstandingData extends PaymentGatewaysData {
  final String remainingAmount, amount, remarks, minAmount, serviceAmount;

  PaymentOutstandingData({
    required this.remainingAmount,
    required this.amount,
    required this.remarks,
    required this.minAmount,
    required this.serviceAmount,
    required RazorpayCheck? razorpay,
    required GpayUpi? gpay,
  }) : super(gpay: gpay, razorpay: razorpay);

  factory PaymentOutstandingData.fromjson(Map<String, dynamic> json) {
    return PaymentOutstandingData(
      remainingAmount: json['remaining_amount']?.toString() ?? '0',
      amount: json['amount']?.toString() ?? '0',
      remarks: json['vendor_remarks']?.toString() ?? '',
      minAmount: json['minimum_to_pay']?.toString() ?? '',
      serviceAmount: json['service_to_pay']?.toString() ?? '',
      gpay: json['gpay'] != null ? GpayUpi.fromjson(json['gpay']) : null,
      razorpay: json['razorpay'] != null ? RazorpayCheck.fromjson(json['razorpay']) : null,
    );
  }

  String get totalAmount => ((double.tryParse(remainingAmount) ?? 0) + (double.tryParse(amount) ?? 0)).toString();
}

// To parse this JSON data, do
//
//     final serviceHistory = serviceHistoryFromJson(jsonString);

import 'dart:convert';

ServiceHistoryModel serviceHistoryFromJson(String str) => ServiceHistoryModel.fromJson(json.decode(str));

class ServiceHistoryModel {
  ServiceHistoryModel({
    this.success,
    this.history,
    this.message,
  });

  bool? success;
  List<History>? history;
  String? message;

  factory ServiceHistoryModel.fromJson(Map<String, dynamic> json) => ServiceHistoryModel(
        success: json["success"],
        history: List<History>.from(json["data"].map((x) => History.fromJson(x))),
        message: json["message"],
      );
}

class History {
  History({
    this.id,
    this.customerId,
    this.packageId,
    this.vehicleId,
    this.amount,
    this.fromDate,
    this.toDate,
    this.title,
  });

  int? id;
  int? customerId;
  int? packageId;
  dynamic vehicleId;
  String? amount;
  DateTime? fromDate;
  DateTime? toDate;
  String? title;

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        customerId: json["customer_id"],
        packageId: json["package_id"],
        vehicleId: json["vehicle_id"],
        amount: json["amount"],
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        title: json["title"],
      );
}

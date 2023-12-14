// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

class PaymentModel {
  PaymentModel({
    this.success,
    this.purchase,
  });

  bool? success;
  Purchase? purchase;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        success: json["success"],
        purchase: Purchase.fromJson(json["data"]),
      );
}

class Purchase {
  Purchase({
    this.customerId,
    this.packageId,
    this.fromDate,
    this.toDate,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.purchaseId,
  });

  int? customerId;
  String? packageId;
  DateTime? fromDate;
  DateTime? toDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? id;
  int? purchaseId;

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
        customerId: json["customer_id"],
        packageId: json["package_id"],
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        id: json["id"],
        purchaseId: json["purchase_id"],
      );
}

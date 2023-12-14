// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));


class ServiceModel {
  ServiceModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  Data({
    this.packagePurchasehistory,
    this.packageDatas,
  });

  List<PackagePurchasehistory>? packagePurchasehistory;
  List<PackageData>? packageDatas;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        packagePurchasehistory: List<PackagePurchasehistory>.from(
            json["packagePurchasehistory"].map((x) => PackagePurchasehistory.fromJson(x))),
        packageDatas: List<PackageData>.from(json["packageDatas"].map((x) => PackageData.fromJson(x))),
      );
}

class PackageData {
  PackageData({
    this.id,
    this.title,
    this.shortDesc,
    this.description,
    this.image,
    this.price,
    this.days,
    this.isPurchased,
  });

  int? id;
  String? title;
  String? shortDesc;
  String? description;
  String? image;

  int? price;
  int? days;
  bool? isPurchased;

  factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
        id: json["id"],
        title: json["title"],
        shortDesc: json["short_desc"],
        description: json["description"],
        image: json["image"] == null ? null : json["image"],
        price: json["price"],
        days: json["days"],
        isPurchased: json["is_purchased"],
      );
}

class PackagePurchasehistory {
  PackagePurchasehistory({
    this.id,
    this.customerId,
    this.packageId,
    this.referanceNo,
    this.vehicleId,
    this.amount,
    this.paymentDoneAt,
    this.fromDate,
    this.toDate,
    this.make,
    this.rcNumber,
  });

  int? id;
  int? customerId;
  int? packageId;
  String? referanceNo;

  int? vehicleId;
  String? amount;
  DateTime? paymentDoneAt;
  DateTime? fromDate;
  DateTime? toDate;

  String? make;
  String? rcNumber;

  factory PackagePurchasehistory.fromJson(Map<String, dynamic> json) => PackagePurchasehistory(
        id: json["id"],
        customerId: json["customer_id"],
        packageId: json["package_id"],
        referanceNo: json["referance_no"] == null ? null : json["referance_no"],
        vehicleId: json["vehicle_id"] == null ? null : json["vehicle_id"],
        amount: json["amount"] == null ? null : json["amount"],
        paymentDoneAt: json["payment_done_at"] == null ? null : DateTime.parse(json["payment_done_at"]),
        fromDate: DateTime.parse(json["from_date"]),
        toDate: DateTime.parse(json["to_date"]),
        make: json["make"] == null ? null : json["make"],
        rcNumber: json["rc_number"] == null ? null : json["rc_number"],
      );
}

// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

VehicleModel vehicleModelFromJson(String str) => VehicleModel.fromJson(json.decode(str));

class VehicleModel {
  VehicleModel({
    this.success,
    this.vehicle,
    this.message,
  });

  bool? success;
  List<Vehicle>? vehicle;
  String? message;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        success: json["success"],
        vehicle: List<Vehicle>.from(json["data"].map((x) => Vehicle.fromJson(x))),
        message: json["message"],
      );
}

class Vehicle {
  Vehicle({
    this.id,
    this.rcNumber,
    this.mfdYear,
    this.customerId,
    this.image,
    this.make,
    this.model,
    this.vehicleType,
    this.fuelType,
    this.kilometer,
    this.createdAt,
  });

  int? id;
  String? rcNumber;
  int? mfdYear;
  int? customerId;
  dynamic image;
  String? make;
  String? model;
  String? vehicleType;
  String? fuelType;
  int? kilometer;
  DateTime? createdAt;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        rcNumber: json["rc_number"],
        mfdYear: json["mfd_year"],
        customerId: json["customer_id"],
        image: json["image"],
        make: json["make"],
        model: json["model"],
        vehicleType: json["vehicle_type"] == null ? null : json["vehicle_type"],
        fuelType: json["fuel_type"],
        kilometer: json["kilometer"],
        createdAt: DateTime.parse(json["created_at"]),
      );
}

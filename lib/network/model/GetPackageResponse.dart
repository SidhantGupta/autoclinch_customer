class GetPackageResponse {
  bool? success;
  Data? data;
  String? message;

  GetPackageResponse({this.success, this.data, this.message});

  GetPackageResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? vehicleType;
  String? title;
  String? shortDesc;
  String? description;
  String? image;
  int? days;
  String? isActive;
  int? price;
  List<Vehicles>? vehicles;

  Data(
      {this.id,
        this.vehicleType,
        this.title,
        this.shortDesc,
        this.description,
        this.image,
        this.days,
        this.isActive,
        this.price,
        this.vehicles});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleType = json['vehicle_type'];
    title = json['title'];
    shortDesc = json['short_desc'];
    description = json['description'];
    image = json['image'];
    days = json['days'];
    isActive = json['is_active'];
    price = json['price'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_type'] = this.vehicleType;
    data['title'] = this.title;
    data['short_desc'] = this.shortDesc;
    data['description'] = this.description;
    data['image'] = this.image;
    data['days'] = this.days;
    data['is_active'] = this.isActive;
    data['price'] = this.price;
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  int? id;
  String? rcNumber;
  int? mfdYear;
  int? customerId;
  Null? image;
  String? make;
  String? model;
  String? vehicleType;
  String? fuelType;
  int? kilometer;
  String? status;
  String? buttonTitle;
  String? end_date;

  Vehicles(
      {this.id,
        this.rcNumber,
        this.mfdYear,
        this.customerId,
        this.image,
        this.make,
        this.model,
        this.vehicleType,
        this.fuelType,
        this.kilometer,
        this.status,
        this.end_date,
        this.buttonTitle});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rcNumber = json['rc_number'];
    mfdYear = json['mfd_year'];
    customerId = json['customer_id'];
    image = json['image'];
    make = json['make'];
    model = json['model'];
    vehicleType = json['vehicle_type'];
    fuelType = json['fuel_type'];
    kilometer = json['kilometer'];
    status = json['status'];
    end_date = json['end_date'];
    buttonTitle = json['button_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rc_number'] = this.rcNumber;
    data['mfd_year'] = this.mfdYear;
    data['customer_id'] = this.customerId;
    data['image'] = this.image;
    data['make'] = this.make;
    data['model'] = this.model;
    data['vehicle_type'] = this.vehicleType;
    data['fuel_type'] = this.fuelType;
    data['kilometer'] = this.kilometer;
    data['status'] = this.status;
    data['end_date'] = this.end_date;
    data['button_title'] = this.buttonTitle;
    return data;
  }
}
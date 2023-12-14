class VehicleListModel {
  bool? success;
  List<VehicleData>? data;
  String? message;

  VehicleListModel({this.success, this.data, this.message});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<VehicleData>.empty(growable: true);
      json['data'].forEach((v) {
        data!.add(new VehicleData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class VehicleData {
  String? id;
  String? rcNumber;
  String? make;
  String? model;
  String? fuelType;
  String? kilometer;
  String? year;

  VehicleData({this.id, this.rcNumber, this.make, this.model, this.fuelType, this.kilometer, this.year});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    rcNumber = json['rc_number'];
    make = json['make'];
    model = json['model'];
    fuelType = json['fuel_type'];
    kilometer = json['kilometer']?.toString();
    year = json['mfd_year'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rc_number'] = this.rcNumber;
    data['make'] = this.make;
    data['model'] = this.model;
    data['fuel_type'] = this.fuelType;
    data['kilometer'] = this.kilometer;
    data['mfd_year'] = this.year;

    return data;
  }

  String get name => '$make $model';
}

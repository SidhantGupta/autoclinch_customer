class VehiclListSimpleResponse {
  bool? success;
  List<Data>? data;
  String? message;

  VehiclListSimpleResponse({this.success, this.data, this.message});

  VehiclListSimpleResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>.empty(growable: true);
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? make;
  String? model;

  Data({this.id, this.make, this.model});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    make = json['make'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['make'] = this.make;
    data['model'] = this.model;
    return data;
  }
}

import 'package:intl/intl.dart';

class BookingResponse {
  bool? success;
  Data? data;
  String? message;

  BookingResponse({this.success, this.data, this.message});

  BookingResponse.fromJson(Map<String, dynamic> json) {
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
  bool? status;
  List<BookingData>? ongoing;
  List<BookingData>? booked;

  Data({this.status, this.ongoing, this.booked});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['ongoing'] != null) {
      ongoing = new List<BookingData>.empty(growable: true);
      json['ongoing'].forEach((v) {
        ongoing!.add(new BookingData.fromJson(v));
      });
    }
    if (json['booked'] != null) {
      booked = new List<BookingData>.empty(growable: true);
      json['booked'].forEach((v) {
        booked!.add(new BookingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.ongoing != null) {
      data['ongoing'] = this.ongoing!.map((v) => v.toJson()).toList();
    }
    if (this.booked != null) {
      data['booked'] = this.booked!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Ongoing {
//   String? vendorName;
//   String? id;
//   String? userId;
//   String? bookingId;
//   String? dateTime;
//   String? vendorId;
//   String? status;
//   String? amount;
//   String? serviceCost;
//   String? jobStatus;

//   Ongoing(
//       {this.vendorName,
//       this.id,
//       this.userId,
//       this.bookingId,
//       this.dateTime,
//       this.vendorId,
//       this.status,
//       this.amount,
//       this.serviceCost,
//       this.jobStatus});

//   Ongoing.fromJson(Map<String, dynamic> json) {
//     vendorName = json['vendor_name'];
//     id = json['id'];
//     userId = json['user_id'];
//     bookingId = json['booking_id'];
//     dateTime = json['date_time'];
//     vendorId = json['vendor_id'];
//     status = json['status'];
//     amount = json['amount'];
//     serviceCost = json['service_cost'];
//     jobStatus = json['job_status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['vendor_name'] = this.vendorName;
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['booking_id'] = this.bookingId;
//     data['date_time'] = this.dateTime;
//     data['vendor_id'] = this.vendorId;
//     data['status'] = this.status;
//     data['amount'] = this.amount;
//     data['service_cost'] = this.serviceCost;
//     data['job_status'] = this.jobStatus;
//     return data;
//   }
// }

class BookingData {
  String? vendorName;
  String? vendorMobile;
  String? id;
  String? userId;
  String? bookingId;
  String? dateTime;
  String? vendorId;
  String? status;
  String? amount;
  String? serviceCost;
  String? jobStatus;
  String? star, _remainingAmount;
  String? rating_star;
  String? allowed_payment;
  String? is_otp_verified;
  bool? star_rate_enabled;

  // BookingData(
  //     {this.vendorName,
  //     this.id,
  //     this.userId,
  //     this.bookingId,
  //     this.dateTime,
  //     this.vendorId,
  //     this.status,
  //     this.amount,
  //     this.serviceCost,
  //     this.jobStatus,
  //     this.star,
  //     this.star_rate_enabled});

  String get getDateTime {
    if (dateTime == null || dateTime!.isEmpty) {
      return '';
    }

    DateTime? _date = DateTime.tryParse(dateTime!);

    if (_date == null) {
      return '';
    }
    // return "${_date.hour}:${_date.minute} | ${_date.toString().substring(0, 10)}";
    return DateFormat('dd MMM yyyy').format(_date) + " | " + DateFormat('hh:mm a').format(_date);
  }

  BookingData.fromJson(Map<String, dynamic> json) {
    vendorName = json['vendor_name'];
    vendorMobile = json['contact_no_1'];
    id = json['id'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    dateTime = json['date_time'];
    vendorId = json['vendor_id'];
    status = json['status'];
    amount = json['amount'];
    serviceCost = json['service_cost'];
    jobStatus = json['job_status'];
    star = json['star'];
    rating_star = json['rating_star'];
    allowed_payment = json['allowed_payment'];
    is_otp_verified = json['is_otp_verified'];
    _remainingAmount = json['remaining_amount'] ?? '0';
    star_rate_enabled = json['star_rate_enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_name'] = this.vendorName;
    data['contact_no_1'] = this.vendorMobile;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['booking_id'] = this.bookingId;
    data['date_time'] = this.dateTime;
    data['vendor_id'] = this.vendorId;
    data['status'] = this.status;
    data['amount'] = this.amount;
    data['service_cost'] = this.serviceCost;
    data['job_status'] = this.jobStatus;
    data['remaining_amount'] = this._remainingAmount;
    data['is_otp_verified'] = this.is_otp_verified;
    data['allowed_payment'] = this.allowed_payment;
    data['rating_star'] = this.rating_star;

    data['star'] = this.star;

    data['star_rate_enabled'] = this.star_rate_enabled;
    return data;
  }

  double get remainingAmount {
    double amount = 0;
    try {
      amount = double.parse(_remainingAmount ?? '0');
    } catch (e) {}
    return amount;
  }

  String get totalAmount {
    return serviceCost ?? amount ?? '0';
  }
}

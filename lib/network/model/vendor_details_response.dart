import 'package:autoclinch_customer/utils/constants.dart' show BASE_URL;

class VendorDetailsResponse {
  bool? success;
  Data? data;
  String? message;

  VendorDetailsResponse({this.success, this.data, this.message});

  VendorDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  Vendor? vendor;
  List<Images>? images;
  List<Services>? services;
  String? priceStartFrom, basePrice;
  String? _totalReview, _totalReviewCount;
  List<Reviews>? reviews;
  List<Mechanic> mechanics = List.empty();
  

  // Data(
  //     {this.vendor,
  //     this.images,
  //     this.services,
  //     this.priceStartFrom,
  //     this._totalReview,
  //     this.totalReviewCount});

  Data.fromJson(Map<String, dynamic> json) {
    vendor = json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    if (json['images'] != null) {
      images = new List<Images>.empty(growable: true);
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = new List<Services>.empty(growable: true);
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }

    if (json['reviews'] != null) {
      reviews = new List<Reviews>.empty(growable: true);
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }

    if (json['mechanics'] is Iterable) {
      mechanics = (json['mechanics'] as Iterable).map((e) => Mechanic.fromJson(e)).toList();
    }

    // Reviews

    basePrice = json['base_price']?.toString() ?? '0';
    priceStartFrom = json['price_start_from']?.toString() ?? '0';

    _totalReview = json['total_review']?.toString() ?? '0';
    _totalReviewCount = json['total_review_count']?.toString() ?? '0';
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendor != null) {
      data['vendor'] = this.vendor!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['price_start_from'] = this.priceStartFrom;
    data['total_review'] = this._totalReview;
    data['total_review_count'] = this._totalReviewCount;
    data['base_price'] = this.basePrice;

    return data;
  }

  String get totalReview => _totalReview ?? '5';
  double get totalReviewDouble => double.tryParse(totalReview) ?? 5;
  String get totalReviewCount => _totalReviewCount ?? '0';
  double get basePriceDouble => double.tryParse(basePrice ?? '0') ?? 0;
}

class Mechanic {
  final String id, name, contactNo;
  final String? address, city, photo;

  const Mechanic({required this.id, required this.name, required this.contactNo, this.address, this.city, this.photo});
  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      contactNo: json['contact_no']?.toString() ?? '',
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      photo: json['city']?.toString(),
    );
  }
}

class Vendor {
  String? id;
  String? serialNo;
  String? userId;
  String? fullName;
  String? businessName;
  String? businessAddress;
  String? serviceType;
  String? description;
  String? paymentOption;


  bool? alreadyOngoing;

  Vendor(
      {this.id,
      this.serialNo,
      this.userId,
      this.fullName,
      this.businessName,
      this.businessAddress,
      this.serviceType,
      this.description,
      this.alreadyOngoing});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    serialNo = json['serial_no'];
    userId = json['user_id'];
    fullName = json['full_name'];
    businessName = json['business_name'];
    businessAddress = json['business_address'];
    serviceType = json['service_type'];
    description = json['description'];
    alreadyOngoing = json['alreadyOngoing'];
    paymentOption = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serial_no'] = this.serialNo;
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['business_name'] = this.businessName;
    data['business_address'] = this.businessAddress;
    data['service_type'] = this.serviceType;
    data['description'] = this.description;
    data['alreadyOngoing'] = this.alreadyOngoing;
    data['payment_method'] = this.paymentOption;
    return data;
  }
}

class Images {
  String? bannerImage;

  Images({this.bannerImage});

  Images.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'];
  }

  String get imageUrl => '${BASE_URL}images/vendor/$bannerImage';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banner_image'] = this.bannerImage;
    return data;
  }
}

class Services {
  String? id;
  String? vendorId;
  String? serviceName;
  String? price;

  Services({this.id, this.vendorId, this.serviceName, this.price});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    vendorId = json['vendor_id'];
    serviceName = json['service_name'];
    price = json['price'];
  }

  String get nameWithPrice => "$serviceName - ₹$price";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    return data;
  }
}

class Reviews {
  String? customer_name;
  String? review_title;
  String? description;
  String? star;

  Reviews({this.customer_name, this.review_title, this.description, this.star});

  Reviews.fromJson(Map<String, dynamic> json) {
    customer_name = json['customer_name']?.toString();
    review_title = json['review_title'];
    description = json['description'];
    star = json['star'].toString();
  }

  // String get nameWithPrice => "$serviceName - ₹$price";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customer_name;
    data['review_title'] = this.review_title;
    data['description'] = this.description;
    data['star'] = this.star;
    return data;
  }
}

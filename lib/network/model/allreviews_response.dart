class AllReviewResponse {
  bool? success;
  Data? data;
  String? message;

  AllReviewResponse({this.success, this.data, this.message});

  AllReviewResponse.fromJson(Map<String, dynamic> json) {
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
  List<Reviews>? reviews;
  String? totalReviewStar, reviewCount;

  Data({this.reviews, this.totalReviewStar, this.reviewCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviews = new List<Reviews>.empty(growable: true);
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
    totalReviewStar = json['total_review_star']?.toString();
    reviewCount = json['review_count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['total_review_star'] = this.totalReviewStar;
    data['review_count'] = this.reviewCount;
    return data;
  }
}

class Reviews {
  String? customerName;
  String? businessName;
  int? id;
  String? vendorId;
  String? customerId;
  String? star;
  String? reviewTitle;
  String? description;
  String? userrequestId;

  Reviews(
      {this.customerName,
      this.businessName,
      this.id,
      this.vendorId,
      this.customerId,
      this.star,
      this.reviewTitle,
      this.description,
      this.userrequestId});

  Reviews.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    businessName = json['business_name'];
    id = json['id'];
    vendorId = json['vendor_id'].toString();
    customerId = json['customer_id'].toString();
    star = json['star'].toString();
    reviewTitle = json['review_title'].toString();
    description = json['description'];
    userrequestId = json['userrequest_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['business_name'] = this.businessName;
    data['id'] = this.id;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['star'] = this.star;
    data['review_title'] = this.reviewTitle;
    data['description'] = this.description;
    data['userrequest_id'] = this.userrequestId;
    return data;
  }
}

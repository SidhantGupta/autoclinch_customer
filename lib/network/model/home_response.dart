class HomeResponse {
  final bool success;
  final String? message;
  final HomeData? homeData;

  HomeResponse({required this.message, required this.success, required this.homeData});

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    HomeData? _homeData;

    if (json['data'] != null) {
      _homeData = HomeData.fromJson(json['data']);
    }
    return HomeResponse(
      success: json['success'],
      message: json['message'],
      homeData: _homeData,
    );
  }
}

class HomeData {
  final List<Vendor>? vendorList;
  final List<FilterService>? filterServiceList;

  HomeData({required this.vendorList, required this.filterServiceList});

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      vendorList: (json['vendorList'] is Iterable)
          ? (json['vendorList'] as Iterable).map((e) => Vendor.fromJson(e)).toList()
          : [],
      filterServiceList: (json['filterServiceList'] is Iterable)
          ? (json['filterServiceList'] as Iterable).map((e) => FilterService.fromJson(e)).toList()
          : [],
    );
  }
}

class FilterService {
  final String serviceName;

  FilterService({required this.serviceName});
  factory FilterService.fromJson(Map<String, dynamic> json) {
    return FilterService(serviceName: json['service_name'] ?? '');
  }
}

class Vendor {
  final VendorDetails businessInfo;
  final TrackInfo? trackInfo;
  final String? mTotalReview;

  Vendor({
    required this.businessInfo,
    this.trackInfo,
    this.mTotalReview,
  });
  // "reviews": [],
  //   "trackInfo": null
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
        businessInfo: VendorDetails.fromJson(json['businessInfo']),
        mTotalReview: json['reviewCount']?.toString() ?? '5',
        trackInfo: json['trackInfo'] != null ? TrackInfo.fromJson(json['trackInfo']) : null);
  }

  bool get isOnline => trackInfo?.isTracking?.toLowerCase() == 'yes';

  double get rating => double.tryParse(mTotalReview ?? '5') ?? 5;
}

class TrackInfo {
  final String? isTracking;
  factory TrackInfo.fromJson(Map<String, dynamic> json) {
    return TrackInfo(isTracking: json['is_tracking']);
  }

  TrackInfo({this.isTracking});
}

class VendorDetails {
  final String? serialNo, id, userId, email, contactNo1, address, businessAddress, lat, lng, distance;
  String? is_verified, profileImage;

  final String? businessName, fullName;
  VendorDetails({
    required this.id,
    required this.serialNo,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.contactNo1,
    required this.address,
    required this.businessAddress,
    required this.lat,
    required this.lng,
    required this.distance,
    required this.businessName,
    this.is_verified,
    this.profileImage,
  });
  factory VendorDetails.fromJson(Map<String, dynamic?> json) {
    return VendorDetails(
      id: json['id']?.toString() ?? '',
      serialNo: json['serial_no'],
      userId: json['user_id'].toString(),
      fullName: json['full_name'],
      email: json['email'],
      contactNo1: json['contact_no_1'],
      address: json['address'],
      businessAddress: json['business_address'],
      lat: json['lat'],
      lng: json['lng'],
      distance: json['distance'].toString(),
      businessName: json['business_name'],
      is_verified: json['is_verified'],
      profileImage: json['profile_image'],
    );
  }

  String get distanceInt => (double.tryParse(distance!) ?? 0).toInt().toString();
}

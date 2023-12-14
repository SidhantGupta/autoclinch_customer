class TrackingReponse {
  final TrackingData data;

  TrackingReponse(this.data);
  factory TrackingReponse.fromJson(Map<String, dynamic> json) {
    return TrackingReponse(TrackingData.fromJson(json['data']));
  }
}

class TrackingData {
  final VendorCurrent? vendorCurrent;
  final VendorPermenant vendorPermenant;
  final UserLatLng? userLatLng;

  factory TrackingData.fromJson(Map<String, dynamic> json) {
    return TrackingData(
      json['vendorCurrentInfo'] != null
          ? VendorCurrent.fromJson(json['vendorCurrentInfo'])
          : null,
      VendorPermenant.fromJson(json['vendorPermenantInfo']),
      json['userLatLng'] != null
          ? UserLatLng.fromJson(json['userLatLng'])
          : null,
    );
  }

  TrackingData(this.vendorCurrent, this.vendorPermenant, this.userLatLng);
}

class VendorCurrent {
  final String lat, lng;

  VendorCurrent(this.lat, this.lng);

  factory VendorCurrent.fromJson(Map<String, dynamic> json) {
    return VendorCurrent(json['lat'], json['lng']);
  }
}

class VendorPermenant {
  final String lat, lng;
  final String? businessName, businessAddress, contactNo;

  VendorPermenant({
    required this.lat,
    required this.lng,
    required this.businessName,
    required this.businessAddress,
    required this.contactNo,
  });

  factory VendorPermenant.fromJson(Map<String, dynamic> json) {
    return VendorPermenant(
      lat: json['lat'],
      lng: json['lng'],
      businessName: json['business_name'],
      businessAddress: json['business_address'],
      contactNo: json['contact_no_1'],
    );
  }
}

class UserLatLng {
  final String lat, lng;

  UserLatLng(this.lat, this.lng);

  factory UserLatLng.fromJson(Map<String, dynamic> json) {
    return UserLatLng(json['lat'], json['lng']);
  }
}

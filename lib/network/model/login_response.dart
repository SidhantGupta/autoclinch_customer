class LoginResponse {
  final bool status;
  final String? message;
  final LoginData? data;

  LoginResponse({required this.message, required this.status, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    LoginData? _data;
    if (json['data'] != null) {
      _data = LoginData.fromJson(json['data']);
    }
    return LoginResponse(status: json['success'], message: json['message'], data: _data);
  }
}

class LoginData {
  final String? name, mobile, email, address, developedBy, developedEmail;
  final String? token, message;
  final String? socialMedia;
  final String? socialPhone;

  LoginData({
    this.name,
    this.token,
    this.mobile,
    this.email,
    this.message,
    this.address,
    this.developedBy,
    this.developedEmail,
    this.socialMedia,
    this.socialPhone,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      name: json['name'],
      token: json['token'],
      mobile: json['mobile'],
      email: json['email'],
      address: json['address'],
      message: json['message'],
      developedBy: json['developedby'],
      developedEmail: json['developedemail'],
      socialMedia: json['social_media'],
      socialPhone: json['social_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['token'] = this.token;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['message'] = this.message;
    data['developedby'] = this.developedBy;
    data['developedemail'] = this.developedEmail;
    data['social_media'] = this.socialMedia;
    data['social_phone'] = this.socialPhone;
    return data;
  }
}

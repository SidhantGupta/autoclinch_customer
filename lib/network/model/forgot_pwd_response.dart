class ForgotPasswordResponse {
  final bool status;
  final String? message;
  final LoginData? data;

  ForgotPasswordResponse(
      {required this.message, required this.status, required this.data});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    var data = LoginData.fromJson(json['data']);
    return ForgotPasswordResponse(
        status: json['success'], message: json['message'], data: data);
  }
}

class LoginData {
  final String? message;

  LoginData({
    // required this.status,
    required this.message,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {
      "message": this.message,
    };
  }
}

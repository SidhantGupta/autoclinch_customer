class CommonResponse {
  final bool status;
  final String message;

  CommonResponse({required this.message, required this.status});

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class CommonResponse2 {
  final bool success;
  final String? message;

  CommonResponse2({required this.message, required this.success});

  factory CommonResponse2.fromJson(Map<String, dynamic> json) {
    return CommonResponse2(
      success: json['success'],
      message: json['message'],
    );
  }
}

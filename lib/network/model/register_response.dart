class RegisterResponse {
  final bool status;
  final String message;

  RegisterResponse({required this.message, required this.status});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['success'],
      message: json['message'],
    );
  }
}

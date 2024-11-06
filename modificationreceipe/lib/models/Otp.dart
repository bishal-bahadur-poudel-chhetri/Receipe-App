class Otp {
  final String detail;
  final int status;

  Otp({
    required this.detail,
    required this.status,
  });
  factory Otp.fromJson(Map<String, dynamic> json) {
    return Otp(detail: json['detail'] as String, status: json['status'] as int);
  }
}
class ChangePassword {
  final String message;

  ChangePassword({
    required this.message
  });
  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(message: json['ChangePassword']);
  }
}
// homepage_event.dart
import 'dart:ffi';

import 'package:logins/models/homepage.dart';

abstract class ProfileEvent {}

class AppHomeStarted extends ProfileEvent {}


class OtpButtonClicked extends ProfileEvent {}
class OtpVerificationClicked extends ProfileEvent {
  final int userOtp;
  OtpVerificationClicked({required this.userOtp});
}


class changePasswordButtonClicked extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  changePasswordButtonClicked({required this.currentPassword,required this.newPassword});
}



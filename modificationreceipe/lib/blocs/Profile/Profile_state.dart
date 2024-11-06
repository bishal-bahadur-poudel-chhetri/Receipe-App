import 'package:logins/models/homepage.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class HomepageLoaded extends ProfileState {}
class OTPSendLoaded extends ProfileState {}
class ChangePasswordFailure extends ProfileState {
  final String errorMessage;
  ChangePasswordFailure({required this.errorMessage});
}
class ChangePasswordSuccess extends ProfileState {}


class OtpVerificationLoading extends ProfileState {}





class OtpVerificationSuccess extends ProfileState {}

class OtpVerificationFailure extends ProfileState {
  final String detail;
  final String status;

  OtpVerificationFailure({required this.detail,required this.status});
}

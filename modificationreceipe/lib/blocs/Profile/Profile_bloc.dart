import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logins/pages/profile/profile.dart';
import '../../services/repository.dart';
import '../authentication/authentication_bloc.dart';
import './block.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final Repository repository;
  final BuildContext context;

  ProfileBloc({required this.repository, required this.context})
      : super(ProfileInitial()) {
    on<OtpButtonClicked>(_mapCategoryButtonClicked);
    on<OtpVerificationClicked>(_mapOtpVerificationClicked);
    on<changePasswordButtonClicked>(_mapChangepassword);

  }

  Future<void> _mapCategoryButtonClicked(
      OtpButtonClicked event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      await repository.apiProvider.OTP();
      emit(OTPSendLoaded());
    } catch (e) {
      emit(OTPSendLoaded());
      print("error");
    }
  }




  Future<void> _mapOtpVerificationClicked(
      OtpVerificationClicked event,
      Emitter<ProfileState> emit,
      ) async {

    emit(OtpVerificationLoading());
    try {
      final otp = event.userOtp;
      final body=await repository.apiProvider.verifyOTP(userOtp: otp);
      if(body['detail']=="wrong otp" && body['status']=="200"){
        emit(OtpVerificationFailure(detail: 'otp error', status: '200'));
      }
      else{
          emit(OtpVerificationLoading());
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          });

      }
      print("end");


    } catch (e) {
      emit(HomepageLoaded());
      print("error");
    }
  }

  Future<void> _mapChangepassword(
      changePasswordButtonClicked event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final newpassword = event.newPassword;
      final oldpassword = event.currentPassword;


      final success = await repository.apiProvider.Changepassword(oldpassword: oldpassword, newpassword: newpassword);

      if (success) {
        print("success");
        emit(ChangePasswordSuccess());
      } else {
        // Password change failed, emit failure state
        emit(ChangePasswordFailure(errorMessage: 'Failed to change password'));
      }
    } catch (e) {
      // An error occurred, emit failure state
      emit(ChangePasswordFailure(errorMessage: 'An unexpected error occurred.'));
      print("Error: $e");
    }
  }


}



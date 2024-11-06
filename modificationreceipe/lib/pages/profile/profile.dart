import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/Userprofile/bloc/bloc.dart';
import 'package:logins/blocs/authentication/authentication_bloc.dart';
import 'package:logins/blocs/authentication/authentication_event.dart';
import 'package:logins/config/color_code.dart';
import 'package:logins/pages/login_page.dart';

import 'package:logins/pages/profile/Userstatus.dart';


import '../../blocs/Profile/Profile_bloc.dart';
import '../../blocs/Profile/Profile_event.dart';
import '../../blocs/Profile/Profile_state.dart';
import '../../blocs/Userprofile/bloc/User_bloc.dart';
import '../../blocs/Userprofile/bloc/User_event.dart';
import '../../blocs/floatingbtn/homepage_bloc.dart';

import '../../services/repository.dart';

import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

void _showLoadingDialog(BuildContext context, int verificationCode) {
  // Add your verification logic here
  BlocProvider.of<ProfileBloc>(context).add(OtpVerificationClicked(userOtp: verificationCode));

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Verifying..."),
          ],
        ),
      );
    },
  );
}


class _ProfileState extends State<Profile> {
  final Repository repository = Repository();
  bool isStrongPassword(String password) {
    // Implement your strong password validation logic here
    // For example, you can check the length, include special characters, etc.
    return password.length >= 8 && password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[0-9]'));
  }

  bool _isEditingProfile = false;
  final ScrollController _scrollController = ScrollController();
  final int selectedNavBarIndex = 0;


  void _onNavBarItemTapped(BuildContext context, int index) {
    navigateToScreen(context, index);
  }
  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red, // Set the background color to red
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {

    final Repository repository = Repository();





    return MultiBlocProvider(
      providers: [

        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) {
            final profileBloc = ProfileBloc(
              repository: repository,
              context: context,
            );

            // profileBloc.add(OtpButtonClicked());
            // profileBloc.add(OtpVerificationClicked(userOtp:0));
            // profileBloc.add(changePasswordButtonClicked(currentPassword:'', newPassword: ''));

            return profileBloc;
          },
        ),

        BlocProvider<UserBloc>(
          create: (context) {
            final userBloc = UserBloc(repository: Repository());
            userBloc.add(AppUserStarted());
            return userBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text('Profile', style: FontStyles.midHeader),
            backgroundColor: Colors.white70,
            elevation: 0,
            centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            print('Current State: $state');
            if (state is UserLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserLoaded) {
              final checklists = state.receipe;
              print(checklists);
              bool userstatus=checklists[0].is_verified;

              ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);

              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black, // Set the border color as needed
                                      width: 1, // Set the border width as needed
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: AssetImage('images/icon.png'), // Replace with the path to your asset image
                                  ),
                                ),



                              ],
                            ),

                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Follower',
                                      style: FontStyles.subHeader,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${checklists[0].followers_count}',
                                      style: FontStyles.midHeader,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Following',
                                      style: FontStyles.subHeader,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${checklists[0].following_count.toString()}',
                                      style:FontStyles.midHeader,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle_sharp, // You can choose an appropriate icon
                                    size: 24,
                                    color: AppColors.main_color,
                                  ),
                                  SizedBox(width: 5),

                                  Text(
                                    '${checklists[0].username.toString()}',
                                    style: FontStyles.midHeader,
                                  ),

                                ],
                              ),
                            ),
                    BlocListener<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        if (state is OtpVerificationFailure) {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                backgroundColor:Colors.white,
                                title: Text("Verification Failed"),
                                content: Text("Error: ${state.detail}"),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (state is HomepageLoaded) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                        } else if (state is OtpVerificationLoading) {
                          _showLoadingDialog(context,"xxxx" as int);
                        }
                      },
                      child: EmailVerificationSection(
                        userstatus: userstatus,
                        checklists: checklists,
                        profileBloc: profileBloc,
                        onVerify: () {
                          BlocProvider.of<ProfileBloc>(context).add(OtpButtonClicked());
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              int verificationCode = 0; // Initialize with a default value

                              return AlertDialog(

                                title: Text("Enter Verification Code",style: FontStyles.subHeader,),
                                backgroundColor:Colors.white,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      onChanged: (value) {
                                        verificationCode = int.tryParse(value) ?? 0;
                                      },
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      style: FontStyles.dull_text,
                                      decoration: InputDecoration(
                                        labelText: "Verification Code",
                                        hintText: "1234",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "We've sent a 4-digit code to your email",
                                      style: FontStyles.text,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your verification logic here
                                      if (verificationCode >= 1000 && verificationCode <= 9999) {
                                        _showLoadingDialog(context, verificationCode); // Show loading for a while
                                      }
                                    },
                                    child: Text("Verify",style: FontStyles.midHeader,),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel",style: FontStyles.midHeader),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),






                          BlocListener<ProfileBloc, ProfileState>(
                            listener: (context, state) {
                              if (state is ChangePasswordFailure) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      backgroundColor:Colors.white,
                                      title: Text("Change Password Failed",style: FontStyles.subHeader),
                                      content: Text("Error: ${state.errorMessage}"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK",style: FontStyles.midHeader),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (state is ChangePasswordSuccess) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      backgroundColor:Colors.white,
                                      title: Text("Change Password Success",style: FontStyles.midHeader),
                                      content: Text("Password changed successfully!",style: FontStyles.midHeader),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK",style: FontStyles.midHeader),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              // Handle other states as needed
                            },
                            // Rest of your code...
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff000080)),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    String currentPassword = "";
                                    String newPassword = "";
                                    String confirmPassword = "";

                                    return AlertDialog(
                                      backgroundColor:Colors.white,
                                      title: Text("Change Password", style: FontStyles.subHeader),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              onChanged: (value) {
                                                currentPassword = value;
                                              },
                                              obscureText: true,
                                              style: FontStyles.midHeader,
                                              decoration: InputDecoration(
                                                labelText: "Current Password",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            TextField(
                                              onChanged: (value) {
                                                newPassword = value;
                                              },
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText: "New Password",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            TextField(
                                              onChanged: (value) {
                                                confirmPassword = value;
                                              },
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText: "Confirm New Password",
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(dialogContext).unfocus();
                                      // Add your change password logic here
                                      if (currentPassword.isNotEmpty &&
                                          newPassword.isNotEmpty &&
                                          confirmPassword.isNotEmpty) {
                                        if (newPassword == confirmPassword) {
                                          if (isStrongPassword(newPassword)) {
                                            BlocProvider.of<ProfileBloc>(context).add(
                                              changePasswordButtonClicked(
                                                currentPassword: currentPassword,
                                                newPassword: newPassword,
                                              ),
                                            );
                                          } else {
                                            _showSnackbar(context, "Password is weak. Please use a stronger password.");
                                          }
                                        } else {
                                          _showSnackbar(context, "New password and confirm password do not match.");
                                        }
                                      } else {
                                        _showSnackbar(context, "Please fill in all password fields.");
                                      }
                                    },
                                    child: Text("Change", style: FontStyles.midHeader),
                                    ),



                                    ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel", style: FontStyles.midHeader),
                                        ),
                                      ],
                                    );

                                  },
                                );
                              },
                              child: Text('Change Password',style: FontStyles.button_color_text),
                            ),
                          ),




                            // Logout Button
                            ElevatedButton(
                              onPressed: () {
                                final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
                                authenticationBloc.add(Reset());
                                authenticationBloc.add(LoggedOut());

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => LoginPage(repository: repository)),
                                      (route) => false,
                                );
                              },
                              child: Text('Logout', style: FontStyles.button_color_text),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(AppColors.main_color),
                              ),
                            ),






                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UserError) {
              return Text(state.errorMessage);
            } else {
              return Text('Unknown State');
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBarPage(
          selectedNavBarIndex: selectedNavBarIndex,
          onNavBarItemTapped: (index) => _onNavBarItemTapped(context, index),
        ),
      ),
    );
  }
}


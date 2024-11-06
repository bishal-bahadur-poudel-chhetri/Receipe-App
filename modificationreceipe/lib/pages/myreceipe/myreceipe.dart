import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/authentication/authentication_bloc.dart';
import 'package:logins/blocs/authentication/authentication_event.dart';
import 'package:logins/blocs/homepage/homepage_bloc.dart';
import 'package:logins/blocs/homepage/homepage_event.dart';
import 'package:logins/models/homepage.dart';
import 'package:logins/pages/splash_page.dart';
import 'package:lottie/lottie.dart';

import '../../blocs/ReceipeDetail/bloc/receipe_detail_bloc.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_event.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_state.dart';
import '../../blocs/floatingbtn/homepage_bloc.dart';
import '../../blocs/floatingbtn/homepage_event.dart';
import '../../blocs/homepage/homepage_state.dart';
import '../../config/app_config.dart';
import '../../config/color_code.dart';
import '../../services/repository.dart';
import '../Homepage/home_page.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';
import '../profile/profile.dart';
class Myreceipe extends StatefulWidget {
  @override
  _ReceipeState createState() => _ReceipeState();
}


class _ReceipeState extends State<Myreceipe> {

  bool _isEditingProfile = false;
  final ScrollController _scrollController = ScrollController();
  final int selectedNavBarIndex = 2;
  void _onNavBarItemTapped(BuildContext context, int index) {
    // Use the utility function for navigation
    navigateToScreen(context, index);
  }

  @override
  Widget build(BuildContext context) {

    final Repository repository = Repository();
    final AuthenticationBloc authenticationBloc =
        AuthenticationBloc(repository: repository)..add(AppStarted());

    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
        BlocProvider<ReceipeDetailBloc>(
          create: (context) {
            final receipeDetailBloc = ReceipeDetailBloc(
              repository: repository,
              context: context,
            );

            receipeDetailBloc.add(AppReceipeUserDetailStarted("self"));

            return receipeDetailBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Receipies', style: TextStyle(color: Colors.black,fontFamily: "BebasNeue")),
          backgroundColor: Colors.white70,
            automaticallyImplyLeading: false,
          elevation: 0,
            centerTitle: true
        ),

        body: BlocBuilder<ReceipeDetailBloc, ReceipeDetailState>(
          builder: (context, state) {
            print('Current State: $state');
            if (state is ReceipeDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReceipeDetailLoadedUser) {
              final checklists = state.recipes;
              if (checklists.isNotEmpty) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(
                                          (checklists.length / 2).ceil(),
                                              (columnIndex) {
                                            final startIndex = columnIndex * 2;
                                            final endIndex = (startIndex + 2 < checklists.length)
                                                ? (startIndex + 2)
                                                : checklists.length;
                                            final columnItems = checklists.sublist(
                                              startIndex,
                                              endIndex,
                                            );

                                            return Row(
                                              children: [
                                                ...List.generate(
                                                  columnItems.length,
                                                      (index) {
                                                    final recipeDetail = columnItems[index];
                                                    final recipeUser = columnItems[index];
                                                    bool isWishlistSelected = false;

                                                    return Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          BlocProvider.of<ReceipeDetailBloc>(context).add(
                                                            ReceipeButtonClicked(
                                                              recipeDetail,
                                                              recipeUser,
                                                              "mydata",
                                                            ),
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(right: 13, bottom: 13),
                                                          child: Container(
                                                            width: 150,
                                                            decoration: BoxDecoration(
                                                              color: AppColors.receipe_list_container_color,
                                                              borderRadius: BorderRadius.circular(13),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  width: double.infinity,
                                                                  height: 129,
                                                                  child: ClipRRect(
                                                                    borderRadius: BorderRadius.circular(13),
                                                                    child: Image.network(
                                                                      '${AppConfig.api_url}${recipeDetail.categoryImage}',
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                                  child: Text(
                                                                    '${recipeDetail.receipeTitle.toString()}',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                      child: Text(
                                                                        "Time",
                                                                        style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: AppColors.time_button_text_color,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(right: 8.0),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 8.0),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(top: 8.0),
                                                                              child: Text(
                                                                                '${recipeDetail.cookTime.toString()} min',
                                                                                style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  color: AppColors.time_button_text_color,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                if (columnItems.length % 2 != 0)
                                                  Expanded(
                                                    child: Container(), // Empty container to occupy the empty space
                                                  ),
                                              ],
                                            );
                                          },
                                        )..add(SizedBox(height: 10)), // Add spacing between columns
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  child:Center(
                    child:Lottie.asset('images/empty.json', height: 120, width: 120),
                  ),
                );
              }

            } else if (state is ReceipeDetailError) {
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

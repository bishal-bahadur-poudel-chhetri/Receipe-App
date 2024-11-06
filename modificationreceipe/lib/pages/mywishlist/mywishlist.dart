import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/config/color_code.dart';
import 'package:lottie/lottie.dart';
import '../../blocs/Wishlist/bloc/wishlist_bloc.dart';
import '../../blocs/Wishlist/bloc/wishlist_event.dart';
import '../../blocs/Wishlist/bloc/wishlist_state.dart';
import '../../config/app_config.dart';

import '../../services/repository.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';

class myWishlistPage extends StatefulWidget {

  myWishlistPage();

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<myWishlistPage> {

  final ScrollController _scrollController = ScrollController();
  final int selectedNavBarIndex = 2;
  void _onNavBarItemTapped(BuildContext context, int index) {
    // Use the utility function for navigation
    navigateToScreen(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
    providers: [
      BlocProvider<WishlistBloc>(
        create: (context) {
          final wishlistBloc = WishlistBloc(repository: Repository());
          wishlistBloc.add(AppWishlistStarted());
          return wishlistBloc;
        },
      ),

              ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wishlists', style: TextStyle(color: Colors.black,fontFamily: "BebasNeue")),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
            centerTitle: true,

        ),


        body: BlocBuilder<WishlistBloc, WishlistState>(

          builder: (context, state) {
            if (state is WishlistLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WishlistLoaded) {

              final checklists = state.receipe;
              print(checklists.length);
              if(checklists.length==0){
                return Container(
                  child:Center(
                    child:Lottie.asset('images/empty.json', height: 120, width: 120),
                  ),
                );

              }
              return SingleChildScrollView(
                // Wrap the body with SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      SizedBox(width: 20),
                      SizedBox(

                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: List.generate(
                                (checklists.length / 2).ceil(),
                                    (columnIndex) {
                                  final startIndex = columnIndex * 2;
                                  final endIndex = (startIndex + 2 <
                                      checklists.length)
                                      ? (startIndex + 2)
                                      : checklists.length;
                                  final columnItems = checklists
                                      .sublist(startIndex, endIndex);

                                  return Row(
                                    children: [
                                      ...List.generate(
                                          columnItems.length,
                                              (index) {
                                            final receipeDetail =
                                            columnItems[index];
                                            final receipeUser =
                                            columnItems[index];
                                            bool isWishlistSelected =
                                            false;

                                            return Expanded(
                                              child: GestureDetector(
                                                onTap: () {

                                                },
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      right: 13,
                                                      bottom: 13),
                                                  child: Container(
                                                    width: 150,
                                                    decoration:
                                                    BoxDecoration(
                                                      color: AppColors
                                                          .receipe_list_container_color,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          13),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          width: double
                                                              .infinity,
                                                          height: 129,
                                                          child:
                                                          ClipRRect(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                13),
                                                            child: Image
                                                                .network(
                                                              '${AppConfig.api_url}${receipeDetail.categoryImage}',
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .fromLTRB(
                                                              0,
                                                              5,
                                                              0,
                                                              5),
                                                          child: Text(
                                                            '${receipeDetail.receipeTitle.toString()}',
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(left: 8.0),
                                                                  child:
                                                                  Text(
                                                                    "Time",
                                                                    style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      12,
                                                                      color:
                                                                      AppColors.time_button_text_color,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(left: 8.0),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.only(top: 8.0),
                                                                    child:
                                                                    Text(
                                                                      '${receipeDetail.cookTime.toString()} min',
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                isWishlistSelected
                                                                    ? Icons
                                                                    .delete
                                                                    : Icons
                                                                    .delete,
                                                                color: isWishlistSelected
                                                                    ? Colors
                                                                    .red
                                                                    : Colors
                                                                    .red,
                                                              ),
                                                              onPressed:
                                                                  () {
                                                                BlocProvider.of<WishlistBloc>(context)
                                                                    .add(WishlistDeleted(receipeDetail.receipeId));
                                                                BlocProvider.of<WishlistBloc>(context)
                                                                    .add(AppWishlistStarted());


                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                      if (columnItems.length % 2 != 0)
                                        Expanded(
                                          child:
                                          Container(), // Empty container to occupy the empty space
                                        ),
                                    ],
                                  );
                                })
                              ..add(SizedBox(
                                  height:
                                  10)), // Add spacing between columns
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );





            } else if (state is WishlistError) {
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            } else {
              return Center(
                child: Text('Unknown State: $state'),
              );
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

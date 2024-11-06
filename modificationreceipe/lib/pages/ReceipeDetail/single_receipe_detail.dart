import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/config/color_code.dart';
import 'package:logins/config/manual.dart';
import '../../blocs/ReceipeDetail/bloc/bloc.dart';
import '../../config/app_config.dart';
import '../../models/homepage.dart';
import '../../models/receipeDetail.dart';
import '../../services/api_provider.dart';
import '../../services/repository.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';

class RecipeDetailPage extends StatefulWidget {
  final String recipeId;

  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final int selectedNavBarIndex = 2;



  String getUnitText(int? unit) {
    if (unit == null) {
      return 'Unit not specified'; // or any default value you prefer
    }
    print(unit);
    if (unit == null) {
      return 'Unit not specified';
    }

    // If the unit is found in the mappings, return its description; otherwise, return 'Unknown'
    return unitMappings[unit] ?? 'Unknown';
  }

  void _onNavBarItemTapped(BuildContext context, int index) {
    // Use the utility function for navigation
    navigateToScreen(context, index);
  }
  bool isFollowed = false;
  bool isfollowedCheck = false;
  bool isAddedToChecklist = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceipeDetailBloc>(
      create: (context) => ReceipeDetailBloc(
        repository: Repository(),
        context: context,
      )..add(AppReceipeDetailStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receipe Detail', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 24.0,
          ),
          actions: [
        Container(
        margin: EdgeInsets.only(right: 5.0),
        child: IconButton(
          icon: Icon(
            isAddedToChecklist
                ? Icons.bookmark_added_outlined
                : Icons.bookmark_add_outlined,
          ),
          color: isAddedToChecklist ? Colors.red : Colors.black,
          onPressed: () {
            // Toggle the checklist status
            setState(() {
              isAddedToChecklist = !isAddedToChecklist;
            });

            // Check the status
            if (isAddedToChecklist) {
              // Item has been added to the checklist
              print('Item added to checklist');
            } else {
              // Item has been removed from the checklist
              print('Item removed from checklist');
            }
          },
        ),
      )

          ],
        ),
        body: BlocBuilder<ReceipeDetailBloc, ReceipeDetailState>(
          builder: (context, state) {
            if (state is ReceipeDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReceipeDetailLoadingMain) {
              final recipes = state.recipes;
              final checklists = state.receipeList;
              final followeeUsername =
                  recipes[0].receipeUser.username.toString();
              Repository repository = Repository();

              if (isfollowedCheck == false) {

                repository.apiProvider.checkFollowStatus(followeeUsername).then((response) {
                  setState(() {
                    isFollowed = response['followed'];
                    isfollowedCheck = true;
                  });

                  print(isFollowed);
                }).catchError((error) {
                  print('Error checking follow status: $error');
                });
              }

              print(isFollowed);
              return SingleChildScrollView(
                // Wrap the body with SingleChildScrollView
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.7, // Set width to 60% of the screen width
                          child: Text(
                            '${recipes[0].receipeTitle.toString()}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as per your preference
                              child: Image.network(
                                '${AppConfig.api_url}${recipes[0].categoryImage.toString()}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 41.0,
                                        height: 41.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                        child: CircleAvatar(
                                          radius: 20.5,
                                          backgroundImage: NetworkImage(
                                              'https://example.com/avatar.jpg'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${checklists[0].receipeUserId.firstName.toString()} ${checklists[0].receipeUserId.lastName.toString()}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${recipes[0].receipeUser.username.toString()}',


                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (isFollowed == false) {
                                    final Repository repository = Repository();

                                    await repository.apiProvider.follow(
                                      followingUser:
                                          '${recipes[0].receipeUser.username.toString()}',
                                      status: "follow",
                                    );

                                  } else if (isFollowed == true) {
                                    final Repository repository = Repository();

                                    await repository.apiProvider.follow(
                                      followingUser:
                                          '${recipes[0].receipeUser.username.toString()}',
                                      status: "unfollow",
                                    );
                                  }
                                  setState(() {
                                    isfollowedCheck = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isFollowed ? Colors.green : Colors.red,
                                ),
                                child: Text(
                                  isFollowed ? 'unfollow' : 'follow',
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Set the text color to white
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ingredients',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${recipes[0].receipeIngredients.length} items',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: AppColors.single_receipe_color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0; i < recipes[0].receipeIngredients.length; i += 2)
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.single_ingredian_colors,
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${recipes[0].receipeIngredients[i].ingredientName.toString()}",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${recipes[0].receipeIngredients[i].amount.toString()} ${
                                                            getUnitText(recipes[0].receipeIngredients[i].unit)
                                                        } ",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors.single_receipe_color,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10), // Adjust the width of the padding as needed
                                              if (i + 1 < recipes[0].receipeIngredients.length)
                                                Flexible(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.single_ingredian_colors,
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${recipes[0].receipeIngredients[i + 1].ingredientName.toString()}",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "${recipes[0].receipeIngredients[i + 1].amount.toString()} ${
                                                              getUnitText(recipes[0].receipeIngredients[i + 1].unit)
                                                          } ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: AppColors.single_receipe_color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),




                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Methods',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors
                                              .receipe_list_container_color,
                                        ),
                                        child: Column(
                                          children: [
                                            for (int i = 0;
                                                i <
                                                    recipes[0]
                                                        .procedureDetail
                                                        .length;
                                                i++)
                                              LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  final stepCircleSize =
                                                      constraints.maxWidth *
                                                          0.1;
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              width:
                                                                  stepCircleSize,
                                                              height:
                                                                  stepCircleSize,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 1.0,
                                                              height:
                                                                  stepCircleSize *
                                                                      0.5,
                                                              color: Colors.red,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                            ),
                                                            Text(
                                                              "${i+1}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    stepCircleSize *
                                                                        0.4,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${recipes[0].procedureDetail[i].description.toString()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      stepCircleSize *
                                                                          0.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Column(
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Text(
                              //               'More Receipe By ${recipes[0].receipeUser.username.toString()}',
                              //               style: TextStyle(
                              //                 fontSize: 20.0,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       SizedBox(width: 20),
                              //       SizedBox(
                              //
                              //         child: Container(
                              //           padding: EdgeInsets.only(left: 8.0),
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.start,
                              //             children: List.generate(
                              //                 (checklists.length / 2).ceil(),
                              //                 (columnIndex) {
                              //               final startIndex = columnIndex * 2;
                              //               final endIndex = (startIndex + 2 <
                              //                       checklists.length)
                              //                   ? (startIndex + 2)
                              //                   : checklists.length;
                              //               final columnItems = checklists
                              //                   .sublist(startIndex, endIndex);
                              //
                              //               return Row(
                              //                 children: [
                              //                   ...List.generate(
                              //                       columnItems.length,
                              //                       (index) {
                              //                     final receipeDetail =
                              //                         columnItems[index];
                              //                     final receipeUser =
                              //                         columnItems[index];
                              //                     bool isWishlistSelected =
                              //                         false;
                              //
                              //                     return Expanded(
                              //                       child: GestureDetector(
                              //                         onTap: () {
                              //                           BlocProvider.of<
                              //                                       ReceipeDetailBloc>(
                              //                                   context)
                              //                               .add(ReceipeButtonClicked(
                              //                                   receipeDetail,
                              //                                   receipeUser,
                              //                                   "notdata"));
                              //                         },
                              //                         child: Padding(
                              //                           padding:
                              //                               EdgeInsets.only(
                              //                                   right: 13,
                              //                                   bottom: 13),
                              //                           child: Container(
                              //                             width: 150,
                              //                             decoration:
                              //                                 BoxDecoration(
                              //                               color: AppColors
                              //                                   .receipe_list_container_color,
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(
                              //                                           13),
                              //                             ),
                              //                             child: Column(
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment
                              //                                       .start,
                              //                               crossAxisAlignment:
                              //                                   CrossAxisAlignment
                              //                                       .center,
                              //                               children: [
                              //                                 Container(
                              //                                   width: double
                              //                                       .infinity,
                              //                                   height: 129,
                              //                                   child:
                              //                                       ClipRRect(
                              //                                     borderRadius:
                              //                                         BorderRadius
                              //                                             .circular(
                              //                                                 13),
                              //                                     child: Image
                              //                                         .network(
                              //                                       '${AppConfig.api_url}${receipeDetail.categoryImage}',
                              //                                       fit: BoxFit
                              //                                           .cover,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                                 Padding(
                              //                                   padding:
                              //                                       const EdgeInsets
                              //                                               .fromLTRB(
                              //                                           0,
                              //                                           5,
                              //                                           0,
                              //                                           5),
                              //                                   child: Text(
                              //                                     '${receipeDetail.receipeTitle.toString()}',
                              //                                     textAlign:
                              //                                         TextAlign
                              //                                             .center,
                              //                                     style:
                              //                                         TextStyle(
                              //                                       fontSize:
                              //                                           16,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold,
                              //                                     ),
                              //                                   ),
                              //                                 ),
                              //                                 Row(
                              //                                   mainAxisAlignment:
                              //                                       MainAxisAlignment
                              //                                           .spaceBetween,
                              //                                   children: [
                              //                                     Column(
                              //                                       mainAxisAlignment:
                              //                                           MainAxisAlignment
                              //                                               .start,
                              //                                       crossAxisAlignment:
                              //                                           CrossAxisAlignment
                              //                                               .start,
                              //                                       children: [
                              //                                         Padding(
                              //                                           padding:
                              //                                               const EdgeInsets.only(left: 8.0),
                              //                                           child:
                              //                                               Text(
                              //                                             "Time",
                              //                                             style:
                              //                                                 TextStyle(
                              //                                               fontSize:
                              //                                                   12,
                              //                                               color:
                              //                                                   AppColors.time_button_text_color,
                              //                                             ),
                              //                                           ),
                              //                                         ),
                              //                                         Padding(
                              //                                           padding:
                              //                                               const EdgeInsets.only(left: 8.0),
                              //                                           child:
                              //                                               Padding(
                              //                                             padding:
                              //                                                 const EdgeInsets.only(top: 8.0),
                              //                                             child:
                              //                                                 Text(
                              //                                               '${receipeDetail.cookTime.toString()} min',
                              //                                               style:
                              //                                                   TextStyle(
                              //                                                 fontSize: 12,
                              //                                                 fontWeight: FontWeight.bold,
                              //                                               ),
                              //                                             ),
                              //                                           ),
                              //                                         ),
                              //                                       ],
                              //                                     ),
                              //                                     IconButton(
                              //                                       icon: Icon(
                              //                                         isWishlistSelected
                              //                                             ? Icons
                              //                                                 .favorite
                              //                                             : Icons
                              //                                                 .favorite_border,
                              //                                         color: isWishlistSelected
                              //                                             ? Colors
                              //                                                 .red
                              //                                             : Colors
                              //                                                 .grey,
                              //                                       ),
                              //                                       onPressed:
                              //                                           () {
                              //                                         print(
                              //                                             "Wishlist tapped");
                              //                                       },
                              //                                     ),
                              //                                   ],
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     );
                              //                   }),
                              //                   if (columnItems.length % 2 != 0)
                              //                     Expanded(
                              //                       child:
                              //                           Container(), // Empty container to occupy the empty space
                              //                     ),
                              //                 ],
                              //               );
                              //             })
                              //               ..add(SizedBox(
                              //                   height:
                              //                       10)), // Add spacing between columns
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            } else {
              // Handle error state or other cases
              return Center(
                child: Text('this is error'),
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

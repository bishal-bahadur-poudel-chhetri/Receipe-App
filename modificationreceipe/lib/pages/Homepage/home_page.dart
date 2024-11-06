import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/Wishlist/bloc/bloc.dart';
import 'package:logins/blocs/authentication/authentication_bloc.dart';
import 'package:logins/blocs/authentication/authentication_event.dart';
import 'package:logins/blocs/homepage/homepage_bloc.dart';
import 'package:logins/blocs/homepage/homepage_event.dart';
import 'package:logins/models/homepage.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../blocs/ReceipeDetail/bloc/receipe_detail_bloc.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_event.dart';
import '../../blocs/floatingbtn/homepage_bloc.dart';

import '../../blocs/homepage/homepage_state.dart';
import '../../config/app_config.dart';
import '../../config/color_code.dart';
import '../../services/repository.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';
import '../myreceipe/myreceipe.dart';
import '../profile/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int selectedNavBarIndex = 0;
  List<bool> isWishlistSelectedList = List.filled(100, false);
  final List<String> bannerImages = [
    '${AppConfig.api_url}/media/banner/Banner1/banner1.jpg',
    '${AppConfig.api_url}/media/banner/Banner2/banner2.jpg',
    '${AppConfig.api_url}/media/banner/Banner3/banner3.jpg',
    // Add more banner items as needed
  ];

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
        BlocProvider<HomepageBloc>(
          create: (context) {
            final homepageBloc = HomepageBloc(repository: repository);
            // homepageBloc.add(AppHomeStartedPopular());
            homepageBloc.add(AppHomeStarted());

            return homepageBloc;
          },
        ),
        BlocProvider<ReceipeDetailBloc>(
          create: (context) => ReceipeDetailBloc(
            repository: repository,
            context: context,
          ),
        ),
        BlocProvider<WishlistBloc>(
          create: (context) => WishlistBloc(
            repository: repository,
          ),
        ),

      ],
      child: Scaffold(
        body: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find best recipes',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lobster', // Specify the font family
                        ),
                      ),
                      Text(
                        'for cooking',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lobster', // Specify the font family
                        ),
                      ),

                    ],
                  ),
                  CarouselSlider(
                    items: bannerImages.map((imageURL) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width, // Make each banner cover the whole width
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: Image.network(
                              imageURL,
                              fit: BoxFit.cover, // Adjust the fit as needed
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true, // Automatically scroll
                      enlargeCenterPage: false, // Set to false to cover the whole width
                      viewportFraction: 1.0, // Cover the whole width
                      enableInfiniteScroll: true, // Scroll infinitely
                      aspectRatio: 2.0,
                      height: 130, // Adjust the height as needed
                    ),
                  ),

                  BlocBuilder<HomepageBloc, HomepageState>(
                    builder: (context, state) {
                      if (state is HomepageLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is HomepageLoaded) {
                        final checklists = state.checklists;
                        final userwishlist=state.wishlist;
                        final receipe = state.receipe;
                        final clickedCategory = state.clickedCategory;
                        final itemCount = checklists.length;
                        for (int i = 0; i < receipe.length; i++) {
                          final receipeId = receipe[i].receipeId;
                          isWishlistSelectedList[i] = userwishlist!
                              .any((wish) => wish.receipeId == receipeId);
                        }


                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 34, // Set the desired height for the categories row
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 8.0),
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itemCount,
                                  itemBuilder: (context, index) {
                                    final Category category = checklists[index];

                                    final bool isClicked = clickedCategory != null &&
                                        category.categoryId == clickedCategory.categoryId;

                                    return Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: InkWell(
                                        onTap: () {
                                          BlocProvider.of<HomepageBloc>(context)
                                              .add(CategoryButtonClicked(category));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isClicked
                                                ? AppColors.on_click_button
                                                : AppColors.button_color_default,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              if (isClicked)
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              SizedBox(width: 4),
                                              Text(
                                                '${category.categoryName.toString()}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isClicked
                                                      ? AppColors.on_click_text_button
                                                      : AppColors.text_color_default,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Popular category",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "BebasNeue",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            SizedBox(
                              height: 215,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: receipe.length > 3 ? 3 : receipe.length,
                                itemBuilder: (context, index) {
                                  final receipeDetail = receipe[index];
                                  final receipeUser = receipe[index];




                                  // Initialize the initial state of the wishlist
                                  bool isWishlistSelected = isWishlistSelectedList[index];


                                  return  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle the wishlist status
                                        isWishlistSelectedList[index] = !isWishlistSelectedList[index];
                                      });
                                      BlocProvider.of<ReceipeDetailBloc>(context)
                                          .add(ReceipeButtonClicked(receipeDetail, receipeUser, "notdata"));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 13),
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
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: Container(
                                                width: 139,
                                                height: 129,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(13),
                                                  child: Image.network(
                                                    '${AppConfig.api_url}${receipeDetail.categoryImage.toString()}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              child: Text(
                                                '${receipeDetail.receipeTitle.toString()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(
                                                        "Time",
                                                        style: TextStyle(
                                                          fontFamily: "BebasNeue",
                                                          fontSize: 12,
                                                          color: AppColors.time_button_text_color,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 8.0),
                                                        child: Text(
                                                          '${receipeDetail.cookTime.toString()} min',
                                                          style: TextStyle(
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
                                                    isWishlistSelectedList[index] ? Icons.bookmark_add_outlined : Icons.bookmark_add_outlined,
                                                    color: isWishlistSelectedList[index] ? Colors.red : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      // Toggle the wishlist status
                                                      isWishlistSelectedList[index] = !isWishlistSelectedList[index];
                                                      print(isWishlistSelectedList[index]);
                                                    });
                                                    BlocProvider.of<WishlistBloc>(context)
                                                        .add(WishlistAdded(receipeDetail.receipeId));
                                                    print("Wishlist tapped");
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                },
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Receipes",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "BebasNeue",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            SizedBox(
                              height: 215,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: receipe.length > 3 ? receipe.length - 3 : 0,
                                itemBuilder: (context, index) {
                                  final receipeDetail = receipe[index + 3];
                                  final receipeUser = receipe[index + 3];







                                  return  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // Toggle the wishlist status
                                        isWishlistSelectedList[index+3] = !isWishlistSelectedList[index+3];
                                      });
                                      BlocProvider.of<ReceipeDetailBloc>(context)
                                          .add(ReceipeButtonClicked(receipeDetail, receipeUser, "notdata"));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 13),
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
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: Container(
                                                width: 139,
                                                height: 129,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(13),
                                                  child: Image.network(
                                                    '${AppConfig.api_url}${receipeDetail.categoryImage.toString()}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                              child: Text(
                                                '${receipeDetail.receipeTitle.toString()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Roboto",
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(
                                                        "Time",
                                                        style: TextStyle(
                                                          fontFamily: "BebasNeue",
                                                          fontSize: 12,
                                                          color: AppColors.time_button_text_color,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 8.0),
                                                        child: Text(
                                                          '${receipeDetail.cookTime.toString()} min',
                                                          style: TextStyle(
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
                                                    isWishlistSelectedList[index+3] ? Icons.bookmark_add_outlined : Icons.bookmark_add_outlined,
                                                    color: isWishlistSelectedList[index+3] ? Colors.red : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      // Toggle the wishlist status
                                                      isWishlistSelectedList[index+3] = !isWishlistSelectedList[index+5];
                                                      print(isWishlistSelectedList[index+3]);
                                                    });
                                                    BlocProvider.of<WishlistBloc>(context)
                                                        .add(WishlistAdded(receipeDetail.receipeId));
                                                    print("Wishlist tapped");
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );

                                },
                              ),
                            ),

                          ],
                        );
                      }
                      else if (state is HomepageError) {
                        return Text(state.errorMessage);
                      } else {
                        return Text('Unknown State');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBarPage(
          selectedNavBarIndex: selectedNavBarIndex,
          onNavBarItemTapped: (index) => _onNavBarItemTapped(context, index),
        ),

      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logins/config/manual.dart';

import '../../blocs/ReceipeDetail/bloc/receipe_detail_bloc.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_event.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_state.dart';
import '../../blocs/addReceipe/homepage_bloc.dart';
import '../../blocs/addReceipe/homepage_event.dart';
import '../../config/color_code.dart';
import '../../services/repository.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';

class AddReceipePage extends StatefulWidget {
  const AddReceipePage();



  @override
  _AddReceipePageState createState() => _AddReceipePageState();
}

class _AddReceipePageState extends State<AddReceipePage> {
  int selectedNavBarIndex = 0;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController servesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();


  List<String> categories = foodCounts.keys.toList();
  int categoy=1;
  List<String> selectedCategories = [];
  String? selectedImagePath;



  Future<void> _openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        // Set the selected image path
        setState(() {
          selectedImagePath = filePath;
        });
      }
    }
  }


  void onClickValidate() {
    if (titleController.text.trim().isNotEmpty &&
        servesController.text.trim().isNotEmpty &&
        timeController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        selectedCategories.isNotEmpty &&
        selectedImagePath != null) {
      print("ok");
    } else {
      print("list is empty");
    }
  }

  void _onNavBarItemTapped(BuildContext context, int index) {
    // Use the utility function for navigation
    navigateToScreen(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceipeDetailBloc>(
      create: (context) => ReceipeDetailBloc(
        repository: Repository(),
        context: context,
      )..add(ReceipeDetailLoadeds()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
            size: 24.0,
          ),
          title: Text(
            'Add Receipe',
            style: FontStyles.mainHeader,
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _openFilePicker(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: selectedImagePath != null
                        ? Image.file(
                      File(selectedImagePath!),
                      fit: BoxFit.cover,
                    )
                        : Icon(
                      Icons.cloud_upload,
                      size: 50.0,
                      color: Colors.grey,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: TextFormField(
                    style: FontStyles.text,
                    controller: titleController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter a title',

                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  height: 120.0, // Set the height of the Container to be 120.0 or any desired value
                  child: TextFormField(
                    style: FontStyles.text,
                    controller: descriptionController,
                    maxLines: 4, // Increase the number of lines to show a bigger text area
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Enter a Description',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 10.0), // Set the contentPadding of the TextFormField
                      alignLabelWithHint: true, // Center-align the hintText in the middle
                    ),
                  ),
                ),


                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColors.single_ingredian_colors,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.08,
                                height: MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.red,
                                   // Adjust the size as needed
                                ),

                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "Serve",
                                    style: FontStyles.subHeader,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: TextFormField(
                                    controller: timeController,
                                    style: FontStyles.text,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "1",
                                      hintStyle: FontStyles.text,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                        8.0,
                                        4.0,
                                        4.0,
                                        4.0,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            color: AppColors.single_ingredian_colors,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Icon(
                                  Icons.watch_later_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "Time",
                                    style: FontStyles.text,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: TextFormField(
                                    controller: servesController,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "mins",
                                      hintStyle: FontStyles.text,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                        8.0,
                                        4.0,
                                        4.0,
                                        4.0,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: FontStyles.subHeader
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 50.0,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 8.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final bool isSelected = selectedCategories.contains(category);




                            return Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedCategories.remove(category);
                                    } else {
                                      selectedCategories.add(category);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.on_click_button
                                        : AppColors.button_color_default,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      if (isSelected)
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16.0,
                                        ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        category,
                                        style: FontStyles.text,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      BlocBuilder<ReceipeDetailBloc, ReceipeDetailState>(
                          builder: (context, state) {
                            void _onLoginButtonPressed() {
                              final String username = titleController.text;
                              final String password = servesController.text;
                              final String time = timeController.text;
                              final String serves = servesController.text;
                              print(selectedImagePath);

                              if (username.isEmpty || password.isEmpty || time.isEmpty || serves.isEmpty || selectedImagePath == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Center(child: Text("Fill all the criteria.")),
                                  backgroundColor: Colors.red,
                                ));
                                return;
                              } else {
                                BlocProvider.of<ReceipeDetailBloc>(context)
                                    .add(ReceipeDetailPost(receipeTitle: titleController.text, description: descriptionController.text, prepTime: timeController.text, cookTime: timeController.text, servingQuantity: 1, categoryId: categoy, imagePath: selectedImagePath!));
                              }
                            }

                            if (state is ReceipeDetailLoaded) {

                              return CircularProgressIndicator();
                            } else if (state is ReceipeDetailLoading) {

                              return ElevatedButton(
                                onPressed: () {
                                  int? category = 1; // Default value, you can change it based on your needs

                                  for (String selectedCategory in selectedCategories) {
                                    if (foodCounts.containsKey(selectedCategory)) {
                                      category = foodCounts[selectedCategory];
                                      break; // Stop searching if a matching category is found
                                    }
                                  }

                                  print("Category: $category");

                                  // print(selectedCategories);
                                  // if (selectedCategories.contains("Dinner")){
                                  //   categoy=4;
                                  // }else if(selectedCategories.contains("Breakfast")){
                                  //   categoy=2;
                                  // }else if(selectedCategories.contains("Snacks")){
                                  //   categoy=3;
                                  // }else if(selectedCategories.contains("sdfsdf")){
                                  //   categoy=4;
                                  // }else if(selectedCategories.contains("Drinks")){
                                  //   categoy=5;
                                  // }
                                  _onLoginButtonPressed();

                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    fixedSize: const Size(500, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50))),
                                child: const Text('Add Receipe'),
                              );
                            } else if (state is ReceipeDetailError) {
                              // Handle the error state here, if necessary.
                              return Text("Error: ${state.errorMessage}");
                            } else {
                              // Handle other states if needed or return a default state.
                              return ElevatedButton(
                                onPressed: () {
                                  print("object");

                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    fixedSize: const Size(500, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50))),
                                child: const Text('Add Receipe'),
                              );
                            }
                          }
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBarPage(
          selectedNavBarIndex: selectedNavBarIndex,
          onNavBarItemTapped: (index) => _onNavBarItemTapped(context, index),
        ),
      ),

    );
  }
}

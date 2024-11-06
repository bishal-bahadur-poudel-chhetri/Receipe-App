import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logins/config/manual.dart';
import 'package:logins/pages/myreceipe/myreceipe.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_event.dart';
import '../../config/app_config.dart';
import '../../services/repository.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_bloc.dart';
import '../../blocs/ReceipeDetail/bloc/receipe_detail_state.dart';
import '../../blocs/addReceipe/homepage_bloc.dart';
import '../../blocs/addReceipe/homepage_event.dart';
import '../../config/color_code.dart';
import '../../models/homepage.dart';
import '../../models/receipeDetail.dart';
import '../NavigateScreen.dart';
import '../bottomnavbar/bottom_navigation_bar.dart';

class EditReceipePage extends StatefulWidget {
  final String recipeId;
  EditReceipePage({required this.recipeId});

  @override
  _AddReceipePageState createState() => _AddReceipePageState();
}

class _AddReceipePageState extends State<EditReceipePage> {
  String? selectedValue;
  final ScrollController _scrollController = ScrollController();
  final int selectedNavBarIndex = 2;
  void _onNavBarItemTapped(BuildContext context, int index) {
    // Use the utility function for navigation
    navigateToScreen(context, index);
  }
  List<Recipe> recipes = [];
  List<ReceipeDetail> checklists = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController servesController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController ingredientNameController =
  TextEditingController();
  final TextEditingController ingredientQuantityController =
  TextEditingController();
  final TextEditingController methodDescriptionController =
  TextEditingController();
  final TextEditingController methodQuantityController =
  TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();


  bool isEditing = false;
  bool isEditing_description = false;
  bool isEditing_server = false;
  bool isEditing_time = false;
  bool isEditing_methodDescription = false;
  String uid="";
  String imageUrl="";

  String title = "Predefined Title";
  int loadedOnce=1;

  String serves = "1";

  String time = "10";

  List<String> ingredientNames = [];
  List<String> unitValues = [];

  List<String> ingredientQuantities = [];
  List<String> ingredientMeasuerement = [];

  List<String> methodDescriptions = [];
  List<int> methodDescriptionsid = [];


  List<String> categories = foodCounts.keys.toList();
  List<String> selectedCategories = [];
  String decription="";

  @override
  void initState() {
    super.initState();
  }

  void updateDescription() {
    setState(() {
      methodDescriptions.add(recipes[0].receipeIngredients[0].ingredientName);
    });
  }

  Future<void> _openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        // Perform further operations with the selected file
        print('File selected: $filePath');

      }
    }
  }

  void addIngredient() {
    setState(() {
      String ingredientName = ingredientNameController.text;
      String ingredientQuantity = ingredientQuantityController.text;
      print(ingredientMeasuerement);
      print(selectedValue);


      ingredientNames.add(ingredientName);
      ingredientQuantities.add(ingredientQuantity);
      ingredientMeasuerement.add(selectedValue!);



      ingredientNameController.clear();
      ingredientQuantityController.clear();
      selectedValue=null;
    });
  }

  void removeIngredient(int index) {
    setState(() {
      if (index >= 0 && index < ingredientNames.length) {
        ingredientNames.removeAt(index);
        ingredientQuantities.removeAt(index);
        ingredientMeasuerement.removeAt(index);
      }
    });
  }

  void addMethod() {
    setState(() {

      print("empty");
      if(methodDescriptions.length == 0){
        methodDescriptions.add(methodDescriptionController.text);
        methodDescriptionsid.add(1);
        print(methodDescriptionsid);


      }
      else{
        methodDescriptions.add(methodDescriptionController.text);
        methodDescriptionsid.add(methodDescriptionsid.last+1);
        print(methodDescriptionsid);

      }






      methodDescriptionController.clear();
      methodQuantityController.clear();
    });
  }

  void removeMethod(int index) {
    setState(() {
      methodDescriptions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<ReceipeDetailBloc>(
        create: (context) => ReceipeDetailBloc(
          repository: Repository(),
          context: context,
        )..add(AppReceipeDetailStarted_edit(widget.recipeId)),),


    ],

      child: WillPopScope(
        onWillPop: () async {
          print("hello");
          final recipeDetailBloc = context.read<ReceipeDetailBloc>();
          recipeDetailBloc.add(AppReceipeUserDetailStarted("self"));


          return true;
        }, child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<ReceipeDetailBloc, ReceipeDetailState>(
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  // Navigate to the profile page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Myreceipe(), // Replace with your profile page
                    ),
                  );

                  // Return true to allow back navigation, return false to prevent it
                  return true;
                },
                child: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.black,
                    size: 24.0,
                  ),
                  actions: [
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ReceipeDetailBloc>(context)
                                .add(ReceipeDetailPut(uid, title, decription, serves, time, ingredientNames, ingredientQuantities, ingredientMeasuerement, methodDescriptions, methodDescriptionsid, categories, selectedCategories, unitValues));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Myreceipe(),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Recipe saved!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.green,
                              ),
                            );
                            print('Save button pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Save'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ReceipeDetailBloc>(context)
                                .add(ReceipeDetailDelete(widget.recipeId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Recipe Deleted!',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: Colors.red,
                              ),
                            );
                            print('Save button pressed');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Delete'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),


        body: BlocBuilder<ReceipeDetailBloc, ReceipeDetailState>(
          builder: (context, state) {
            if (state is ReceipeDetailLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ReceipeDetailLoadingMain) {
              if(loadedOnce==1){

                final recipes = state.recipes;
                final checklists = state.receipeList;
                if (ingredientNames.isEmpty && ingredientQuantities.isEmpty) {
                  title = recipes[0].receipeTitle;
                  uid=recipes[0].receipeId;
                  decription=recipes[0].description;









                  serves = recipes[0].servingQuantity.toString();
                  time = recipes[0].cookTime.toString();
                  selectedCategories.add(recipes[0].category.categoryName);

                  for (var recipe in recipes) {
                    for (var ingredient in recipe.receipeIngredients) {
                      ingredientNames.add(ingredient.ingredientName);
                      ingredientQuantities.add(ingredient.amount?.toString() ?? ''); // Use '' if amount is null

                      print(ingredient.unit);
                      final id = ingredient.unit == 1 ? 'ML' : ingredient.unit == 2 ? 'LTR' : ingredient.unit == 3 ? 'GM' : 'KG';

                      ingredientMeasuerement.add(id);
                    }
                    for (var ingredient in recipe.procedureDetail) {
                      methodDescriptions.add(ingredient.description);
                      methodDescriptionsid.add(ingredient.procedure_number);
                    }
                  }
                }








              }
              loadedOnce+=1;
              imageUrl= state.recipes[0].categoryImage;






              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
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
                            child: imageUrl.isNotEmpty ?
                            Image.network(
                              '${AppConfig.api_url}${imageUrl.toString()}',
                              fit: BoxFit.cover,
                            ):

                            Icon(
                              Icons.cloud_upload,
                              size: 50.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Title',
                              style: FontStyles.subHeader,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEditing =
                                    true; // Enable editing when the text field is tapped
                                  });
                                },
                                child: TextFormField(
                                  initialValue: title,
                                  style: FontStyles.text,
                                  enabled: isEditing,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value != title) {
                                      setState(() {
                                        title = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),



                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              'Description',
                              style: FontStyles.subHeader,
                              textAlign: TextAlign.start,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                              height: 120.0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isEditing_description =
                                    true;
                                  });
                                },
                                child: TextFormField(
                                  initialValue: decription,
                                  enabled: isEditing_description,
                                  style: FontStyles.text,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Enter a Description',
                                    filled: true,

                                    fillColor: Colors.grey[200],
                                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                    alignLabelWithHint: true,
                                  ),
                                  onChanged: (value) {
                                    if (value != decription) {
                                      setState(() {
                                        decription = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height:
                                  MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    color: AppColors.single_ingredian_colors,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.1,
                                        height:
                                        MediaQuery.of(context).size.width *
                                            0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            "Serves",
                                            style: FontStyles.subHeader,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEditing_server =
                                                true; // Enable editing when the text field is tapped
                                              });
                                            },
                                            child: TextFormField(
                                              initialValue: serves,
                                              enabled: isEditing_server,
                                              style: FontStyles.text,
                                              textAlignVertical:
                                              TextAlignVertical.center,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                              ],
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintStyle: FontStyles.text,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                contentPadding:
                                                EdgeInsets.fromLTRB(
                                                  8.0,
                                                  4.0,
                                                  4.0,
                                                  4.0,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  serves = value;
                                                });
                                              },
                                            ),
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
                                  height:
                                  MediaQuery.of(context).size.width * 0.15,
                                  decoration: BoxDecoration(
                                    color: AppColors.single_ingredian_colors,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.1,
                                        height:
                                        MediaQuery.of(context).size.width *
                                            0.1,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10.0),
                                        ),
                                        child: Icon(
                                          Icons.watch_later_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            "Time",
                                            style: FontStyles.subHeader,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isEditing_time =
                                                true; // Enable editing when the text field is tapped
                                              });
                                            },
                                            child: TextFormField(
                                              initialValue: time,
                                              style: FontStyles.text,

                                              enabled: isEditing_time,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                              ],
                                              textAlignVertical:
                                              TextAlignVertical.center,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors
                                                      .single_receipe_color,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                contentPadding:
                                                EdgeInsets.fromLTRB(
                                                  8.0,
                                                  4.0,
                                                  4.0,
                                                  4.0,
                                                ),
                                              ),
                                              maxLines: null,
                                              onChanged: (value) {
                                                setState(() {
                                                  time = value;
                                                });
                                              },
                                            ),
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
                          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredients',
                                style: FontStyles.subHeader,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: ingredientNames.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == ingredientNames.length) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.single_ingredian_colors,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.1,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(5.0),
                                              ),
                                              child: TextFormField(
                                                controller:
                                                ingredientNameController,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                style: TextStyle(fontSize: 16),
                                                decoration: InputDecoration(
                                                  hintText: "Item Name",
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .single_receipe_color,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                  ),
                                                  contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 12.0,
                                                  ),
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.1,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                              ),
                                              child: TextFormField(
                                                controller:
                                                ingredientQuantityController,
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                                ],
                                                style: TextStyle(fontSize: 16),
                                                decoration: InputDecoration(
                                                  hintText: "Quantity",
                                                  hintStyle: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors
                                                        .single_receipe_color,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                  ),
                                                  contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 12.0,
                                                  ),
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.1,
                                              height: MediaQuery.of(context).size.width * 0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: DropdownButton<String>(
                                                value: selectedValue,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedValue = newValue; // Update the selected value
                                                  });
                                                },
                                                items: <String?>['ML', 'LTR','KG','GM']
                                                    .map<DropdownMenuItem<String>>((String? value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value!), // Provide a default label for null
                                                  );
                                                }).toList(),

                                                style: TextStyle(color: Colors.black), // Set the text color
                                                icon: Icon(Icons.arrow_drop_down), // Customize the dropdown icon
                                                isExpanded: true, // Allow the dropdown to expand horizontally
                                                iconSize: 15.0,
                                                underline: Container(),
                                                dropdownColor: Colors.white,// Adjust the icon size as needed
                                              ),
                                            ),
                                          ),






                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: addIngredient,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.1,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),


                                    );
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.single_ingredian_colors,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Container(
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                child: TextFormField(
                                                  initialValue: ingredientNames[index],
                                                  onChanged: (value) {
                                                    if (value != ingredientNames[index]) {
                                                      setState(() {
                                                        ingredientNames[index] = value;
                                                      });
                                                    }
                                                  },
                                                  style: TextStyle(fontSize: 10),
                                                  decoration: InputDecoration(
                                                    hintText: 'Item Name',
                                                    hintStyle: FontStyles.text,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0,
                                                    ),
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Container(
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: TextFormField(
                                                  initialValue: ingredientQuantities[index],
                                                  onChanged: (value) {
                                                    if (value != ingredientQuantities[index]) {
                                                      setState(() {
                                                        ingredientQuantities[index] = value;
                                                      });
                                                    }
                                                  },
                                                  style: FontStyles.text,
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText: 'Quantity',
                                                    hintStyle: FontStyles.text,

                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    contentPadding: EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0,
                                                    ),
                                                  ),
                                                  maxLines: null,
                                                ),
                                              ),
                                            ),
                                          ),


                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Container(
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: ingredientMeasuerement.isNotEmpty ? ingredientMeasuerement[index] : null,
                                                  onChanged: (String? newValue) {
                                                    if (newValue != null) {
                                                      setState(() {
                                                        ingredientMeasuerement[index] = newValue;
                                                      });
                                                    }
                                                  },
                                                  items: <String?>['ML','LTR', 'KG', 'GM']
                                                      .map<DropdownMenuItem<String>>((String? value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(
                                                        value!,
                                                        style: FontStyles.text, // Set the font size
                                                      ),
                                                    );
                                                  }).toList(),
                                                  style: FontStyles.text,
                                                  icon: Icon(Icons.arrow_drop_down),
                                                  isExpanded: true,
                                                  iconSize: 15.0,
                                                  underline: Container(),
                                                  dropdownColor: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),






                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: MediaQuery.of(context).size.width * 0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  removeIngredient(index);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Methods',
                                style: FontStyles.subHeader,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: methodDescriptions.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == methodDescriptions.length) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.single_ingredian_colors,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.1,
                                              height: MediaQuery.of(context).size.width * 0.2,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child: TextFormField(
                                                controller: methodDescriptionController,
                                                textAlignVertical: TextAlignVertical.center,
                                                style: FontStyles.text,

                                                decoration: InputDecoration(
                                                  hintText: "Method Description",
                                                  hintStyle: FontStyles.text,
                                                  isDense: true, // Make the input decoration the same size as the container
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),

                                                ),
                                                maxLines: 4,
                                              ),
                                            ),
                                          ),


                                          SizedBox(width: 10.0),
                                          Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                              onTap: addMethod,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.1,
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.2,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: AppColors.single_ingredian_colors,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.1,
                                            height: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.1,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: FontStyles.subHeader,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Expanded(
                                            flex: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isEditing_methodDescription =
                                                  true; // Enable editing when the text field is tapped
                                                });
                                              },
                                              child: TextFormField(
                                                initialValue:
                                                methodDescriptions[index],
                                                onChanged: (value) {
                                                  if (value !=
                                                      methodDescriptions[index]) {
                                                    setState(() {
                                                      methodDescriptions[index] =
                                                          value;
                                                    });
                                                  }
                                                },
                                                textAlignVertical:
                                                TextAlignVertical.center,
                                                style: FontStyles.text,
                                                decoration: InputDecoration(
                                                  hintText: "Method Description",
                                                  hintStyle: FontStyles.text,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                  ),
                                                  contentPadding:
                                                  EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                                ),
                                                maxLines: null,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              removeMethod(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category',
                                style: FontStyles.subHeader,
                              ),
                              Container(
                                height: 50.0,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(left: 8.0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    final String selectedCategory = selectedCategories.isNotEmpty ? selectedCategories.first : "";

                                    return Padding(
                                      padding: EdgeInsets.only(right: 4.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (selectedCategories.contains(category)) {
                                              selectedCategories.clear(); // Clear all selected categories
                                            } else {
                                              selectedCategories.clear(); // Clear all selected categories
                                              selectedCategories.add(category); // Add the tapped category
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedCategory == category
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
                                              if (selectedCategory == category)
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                category,
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: selectedCategory == category
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
                            ],
                          ),
                        ),
                      ],
                    ),
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
      ),
    );
  }
}

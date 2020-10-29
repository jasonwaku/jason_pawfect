import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/models/meal_plan.dart';
import 'package:pawfect/models/meal_plan_detail_model/meal_plan_detail.dart';
import 'package:pawfect/models/meal_plan_model/all_meal_plan.dart';
import 'package:pawfect/models/meal_plan_model/meal_plan_model.dart';
import 'package:pawfect/screens/navigation/home_sub_page.dart';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:http/http.dart' as http;
import 'package:pawfect/models/meal_plan_model/meal_plan_fetch.dart' as MPD;
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pawfect/models/meal_plan_detail_model/category_model.dart'
as CATM;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AllMealPlanPage extends StatefulWidget {
  const AllMealPlanPage({Key key}) : super(key: key);
  static String tag = 'meal-plan-page';

  @override
  _AllMealPlanPageState createState() => _AllMealPlanPageState();
}

class _AllMealPlanPageState extends State<AllMealPlanPage> {
  ProgressDialog pr;
  bool _isLoading = false;
  bool _showMealChips; //=false;
  String _mealPlanApiUrl = '';
  String _mealCatApiUrl = '';

  //
  List<AllMealPlanModel> _allMealPlanList = new List<AllMealPlanModel>();
  List<CATM.CategoryModel> _allCatList = new List<CATM.CategoryModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //reference the dropdown lists
  List<String> _selectedCat = new List<String>(20);
  List<String> _selectedFood = new List<String>(20);

//
  final List<String> _suggestions = [
    "Suggestion 1",
    "Suggestion 2",
    "Suggestion 3",
    "Suggestion 4",
    "Suggestion 5",
  ];

  //
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  //
  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

  //
  bool isFirst = false;
  SharedPreferences petPrefs;
  String petName = '';
  String petAge = '';

//
  TextEditingController _mealPlanNumberController = TextEditingController();
  TextEditingController _mealPlanNumber2Controller = TextEditingController();
  List<TextEditingController> _mealPlanQtyController = new List();

  bool isSwitchedMealPlans = false;
  bool _swapInsideBTMS = true;
  int _defaultChoiceIndex = 0;

//
  String _userEmail='';
  String _userToken='';
  String _petID = '0';
  String _petName = 'Name';
  String _petAge = '0';
  String petNameApi = '';
  String petAgeApi = '';
  String petIDApi = '';
  bool isImperial = false;
  bool _isData = false;
  String jsonString = '';
  bool _userSubscribed = false;
  bool onMealPlan = false;

  String _petImage = '';
  String _petImageView = '';
  String unit = 'gm';
  //
  //drop down variables
  List<String> _categoryList = new List<String>();
  List<String> _foodsList = new List<String>();

  //
  // CategoryModel _selectedFoodType;
  List<CATM.Food> foodTypeList = []; //new List<CATM.Food>();
  bool isCatSelected = false;
  bool disableDP1 = false;
  bool disableDP2 = true;
  List<MPD.FeedingPlanDetail> foodPlanDetails;

  //
  List tempList = List();
  CATM.CategoryModel _category; //state
  CATM.Food _foodType; //province
  //
  String _selectedValCategory = 'cat';
  String _selectedValFood = 'food';
  String foodTypeID = '';
  String _displayValue = '';
  //
  MealPlanModel _mealPlan;
  MealPlanDetailModel _mealPlanDetail;
  List<UserInputs> _allUserInputs = List<UserInputs>();

  @override
  void initState() {
    super.initState();
    debugPrint('current: MealPlanScreen: initState() called!');
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    _showMealChips = true;
    loadLocalData();
    // _updateChips();
    // _fetchData();
  }

  // _onSubmitted(String value) {
  //   int j= int.parse(value);
  //   setState(() {
  //     for(int i=0; i<_allUserInputs.length; i++){
  //       j = j+int.parse(_allUserInputs[i].quantity);
  //     }
  //     _displayValue = j.toString();
  //   });
  // }
  _updateChips() {
    // _showMealChips = true;
    // _allUserInputs = [];
    // for (var i = 0; i < 20; i++) {
    //   _allUserInputs.add(new UserInputs()); // obj with default values
    // }
    setState(() {});
  }

  _fetchData(String item) async {
    setState(() {
      _isLoading = true;
    });
    // pr.show();
    // await loadLocalData(); //.then(
    // (value) =>
    await getAllMealPlanData(item); //.whenComplete(() =>
    // pr.hide();
    // if(_allMealPlanList.length == 0){
    //   _showSnackbar('No Meal Plans Yet!', errorNet);
    // }else{
    //   //
    // }
    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackbar(String msg, Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  Future<void> loadLocalData() async {
    petPrefs = await SharedPreferences.getInstance();
    // onMealPlan = petPrefs.getBool('on_mealPlan');
    // _showMealChips = onMealPlan;
    isFirst = petPrefs.getBool('first_time');
    print('is first '+isFirst.toString());
    // var prefJson = viewPrefs.getString('userData');
    // var user = json.decode(prefJson);
    _userEmail = petPrefs.getString('user_email');
    print(_userEmail);
    _userToken = petPrefs.getString('user_token');
    print(_userEmail);
    _petID = petPrefs.getString('pet_id');
    print(_petID);
    // _petName = petPrefs.getString('pet_name');
    // print(_petName);
    // _petAge = petPrefs.getString('pet_age');
    // print(_petAge);
    // _petName = petPrefs.getString('pet_name');
    // print(_petName);
    isImperial = petPrefs.getBool('user_imperial');
    print(isImperial);
    _userSubscribed = petPrefs.getBool('user_subscribed');
    print(_userSubscribed.toString());

    _allCatList = await _fetchCategoryData();
    await _fetchData(_petID);
  }

  //
  Future<List<AllMealPlanModel>> getAllMealPlanData(String item) async {
    // await _fetchCategoryData();
    pr.show();
    //
    _mealPlanApiUrl =
    'feeding_plans/fetch_all?user_email=$_userEmail&user_token=$_userToken&pet_id=$item';
    String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    String _fullUrl = _baseUrl + _mealPlanApiUrl;
    final response = await CallApi().getData(_mealPlanApiUrl);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();
      print(response.body.toString());
      var res = json.decode(response.body);
      if(!res['success']){
        // print(json.decode(res));
        _allMealPlanList = [];
        pr.hide();
        _showSnackbar('No Meal plans yet!', errorNet);
        return _allMealPlanList;

      }
      // else {
        //
        values = json.decode(response.body);
        if (values.length > 0) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              _allMealPlanList.add(AllMealPlanModel.fromJson(map));
              debugPrint('Id-------${map['id']}');
              debugPrint('pet_name-------${map['petName']}');
            }
          }
        }
        print(_allMealPlanList);
      pr.hide();
        return _allMealPlanList;
      // }
    } else {
      _allMealPlanList = [];
      pr.hide();
      _showSnackbar('A Network Error Occurred.!', errorNet);
      return _allMealPlanList;
      // If that call was not successful, throw an error.
      // throw Exception('Failed to load data');
    }
  }

  //
  Future<List<CATM.CategoryModel>> _fetchCategoryData() async {
    //
    setState(() {
      _isLoading = true;
    });

    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/category.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      _allCatList = CATM.categoryModelFromJson(response.body);
      // print(_allCatList.toString());
      for (int i = 0; i < _allCatList.length; i++) {
        _categoryList.add(_allCatList[i].name);
      }
      // print(_categoryList.toString());
      // pr.hide();
      _selectedValCategory = _allCatList[0].name;
      // pr.hide().whenComplete(
      //       () =>
      //           setState(() {
      //         categoryList = _allCatList;
      //         //
      //       });
      //   ,
      // );
      return _allCatList;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    // pr.show();
    // _mealCatApiUrl =
    // 'food_categories/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    // final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    // final String _fullUrl = _baseUrl + _mealCatApiUrl;
    // final response = await CallApi().getData(_mealCatApiUrl);
    // if (response.statusCode == 200) {
    //   // If the call to the server was successful, parse the JSON
    //   List<dynamic> values = new List<dynamic>();
    //   values = json.decode(response.body);
    //   if (values.length > 0) {
    //     for (int i = 0; i < values.length; i++) {
    //       if (values[i] != null) {
    //         Map<String, dynamic> map = values[i];
    //         _allCatList.add(CATM.CategoryModel.fromJson(map));
    //         debugPrint('Id-------${map['id']}');
    //         debugPrint('name-------${map['name']}');
    //         debugPrint('foods-------${map['foods']}');
    //       }
    //     }
    //   }
    //   print(_allCatList.toString());
    //   for (int i = 0; i < _allCatList.length; i++) {
    //     _categoryList.add(_allCatList[i].name);
    //   }
    //   print(_categoryList.toString());
    //   _selectedValCategory = _allCatList[0].name;
    //   // pr.hide().whenComplete(
    //   //       () =>
    //   //           setState(() {
    //   //         categoryList = _allCatList;
    //   //         //
    //   //       });
    //   //   ,
    //   // );
    //   return _allCatList;
    // } else {
    //   // pr.hide();
    //   _showSnackbar('A Network Error Occurred.!', errorNet);
    //   return _allCatList = []; //_allCatList = [];
    //   // If that call was not successful, throw an error.
    //   // throw Exception('Failed to load data');
    // }
  }

  void submitMealPlan(List<UserInputs> userInputsList) async {
    setState(() {
      _isLoading = false;
    });
    pr.show();
    var mealsPerDay = _mealPlanNumberController.text.toString();
    var mealIngredientsWouldMake = _mealPlanNumber2Controller.text.toString();
    var weightOfBalancedMeal = _swapInsideBTMS ? 'true' : 'false';

    var mealPlanData = {
      "user_email": _userEmail,
      "user_token": _userToken,
      "feeding_plan": {
        "meal_ingredients_would_make": mealIngredientsWouldMake,
        "meals_per_day": mealsPerDay,
        "show_weight_of_balanced_meal": weightOfBalancedMeal,
        "pet_id": _petID
      }
    };

    final mealPlan =
    await CallApi().createMealPlan(mealPlanData, 'feeding_plans/create');
    if (mealPlan != null) {
      if (mealPlan.success) {
        setState(() {
          _mealPlan = mealPlan;
        });

        String mealPlanID = _mealPlan.feedingPlan.id.toString();
        print(mealPlanID);
        print(userInputsList);
        userInputsList.removeWhere((item) => item.foodId == '');
        print('new '+ userInputsList.toString());
        //
        if (userInputsList.isNotEmpty) {
          await submitMealPlanDetails(mealPlanID, userInputsList);
        } else {
          pr.hide().whenComplete(() {
            _showSnackbar('No meal plans to add', errorAPI);
          });
        }
        //
        pr.hide();
            // .whenComplete(() {
          //todo navigate to details page
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MealPlanDetailsScreen(
                mealPlanID: mealPlanID,
                allCatList: _allCatList,
              )));
        // });
      } else {
        String msg = mealPlan.message;
        print(msg);
        setState(() {
          _isLoading = false;
        });
        pr.hide().whenComplete(() {
          _showSnackbar(msg, errorAPI);
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      pr.hide().whenComplete(() {
        _showSnackbar('A Network Error Occurred.!', errorNet);
      });
    }
  }

  Future<void> submitMealPlanDetails(
      String item, List<UserInputs> userInputList) async {
    for (int i = 0; i < userInputList.length; i++) {
      if(userInputList[i].foodId!=''){

        var mealPlanDetailsData = {
          "user_email": _userEmail,
          "user_token": _userToken,
          "feeding_plan_detail": {
            "quantity": userInputList[i].quantity,
            "food_id": userInputList[i].foodId,
            "feeding_plan_id": item
          }
        };

        final mealPlanDetail = await CallApi().createMealPlanDetail(
            mealPlanDetailsData, 'feeding_plan_details/create');

        if (mealPlanDetail != null) {
          if (mealPlanDetail.success) {
            setState(() {
              _mealPlanDetail = mealPlanDetail;
            });
            print(_mealPlanDetail.feedingPlanDetail.toString());
          } else {
            String msg = mealPlanDetail.message;
            print(msg);
            setState(() {
              _isLoading = false;
            });
            // pr.hide().whenComplete(() {
            _showSnackbar(msg, errorAPI);
            // });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          // pr.hide().whenComplete(() {
          _showSnackbar('A Network Error Occurred.!', errorNet);
          // });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );
    //
    pr.style(
      message: 'Please Wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w600),
    );
    //
    // add/edit meal plan bottom Sheet //
    // var _allUserInputs;
    _mealPlanBtmSheet() {
      unit = !isImperial ? 'gm':'ounce';
      int total = 0;
       //_mealPlan
      _allUserInputs = List<UserInputs>();
      for (int i = 0; i < 20; i++) {
        _allUserInputs.add(UserInputs()); // = UserInputs();
      }
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 40.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Container(
//                  child: new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Meal Plan for $_petName', //$_petName
                      style: kTitleStyleBlackLight,
                    ),
                    // SizedBox(height: 12.0),
                    Text(
                      'Remember to Include Additional Daily Foods',
                      style: kMainHeadingStyleBlack,
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      // height: 36.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'How many meals does Dog\neat per day?',
                            style: kSubContentStyleBlack,
                          ),
                          Container(
                            color: Colors.grey[100],
                            width: 60.0,
                            height: 40.0,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _mealPlanNumberController,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              validator: validateNumber,
                              onSaved: (String value) {
                                // _petWeight = value; //double.parse(value);
                              },
//      initialValue: 'alucard@gmail.com',
                              style: kSubContentStyleBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Work out the weight of a\nbalanced meal?',
                            style: kSubContentStyleBlack,
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width*0.4,
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            // width: MediaQuery.of(context).size.width,
                            child: ToggleSwitch(
                              cornerRadius: 5.0,
                              minWidth: 60.0,
                              minHeight: 40.0,
                              fontSize: 16.0,
                              initialLabelIndex: _swapInsideBTMS ? 0 : 1,
                              activeBgColor: Color(0xFF03B898),
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey[300],
                              inactiveFgColor: Colors.black54,
                              labels: ['  Yes  ', '  No  '],
                              onToggle: (index) {
                                print('switched to: $index');
                                print('switched to: $_swapInsideBTMS');
                                setState(() {
                                  _swapInsideBTMS = !_swapInsideBTMS;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            'This plan is for',
                            // ${_mealPlanNumberController.text} meals',
                            style: kSubContentStyleBlack,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Container(
                            // color: Colors.grey[100],
                            width: 60.0,
                            height: 40.0,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _mealPlanNumber2Controller,
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              autofocus: false,
                              validator: validateNumber,
                              onSaved: (String value) {
                                // _petWeight = value; //double.parse(value);
                              },
//      initialValue: 'alucard@gmail.com',
                              style: kSubContentStyleBlack,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'meals',
                            style: kSubContentStyleBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _swapInsideBTMS,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Weight of One Meal: '+unit,
                          style: kSubContentStyleBlack,
                        ),
                      ),
                    ),
                    // Visibility(
                    //   maintainSize: true,
                    //   maintainAnimation: true,
                    //   maintainState: true,
                    //   visible: !_swapInsideBTMS,
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       'Weight of a Balanced Meal: 395 gm',
                    //       style: kSubContentStyleBlack,
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                    //   alignment: Alignment.centerRight,
                    //   child: ClipOval(
                    //     child: Container(
                    //       color: Color(0xFF01816B),
                    //       height: 60.0, // height of the button
                    //       width: 60.0, // width of the button
                    //       child: new Icon(
                    //         Icons.add,
                    //         color: Colors.white,
                    //         size: 32.0,
                    //       ),
                    //     ),
                    //   ),
                    //   // RaisedButton(
                    //   //   shape: RoundedRectangleBorder(
                    //   //       borderRadius: BorderRadius.circular(64.0),
                    //   //       side: BorderSide(
                    //   //         color: Color(0xFF03B898),
                    //   //       )),
                    //   //   onPressed: () {},
                    //   //   color: Color(0xFF03B898),
                    //   //   textColor: Colors.white,
                    //   //   child: new Icon(
                    //   //     Icons.add,
                    //   //     color: Colors.white,
                    //   //     size: 24.0,
                    //   //   ),
                    //   // ),
                    // ),
                    SizedBox(height: 12.0),
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                        itemCount: _allUserInputs.length, //20,
                        itemBuilder: (BuildContext context, int index) {
                          _mealPlanQtyController
                              .add(new TextEditingController());
                          // _allUserInputs = List<UserInputs>[5];
                          // _allUserInputs = List<UserInputs>(20);
                          // for(int i=0; i<20; i++){
                          //   _allUserInputs.add(UserInputs()); // = UserInputs();
                          // }
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                            width: MediaQuery.of(context).size.width * 0.95,
                            // height: 100.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  10.0,
                                )),
                                color: Color(0xFF01816B),
                                shape: BoxShape.rectangle),
                            //
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Category",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        // child: FittedBox(
                                        //   fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Food Type",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        // ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Quantity($unit)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontFamily: 'poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          // height: 48.0,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    10.0,
                                                  )),
                                              color: Color(0xFF03B898),
                                              shape: BoxShape.rectangle),
                                          child: DropdownButton<String>(
                                            //<CATM.CategoryModel>(
                                            //<CATM.CategoryModel>(
                                            // value:_selectedCat[index],//_selectedValCategory, //_category,
                                            // _selectedCategory,
                                            isDense: false,
                                            isExpanded: true,
                                            // icon: Icon(Icons.arrow_downward),
                                            hint: Text(
                                              _selectedCat[index] != null
                                                  ? _selectedCat[index]
                                                  : 'Category',
                                              style:
                                              kSubContentStyleWhitSmaller,
                                            ),
                                            // iconSize: 24,
                                            // elevation: 16,
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged:
                                            // (_allCatList == null) ? null :
                                            // (CATM.CategoryModel selectedCat) {
                                                (String newVal) {
                                              // (dynamic selectedCat) {
                                              // _foodType = null;
                                              // this._selectedCategory =
                                              //     selectedCat;
                                              // _category =
                                              //     this._selectedCategory.name;
                                              // tempList = _selectedCategory.foods
                                              //     .toList();
                                              // isCatSelected = true;
                                              // // _selectedCategory[index] =
                                              // //     _selectedCategory;
                                              // catName = _selectedCategory.name;
                                              // // _selectedCategoryList[index].name;
                                              // // foodTypeList =
                                              // //     // _selectedCategoryList[index]
                                              // //     _selectedCategory.foods
                                              // //         .toList();
                                              // print(foodTypeList.toString());
                                              // catID =
                                              //     //_selectedCategoryList[index]
                                              //     _selectedCategory.id.toString();
                                              // _selectedValCategory = newVal;

                                              setState(() {
                                                _selectedFood[index] = null;
                                                // _selectedValFood = null;
                                                // _foodType = null;
                                                // _category
                                                _selectedCat[index] = newVal;
                                                // _selectedValFood = null;
                                                print(_selectedCat[index]);
                                                // _selectedValCategory = newVal;
                                                // foodTypeList.clear();
                                                _foodsList.clear();
                                                // foodTypeList.clear();
                                                // this._selectedCategory =
                                                //     selectedCat;
                                                // foodTypeList =
                                                // _selectedCategoryList[index]
                                                for (int i = 0;
                                                i < _allCatList.length;
                                                i++) {
                                                  if (_allCatList[i].name ==
                                                      _selectedCat[index]) {
                                                    //_selectedValCategory
                                                    foodTypeList =
                                                        _allCatList[i].foods;
                                                    //
                                                    for (int j = 0;
                                                    j < foodTypeList.length;
                                                    j++) {
                                                      _foodsList.add(
                                                          foodTypeList[j].name);
                                                    }
                                                    // _selectedValFood = foodTypeList[0].name;
                                                  }
                                                }
                                                // foodTypeList = //_selectedCategory
                                                // selectedCat.foods
                                                //     .toList();
                                                // disableDP2 = false;
                                              });
                                            },
                                            items: _categoryList.map((cat) {
                                              //_allCatList
                                              return new DropdownMenuItem<
                                                  String>(
                                                //<CATM.CategoryModel>(
                                                //<CATM.CategoryModel>(
                                                child: new Text(cat),
                                                value: cat,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Container(
                                          // height: 48.0,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    10.0,
                                                  )),
                                              color: Color(0xFF03B898),
                                              shape: BoxShape.rectangle),
                                          child: DropdownButton<String>(
                                            //<CATM.Food>(
                                            //<CATM.Food>(
                                            // value: _selectedFood[index],//_selectedValFood, //_foodType,
                                            //_selectedFoodType,
                                            isDense: false,
                                            isExpanded: true,
                                            hint: Text(
                                              _selectedFood[index] != null
                                                  ? _selectedFood[index]
                                                  : 'FoodType',
                                              style:
                                              kSubContentStyleWhitSmaller,
                                            ),
                                            // iconSize: 24,
                                            // elevation: 2,
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged:
                                            // disableDP2 ? null : (CATM.Food newValue) {
                                            // (CATM.Food newValue) {
                                                (String newVal) {
                                              // _selectedValFood = newVal;
                                              setState(() {
                                                // _selectedFoodType = null;
                                                // foodTypeList.clear();
                                                // _foodType = newValue;
                                                _selectedFood[index] = newVal;
                                                _selectedValFood =
                                                _selectedFood[index];
                                                print(_selectedFood[index]);
                                                // _selectedValFood = newVal;
                                                // _selectedFoodType = newValue;
                                                // for(var item in _)
                                                // foodTypeName = newValue
                                                //     _selectedFoodType.name;
                                                for (int i = 0;
                                                i < _allCatList.length;
                                                i++) {
                                                  if (_allCatList[i].name ==
                                                      _selectedCat[index]) {
                                                    //_selectedValCategory
                                                    foodTypeList =
                                                        _allCatList[i].foods;
                                                    //
                                                    for (int j = 0;
                                                    j < foodTypeList.length;
                                                    j++) {
                                                      if (foodTypeList[j]
                                                          .name ==
                                                          _selectedFood[
                                                          index]) {
                                                        foodTypeID =
                                                            foodTypeList[j]
                                                                .id
                                                                .toString();
                                                        //
                                                        _allUserInputs[index]
                                                            .foodId =
                                                            foodTypeID;
                                                      }
                                                    }
                                                    // _selectedValFood = foodTypeList[0].name;
                                                  }
                                                }

                                                //     .toString();
                                                // disableDP2 = false;
                                              });
                                            },
                                            items: _foodsList.map((fdt) {
                                              //foodTypeList
                                              return new DropdownMenuItem<
                                                  String>(
                                                // <CATM.Food>(
                                                //<CATM.Food>(
                                                child: new Text(fdt),
                                                value: fdt,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              3,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 4.0),
                                          // height: 48.0,
                                          // color: Colors.grey[100],
                                          // padding: EdgeInsets.all(2.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    10.0,
                                                  )),
                                              color: Color(0xFF03B898),
                                              shape: BoxShape.rectangle),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              // filled: true,
                                              // fillColor: Color(0xFFF0F0F0),
                                              hintText:
                                              _mealPlanQtyController[index]
                                                  .text !=
                                                  null
                                                  ? _mealPlanQtyController[
                                              index]
                                                  .text
                                                  : '000',
                                              hintStyle: TextStyle(
                                                  color: Colors.black45),
                                            ),
                                            // controller: _mealPlanQtyController,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(
                                                  3),
                                            ],
                                            onChanged: (String val) {
                                              int temp;
                                              setState(() {
                                                _mealPlanQtyController[index]
                                                    .text = val;
                                                _allUserInputs[index].quantity = val;
                                                temp = int.parse(_mealPlanQtyController[index]
                                                    .text.toString());
                                                total = total + temp;
                                              });
                                            },
                                            // decoration: InputDecoration(
                                            //   border: OutlineInputBorder(),
                                            // ),
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            validator: validateNumberDecimal,
                                            // onFieldSubmitted: _onSubmitted,
                                            onSaved: (String value) {
                                              //
                                              _mealPlanQtyController[index]
                                                  .text = value;
                                              _allUserInputs[index].quantity =
                                                  _mealPlanQtyController[index]
                                                      .text;
                                              // _petWeight = value; //double.parse(value);
                                            },
//      initialValue: 'alucard@gmail.com',
                                            style: kSubContentStyleWhitSmaller,
                                          ),
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
                    ),

                    // SizedBox(height: 12.0),
                    // Expanded(
                    //   flex: 5,
                    //   child: Container(
                    //     margin: EdgeInsets.only(top: 4.0),
                    //     width: MediaQuery.of(context).size.width,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(10.0),
                    //       ),
                    //     ),
                    //     // child: Card(
                    //     child: Text(''), //getCustomContainer(), //,//
                    //   ),
                    // ),

                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 1,
                              // padding: EdgeInsets.symmetric(horizontal: 16.0),
//                    child: Container(
//                      width: 150.0,
//                      color: Colors.white, //Color(0xFF01816B),
//                    width: MediaQuery.of(context).size.width,
                              child: new FlatButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                minWidth: 150.0,
                                height: 50.0,
                                color: Colors.white,
                                colorBrightness: Brightness.light,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    width: 2.0,
                                    color: Color(0xFF01816B),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // _isSubscribed = false;
                                  // _isLoading ? null : _handleSubmitUser(context);
                                },
                                child: new Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    color: Color(0xFF01816B),
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
//                          ),
//                       padding: EdgeInsets.all(2),
                              ),
//                    ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              flex: 1,
                              // padding: EdgeInsets.symmetric(horizontal: 16.0),
//                    child: Container(
//                      width: 150.0,
//                      color: Color(0xFF01816B),
                              child: new FlatButton(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                minWidth: 150.0,
                                height: 50.0,
                                color: Color(0xFF01816B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    width: 2.0,
                                    color: Color(0xFF01816B),
                                  ),
                                ),
                                onPressed: () {
                                  // _addItem();
                                  // setState((){
                                  // _showMealChips = false;
                                  // });
                                  if(_mealPlanNumberController.text.isEmpty && _mealPlanNumber2Controller.text.isEmpty){
                                    _showSnackbar('Meal plans per day and This plan is for fields must not be Null!', errorAPI);
                                  }else {
                                    Navigator.of(context).pop();
                                  }
                                  // _isSubscribed = true;
                                  // _isLoading ? null : _handleSubmitUser(context);
                                },
                                child: new Text(
                                  'SAVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
//                        ),
//                       padding: EdgeInsets.all(2),
                              ),
//                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        // await _allUserInputs;
        print('calling after hide bottomSheet');
        print(_allUserInputs);
        if(_mealPlanNumberController.text.isEmpty && _mealPlanNumber2Controller.text.isEmpty){
          _showSnackbar('"Meal plans per day & This meal plan is for fields must not be empty!" ',errorAPI);
        }else if (_allUserInputs[0].foodId == ''){
          _showSnackbar('"No Meal plans were added" ', errorNet);
        }else{
          submitMealPlan(_allUserInputs);
        }
      });
      //     print(selectedIndex);
      // fetchPet(selectedIndex);
      //todo on success in getting api response as a list to view in the table
      //     setState((){
      //   _showMealChips = false;
      // });
      // );
    }

    //
    Widget choiceChips() {
      return Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: List<Widget>.generate(
          _allMealPlanList.length,
              (index) => ChoiceChip(
            padding: EdgeInsets.all(5.0),
            avatar: CircleAvatar(
              child: Text(
                _allMealPlanList[index].petName[0].toUpperCase(),
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500),
              ),
              backgroundColor: Color(0xFF03B898),
            ),
            label: Text(
              _allMealPlanList[index].petName + '\'s Meal Plan ${index + 1}',
            ),
            selected: _defaultChoiceIndex == index,
            selectedColor: Colors.green,
            onSelected: (bool selected) async {
              //todo pass the meal plan id to the details page
              // await _fetchMealPlanDetails(_allMealPlanList[index].id);
              // onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MealPlanDetailsScreen(
                    mealPlanID: _allMealPlanList[index].id.toString(),
                    allCatList: _allCatList,
                  )));
              setState(() {
                _defaultChoiceIndex = selected ? index : 0;
              });
            },
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    //
    final petHeader = Container(
      // alignment: Alignment.center,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Hero(
                tag: 'hero',
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    // radius: 30.0,
                    backgroundColor: Colors.grey[300],
                    child: _petImageView == ''
                        ? Img.Image(
                      image: AssetImage(
                        'assets/images/logo_small.png',
                      ),
                      height: 40.0,
                      width: 40.0,
                    )
                        : Img.Image(
                      image: NetworkImage(
                        _petImageView,
                        scale: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            // child: Container(
            //   width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(left: 4.0,),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        _petName, //_petID == '0' ? 'Name' : _petName,
                        style: TextStyle(
                          // fontSize: 22.0,
                            fontFamily: 'poppins',
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                        textAlign:TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        _petAge + ' years', //_petID == '0' ? '0' : _petAge + ' years',
                        style: TextStyle(
                          // fontSize: 14.0,
                            fontFamily: 'poppins',
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                        textAlign:TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 8.0,vertical: 12.0,
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: const Text(
                  'Meal Plan',
                  style: TextStyle(
                    // fontSize: 32.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //
    //suggestions bottom sheet
    _suggestionsBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          alignment: Alignment.center,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  //     child:
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    // child: Row(
                    //   children: [
                    child: Container(
                      // height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        'Suggestions',
                        style: kTitleStyleBlackMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: ListView(
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: _suggestions
                          .map(
                            (data) => Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.75,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        '" ' + data + ' "',
                                        style: kMinTitleStyleBlack,
                                        // textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: new FlatButton(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                              minWidth: 150.0,
                              height: 60.0,
                              color: Colors.white,
                              colorBrightness: Brightness.light,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  width: 2.0,
                                  color: Color(0xFF01816B),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                // _isSubscribed = false;
                                // _isLoading ? null : _handleSubmitUser(context);
                              },
                              child: new Text(
                                'CANCEL',
                                style: TextStyle(
                                  color: Color(0xFF01816B),
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
//                          ),
//                       padding: EdgeInsets.all(2),
                            ),
//                    ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            flex: 1,
                            child: new FlatButton(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                              minWidth: 150.0,
                              height: 60.0,
                              color: Color(0xFF01816B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  width: 2.0,
                                  color: Color(0xFF01816B),
                                ),
                              ),
                              onPressed: () {
                                // _addItem();
                                // _isSubscribed = true;
                                // _isLoading ? null : _handleSubmitUser(context);
                              },
                              child: new Text(
                                'APPLY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
//                        ),
//                       padding: EdgeInsets.all(2),
                            ),
//                    ),
                          ),
                        ],
                      ),
                    ),
                    // ),
                  ),
                ),
              ],
            ),
            // ),
          ),
        ),
      );
    }

    //
    final mealButtons = Container(
      alignment: Alignment.center,
      // padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: FlatButton(
              // minWidth: 120.0,
              color: Colors.white,
              colorBrightness: Brightness.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 2.0,
                  color: Color(0xFF03B898),
                ),
              ),
              onPressed: () {
                _suggestionsBottomSheet();
                // _isSubscribed = false;
                // _isLoading ? null : Navigator.of(context).pop();
              },
              child: new Text(
                'VIEW SUGGESTIONS',
                style: TextStyle(
                  color: Color(0xFF03B898),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
//                          ),
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
          // Spacer(),
          Expanded(
            flex: 1,
            child: FlatButton(
              // minWidth: 120.0,
              color: Colors.white,
              colorBrightness: Brightness.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 2.0,
                  color: Color(0xFF03B898),
                ),
              ),
              onPressed: () async {
                setState(() {
                  isFirst = true;
                });
                // await Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return
                _mealPlanBtmSheet();
                // (MealPlan(
                //   '', '', '')
                // ); //navigateToDetail(MealPlan('', '', ''));
                // }));
                // navigateToDetail(MealPlan('', '', ''));
                // _isSubscribed = false;
                // _isLoading ? null : Navigator.of(context).pop();
              },
              child: new Text(
                'ADD MEAL PLAN',
                style: TextStyle(
                  color: Color(0xFF03B898),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'poppins',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
//                          ),
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
        ],
      ),
    );
    //
    _deleteMealPlan(int item) async {
      String _baseUrl = '';
      String _fullUrl = '';
      String apiUrl = '';
      apiUrl = 'feeding_plan_details/remove';
      _baseUrl = 'https://api.pawfect-balance.oz.to/';
      _fullUrl = _baseUrl + apiUrl;
      //
      var response = await http.delete(_fullUrl);
      print('-------- item deleted ----------');
      if (response.statusCode == 200) {
        String res = response.body;
        var resJson = json.decode(res);
        var msgSuccess = resJson["success"];
        //
        _showSnackbar('Deleted Successfully.!', successAPI);
      } else {
        // If that call was not successful (response was unexpected), it throw an error.
        _showSnackbar('A Network Error Occurred.!', errorNet);
        throw Exception('Failed to load Pet');
      }
    }

    //
    Widget _buildItem(
        MPD.FeedingPlanDetail item, Animation animation, int index) {
      CATM.CategoryModel category;
      for (var i = 0; i < _allCatList.length; i++) {
        List<CATM.Food> _foods = _allCatList[i].foods;
        for (var j = 0; j < _foods.length; j++) {
          if (_foods[j].id == foodPlanDetails[index].food.id) {
            category = _allCatList[i];
          }
        }
      }
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    foodPlanDetails != null ? category.name : "category",
                    // item.category,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    foodPlanDetails != null ? item.food.name : "Type",
                    //item.foodType,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    foodPlanDetails != null
                        ? item.quantity.toString() + 'gm'
                        : "000",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        MPD.FeedingPlanDetail removedItem =
                        foodPlanDetails.removeAt(index);
                        AnimatedListRemovedItemBuilder builder =
                            (context, animation) {
                          _deleteMealPlan(index);
                          return _buildItem(removedItem, animation, index);
                        };
                        _listKey.currentState.removeItem(index, builder);
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    }

    //
    Widget _disclaimer() => Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: _allMealPlanList.length != 0
          ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    'Add from Existing Meal Plans',
                    style: kSubContentStyleWhitSmall,
                  )),
              Expanded(
                flex: 9,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: choiceChips()
                ),
              ),
            ],
          ))
          : Center(
        child: const Text(
          'EMPTY',
          style: TextStyle(
              fontSize: 32.0,
              fontFamily: 'poppins',
              color: Colors.black87,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
    //
    final mainBody = Container(
      margin: EdgeInsets.only(
        top: 16.0,
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        top: 12.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1.0],
          colors: [
            Color(0xFF03B898),
            Color(0xFF01816B),
          ],
        ),
      ),
      child: Column(
        children: <Widget>[
          // SizedBox(height: 32.0),
          Expanded(
            flex: 1,
            child: petHeader,
          ),

          Expanded(
            flex: 1,
            child: mealButtons,
          ),

          Expanded(
            flex: 10,
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _disclaimer(), // : body(),
          ),
          // lorem,
        ],
      ),
    );
    //
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: mainBody, //_isShowingDialog ? bodyWithDialog : bodyWithCharts
    );
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Home Page'),
    //     ),
    //     body: Center(
    //       child: RaisedButton(
    //         onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeSubPage())),
    //         child: Text('Open Sub-Page'),
    //       ),
    //     ),
    //   );
  }
}

class UserInputs {
  String foodId;
  String quantity;

  //
  UserInputs({this.foodId = '', this.quantity = ''});
}

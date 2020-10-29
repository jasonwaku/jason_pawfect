import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/models/daily_guide_model/daily_guide_model.dart';
import 'package:pawfect/models/meal_plan.dart';
import 'package:pawfect/models/meal_plan_detail_model/category_model.dart';
import 'package:pawfect/models/meal_plan_detail_model/meal_plan_detail.dart';
import 'package:pawfect/models/meal_plan_model/all_meal_plan.dart';
import 'package:pawfect/models/meal_plan_model/meal_plan_model.dart';
import 'package:pawfect/screens/meal_plan/chartline_meals.dart';
import 'package:pawfect/screens/meal_plan/chartline_small.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/local/database_helper.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pawfect/models/meal_plan_detail_model/category_model.dart'
as CATM;import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:pawfect/models/meal_plan_model/meal_plan_fetch.dart' as MPD;
import 'package:sqflite/sqlite_api.dart';
import 'package:toggle_switch/toggle_switch.dart';

enum widgetMarker { macro, micro }
enum LegendShape { Circle, Rectangle }

class MealPlanDetailsScreen extends StatefulWidget {
  final String mealPlanID;
  final List<CATM.CategoryModel> allCatList;
  const MealPlanDetailsScreen({Key key, this.mealPlanID, this.allCatList}) : super(key: key);
  // // Here you direct access using widget
  //     return Text(widget.mealPlanID);
  static String tag = 'meal-plan-detail-page';
  //


  @override
  _MealPlanDetailsScreenState createState() => _MealPlanDetailsScreenState();
}

class _MealPlanDetailsScreenState extends State<MealPlanDetailsScreen> with AutomaticKeepAliveClientMixin{
  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;
  //
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
  ProgressDialog pr;
  bool _isLoading = false;
  bool _showMealChips; //=false;
  String _mealPlanApiUrl = '';
  String _mealCatApiUrl = '';
  //
  List<bool> isSelected = [false, false, false];
  widgetMarker selectedWidget = widgetMarker.macro;
  int selectedSwitchIndex;
  // List<AllMealPlanModel> _allMealPlanList = new List<AllMealPlanModel>();
  List<CATM.CategoryModel> _allCatList = new List<CATM.CategoryModel>();
  //
//reference the dropdown lists
  List<String> _selectedCat = new List<String>(20);
  List<String> _selectedFood = new List<String>(20);
  //
  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];
  //
  bool isFirst = false;
  SharedPreferences petPrefs;
  String petName = '';
  String petAge = '';
  String _userEmail='';
  String _userToken='';
  String _petID = '0';
  String _petName = 'Name';
  String _petAge = '0';
  String petNameApi = '';
  String petAgeApi = '';
  bool isImperial = false;
  String petIDApi = '';
  bool _isData = false;
  String jsonString = '';
  bool _userSubscribed = false;
  bool onMealPlan = false;

  String _petImage = '';
  String _petImageView = '';
  String unit ='gm';
  //
  TextEditingController _mealPlanNumberController = TextEditingController();
  TextEditingController _mealPlanNumber2Controller = TextEditingController();
  List<TextEditingController> _mealPlanQtyController = new List();

  //
  bool isSwitchedMealPlans = false;
  bool _swapInsideBTMS = true;
  int _defaultChoiceIndex = 0;
  //
  List<MealPlan> mealPlanList = [
    new MealPlan('cat1', 'food type1', '200'),
    new MealPlan('cat2', 'food type2', '300'),
    new MealPlan('cat3', 'food type3', '400'),
    new MealPlan('cat4', 'food type4', '500'),
  ];
//
  final List<String> _suggestions = [
    "Suggestion 1",
    "Suggestion 2",
    "Suggestion 3",
    "Suggestion 4",
    "Suggestion 5",
  ];
  //
  var myVariable = 0;
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  Map<String, double> dataMap = {
    "Muscle Meat": 60,
    "Organ Meat": 10,
    "Fruit & Veg": 20,
    "Bone": 10,
  };
  List<Color> colorList = [
    Color(0xFF087AAA),
    Color(0xFF058EC9),
    Color(0xFF0BA8EC),
    Color(0xFF32BEFA),
    // Colors.green,
    // Colors.blue,
    // Colors.yellow,
  ];
  //
  //pie chart specifications
  ChartType _chartType = ChartType.disc;
  bool _showCenterText = true;
  double _ringStrokeWidth = 24;
  double _chartLegendSpacing = 20;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = true;
  bool _showChartValuesOutside = false;

  LegendShape _legendShape = LegendShape.Rectangle;
  LegendPosition _legendPosition = LegendPosition.left;

  int key = 0;
  //
  // String _text = '';
  //
  //nutrient base
  double _muscleMeatVal = 0;
  String _muscleMeatClr = '';
  double _organMeatVal = 0;
  String _organMeatClr = '';
  double _fruitNVegVal = 0;
  String _fruitNVegClr = '';
  double _boneVal = 0;
  String _boneClr = '';

  String dailyCalVal = '0.0';
  String dailyCalClr = '';

//
  //nutrient base
  double baseProtein = 1.0;
  double baseCrudeFat = 1.0;

  //
  double baseCalciumPhosphorusRatio = 1.0;
  double baseOmega3_6Ratio = 1.0;


  //
  double baseOmega6 = 1.0;
  double baseOmega3exclALAandSDA = 1.0;
  double baseCalcium = 1.0;
  double basePhosphorus = 1.0;
  double basePotassium = 1.0;
  double baseSodium = 1.0;
  double baseMagnesium = 1.0;
  double baseIron = 1.0;
  double baseCopper = 1.0;
  double baseManganese = 1.0;
  double baseZinc = 1.0;
  double baseIodine = 1.0;
  double baseSelenium = 1.0;
  double baseVitaminA = 1.0;
  double baseVitaminD = 1.0;
  double baseVitaminE = 1.0;
  double baseThiaminB1 = 1.0;
  double baseRiboflavinB2 = 1.0;
  double baseNiacin = 1.0;
  double basePantothenic = 1.0;
  double baseFolate = 1.0;
  double baseCholine = 1.0;
  double baseVitaminC = 1.0;

  //

  //nutrient vals
  String valProtein = '1.0';
  String proteinClr = '';
  String valCrudeFat = '1.0';
  String fatClr = '';

  //
  double valCalciumPhosphorusRatio = 1.0;
  String calPhosRClr = '';
  double valOmega3_6Ratio = 1.0;
  String omegaRClr = '';

  //
  String valOmega6 = '1.0';
  String omega6Clr = '';
  String valOmega3exclALAandSDA = '1.0';
  String omega3Clr = '';
  String valCalcium = '1.0';
  String calciumClr = '';
  String valPhosphorus = '1.0';
  String phosClr = '';
  String valPotassium = '1.0';
  String potClr = '';
  String valSodium = '1.0';
  String sodClr = '';
  String valMagnesium = '1.0';
  String magClr = '';
  String valIron = '1.0';
  String ironClr = '';
  String valCopper = '1.0';
  String copperClr = '';
  String valManganese = '1.0';
  String mangClr = '';
  String valZinc = '1.0';
  String zincClr = '';
  String valIodine = '1.0';
  String iodineClr = '';
  String valSelenium = '1.0';
  String seleClr = '';
  String valVitaminA = '1.0';
  String vAClr = '';
  String valVitaminD = '1.0';
  String vDClr = '';
  String valVitaminE = '1.0';
  String vEClr = '';
  String valThiaminB1 = '1.0';
  String thiamClr = '';
  String valRiboflavinB2 = '1.0';
  String ribofClr = '';
  String valNiacin = '1.0';
  String niacinClr = '';
  String valPantothenic = '1.0';
  String pantoClr = '';
  String valFolate = '1.0';
  String folateClr = '';
  String valCholine = '1.0';
  String cholineClr = '';
  String valVitaminC = '1.0';
  String vCClr = '';

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
  //
  String foodTypeID = '';
  MealPlanModel _mealPlan;
  MealPlanDetailModel _mealPlanDetail;
  List<UserInputs> _allUserInputs = List<UserInputs>();
  //
  @override
  void initState() {
    // _text = 'Click me';
    super.initState();
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    _allCatList = widget.allCatList;
    setCategoriesList(_allCatList);
    loadLocalData(); //.then(
            // (value) =>
            //     _fetchData(widget.mealPlanID));
  }
  //
  setCategoriesList(List<CategoryModel> catList){
    for (int i = 0; i < catList.length; i++) {
      _categoryList.add(catList[i].name);
    }
    print(_categoryList.toString());
  }
//
  //
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
  //
  void _showSnackbar(String msg, Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }
  //
  changeClr(String val) {
    Color _color;
    switch (val) {
      case 'Red':
        _color = Colors.red;
        break;
      case 'Yellow':
        _color = Colors.amber;
        break;
      case 'Green':
        _color = Colors.green;
        break;
      default:
        _color = Colors.green;
        break;
    }
    return _color;
  }
  //
  _fetchData(String item) async{
    setState(() {
      _isLoading = true;
    });
    // pr.show();
    //
    // await getDailyGuideModel();
    // await loadLocalData(); //.then(
    // (value) =>
    await _fetchMealPlanDetails(item);
    // .whenComplete(() =>
    // pr.hide();
    setState(() {
      _isLoading = false;
    });
  }
  //
  Future<void> loadLocalData() async {
    petPrefs = await SharedPreferences.getInstance();
    // onMealPlan = petPrefs.getBool('on_mealPlan');
    // _showMealChips = onMealPlan;
    isFirst = petPrefs.getBool('first_time');
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
    // _petAge = petPrefs.getString('pet_age');
    // print(_petAge);
    isImperial = petPrefs.getBool('user_imperial');
    print(isImperial);
    _userSubscribed = petPrefs.getBool('user_subscribed');
    print(_userSubscribed.toString());
    //
    // await _fetchData(widget.mealPlanID);
    _dailyGuides = await getDailyGuideModel();
    await _fetchData(widget.mealPlanID);
  }

  List<DailyGuideModel> _dailyGuides = new List<DailyGuideModel>();

  Future<List<DailyGuideModel>> getDailyGuideModel() async {
    setState(() {
      _isLoading = true;
    });
    // pr.show();
    // final response = await http.get(Uri.encodeFull(URL));
    //
    // print('URL ${Uri.encodeFull(URL)}');

    // if (response.statusCode == 200) {
    //   print(response.body);
    //   return breweryModelFromJson(response.body);
    // } else {
    //   throw Exception('Error getting brewery');
    // }
    // }
    //

    // fetchGuideLineData() async {
    //
    // String apiUrl =
    //     'guidelines/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    // final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    // final String _fullUrl = _baseUrl + apiUrl;
    //
    // var response = await http.get(_fullUrl);
    // print('------------Daily Guides--------------');
    // print(response);
    //
    // if (response.statusCode == 200) {
    //   String res = response.body;
    //   print(response.body);
      //   return breweryModelFromJson(response.body);
      // If the call to the server was successful (returns OK), parse the JSON.
      // var resJson = json.decode(res);
      // if (resJson['success']) {
      //   print("user create response------------ " + res);
      // jsonString = resJson;
      // List<DailyGuideModel> _dailyGuides = dailyGuideModelFromJson(res);
      //
    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/daily_guides.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      _dailyGuides = dailyGuideModelFromJson(response.body);

      baseProtein = _dailyGuides[0].nutrientGuidelines[0].amount;
      baseCrudeFat = _dailyGuides[0].nutrientGuidelines[1].amount;
      //
      baseCalciumPhosphorusRatio = _dailyGuides[0].nutrientGuidelines[2].amount;
      baseOmega3_6Ratio = _dailyGuides[0].nutrientGuidelines[3].amount;
      //
      baseOmega6 = _dailyGuides[0].nutrientGuidelines[4].amount;
      baseOmega3exclALAandSDA = _dailyGuides[0].nutrientGuidelines[5].amount;
      baseCalcium = _dailyGuides[0].nutrientGuidelines[6].amount;
      basePhosphorus = _dailyGuides[0].nutrientGuidelines[7].amount;
      basePotassium = _dailyGuides[0].nutrientGuidelines[8].amount;
      baseSodium = _dailyGuides[0].nutrientGuidelines[9].amount;
      baseMagnesium = _dailyGuides[0].nutrientGuidelines[10].amount;
      baseIron = _dailyGuides[0].nutrientGuidelines[11].amount;
      baseCopper = _dailyGuides[0].nutrientGuidelines[12].amount;
      baseManganese = _dailyGuides[0].nutrientGuidelines[13].amount;
      baseZinc = _dailyGuides[0].nutrientGuidelines[14].amount;
      baseIodine = _dailyGuides[0].nutrientGuidelines[15].amount;
      baseSelenium = _dailyGuides[0].nutrientGuidelines[16].amount;
      baseVitaminA = _dailyGuides[0].nutrientGuidelines[17].amount;
      baseVitaminD = _dailyGuides[0].nutrientGuidelines[18].amount;
      baseVitaminE = _dailyGuides[0].nutrientGuidelines[19].amount;
      baseThiaminB1 = _dailyGuides[0].nutrientGuidelines[20].amount;
      baseRiboflavinB2 = _dailyGuides[0].nutrientGuidelines[21].amount;
      baseNiacin = _dailyGuides[0].nutrientGuidelines[22].amount;
      basePantothenic = _dailyGuides[0].nutrientGuidelines[23].amount;
      baseFolate = _dailyGuides[0].nutrientGuidelines[24].amount;
      baseCholine = _dailyGuides[0].nutrientGuidelines[25].amount;

      setState(() {});
      // pr.hide();
      // _fetchData();

      return _dailyGuides;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }

      // baseVitaminC = _dailyGuides.nutrientGuidelines[26].amount;
      //
      // await _fetchCategoryData();
      //
      // pr.hide().whenComplete(
      //       () => () => setState(() {
      //             _showMealChips = true;
      //           }),
      //     );
    //   setState(() {
    //     // _showMealChips = true;
    //     _isLoading = false;
    //   });
    //   // return
    //   // } else {
    //   //   print("user failed response------------ " + res);
    //   //   ErrorModel _error = errorModelFromJson(res);
    //   //   String msg = _error.message;
    //   //   _showSnackbar(msg, errorAPI);
    //   // }
    // } else {
    //   // pr.hide().whenComplete(
    //         // () =>
    //             _showSnackbar('A Network Error Occurred.!', errorNet);
    //   // );
    //   // If that call was not successful (response was unexpected), it throw an error.
    //   throw Exception('Failed to load Pet');
    // }
  }

  // Future<List<CATM.CategoryModel>> _fetchCategoryData() async {
  //   // pr.show();
  //   _mealCatApiUrl =
  //   'food_categories/fetch_all?user_email=$_userEmail&user_token=$_userToken';
  //   final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //   final String _fullUrl = _baseUrl + _mealCatApiUrl;
  //   final response = await CallApi().getData(_mealCatApiUrl);
  //   if (response.statusCode == 200) {
  //     // If the call to the server was successful, parse the JSON
  //     List<dynamic> values = new List<dynamic>();
  //     values = json.decode(response.body);
  //     if (values.length > 0) {
  //       for (int i = 0; i < values.length; i++) {
  //         if (values[i] != null) {
  //           Map<String, dynamic> map = values[i];
  //           _allCatList.add(CATM.CategoryModel.fromJson(map));
  //           debugPrint('Id-------${map['id']}');
  //           debugPrint('name-------${map['name']}');
  //           debugPrint('foods-------${map['foods']}');
  //         }
  //       }
  //     }
  //     print(_allCatList.toString());
  //     for(int i = 0; i < _allCatList.length; i++){
  //       _categoryList.add(_allCatList[i].name);
  //     }
  //     print(_categoryList.toString());
  //     _selectedValCategory = _allCatList[0].name;
  //     // pr.hide().whenComplete(
  //     //       () =>
  //     //           setState(() {
  //     //         categoryList = _allCatList;
  //     //         //
  //     //       });
  //     //   ,
  //     // );
  //     return _allCatList;
  //   } else {
  //     // pr.hide();
  //     return _allCatList = [];//_allCatList = [];
  //     // If that call was not successful, throw an error.
  //     // throw Exception('Failed to load data');
  //   }
  // }
  //
  _fetchMealPlanDetails(String item) async {
    setState(() {
      _isLoading = true;
    });
    // pr.show();
    String apiUrl =
        'feeding_plans/fetch?user_email=$_userEmail&user_token=$_userToken&feeding_plan[id]=$item';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;
    //
    var response = await http.get(_fullUrl);
    if (response.statusCode == 200) {
      String res = response.body;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      var resDailyPercentages = resJson["daily_allowance_actual_percentage"];
      print(resDailyPercentages.toString());
      print(resDailyPercentages['Muscle Meat'].toString());
      if (resDailyPercentages['Muscle Meat'] == null) {
        _muscleMeatVal = 0;
        _muscleMeatClr = 'Green';
      } else {
        _muscleMeatVal = resDailyPercentages['Muscle Meat'][0];
        _muscleMeatClr = resDailyPercentages['Muscle Meat'][1];
      }
      if (resDailyPercentages['Bone'] == null) {
        _boneVal = 0;
        _boneClr = 'Green';
      } else {
        _boneVal = resDailyPercentages['Bone'][0];
        _boneClr = resDailyPercentages['Bone'][1];
      }
      if (resDailyPercentages['Organ Meat'] == null) {
        _organMeatVal = 0;
        _organMeatClr = 'Green';
      } else {
        _organMeatVal = resDailyPercentages['Organ Meat'][0];
        _organMeatClr = resDailyPercentages['Organ Meat'][1];
      }
      if (resDailyPercentages['Fruit and Veg'] == null) {
        _fruitNVegVal = 0;
        _fruitNVegClr = 'Green';
      } else {
        _fruitNVegVal = resDailyPercentages['Fruit and Veg'][0];
        _fruitNVegClr = resDailyPercentages['Fruit and Veg'][1];
      }

      MPD.MealPlanFetchModel _mealPlan =
      MPD.MealPlanFetchModel.fromJson(resJson);
      // var _mealPlan = resJson["nutrient_value"];

      print(resJson["nutrient_value"][0]["Calcium"][0]); //[0].calcium[0]);
      // print(_mealPlan["Choline"][0]); //.nutrientValue[1].choline[0]);
      // print(_mealPlan["Choline"][2]); //.nutrientValue[1].choline[0]);
      //
      // _muscleMeatVal = _mealPlan.dailyAllowanceActualPercentage.muscleMeat[0];
      // _muscleMeatClr = _mealPlan.dailyAllowanceActualPercentage.muscleMeat[1];
      // _organMeatVal = _mealPlan.dailyAllowanceActualPercentage.organMeat[0];
      // _organMeatClr = _mealPlan.dailyAllowanceActualPercentage.organMeat[1];
      // _boneVal = _mealPlan.dailyAllowanceActualPercentage.bone[0];
      // _boneClr = _mealPlan.dailyAllowanceActualPercentage.bone[1];
      // _fruitNVegVal = _mealPlan.dailyAllowanceActualPercentage.fruitAndVeg[0];
      // _fruitNVegClr = _mealPlan.dailyAllowanceActualPercentage.fruitAndVeg[1];
      //
      valCalcium = _mealPlan.nutrientValue[0].calcium[0];
      calciumClr = _mealPlan.nutrientValue[0].calcium[2];
      valCholine = _mealPlan.nutrientValue[1].choline[0];
      cholineClr = _mealPlan.nutrientValue[1].choline[2];
      valCopper = _mealPlan.nutrientValue[2].copper[0];
      copperClr = _mealPlan.nutrientValue[2].copper[2];
      valCrudeFat = _mealPlan.nutrientValue[3].crudeFat[0];
      fatClr = _mealPlan.nutrientValue[3].crudeFat[2];
      valFolate = _mealPlan.nutrientValue[4].folate[0];
      folateClr = _mealPlan.nutrientValue[4].folate[2];
      valIodine = _mealPlan.nutrientValue[5].iodine[0];
      iodineClr = _mealPlan.nutrientValue[5].iodine[2];
      valIron = _mealPlan.nutrientValue[6].iron[0];
      ironClr = _mealPlan.nutrientValue[6].iron[2];
      valMagnesium = _mealPlan.nutrientValue[7].magnesium[0];
      magClr = _mealPlan.nutrientValue[7].magnesium[2];
      valManganese = _mealPlan.nutrientValue[8].manganese[0];
      mangClr = _mealPlan.nutrientValue[8].manganese[2];
      valNiacin = _mealPlan.nutrientValue[9].niacinB3[0];
      niacinClr = _mealPlan.nutrientValue[9].niacinB3[2];
      valOmega3exclALAandSDA =
      _mealPlan.nutrientValue[10].omega3ExclAlaAndSda[0];
      omega3Clr = _mealPlan.nutrientValue[10].omega3ExclAlaAndSda[2];
      valOmega6 = _mealPlan.nutrientValue[11].omega6[0];
      omega6Clr = _mealPlan.nutrientValue[11].omega6[2];
      valPantothenic = _mealPlan.nutrientValue[12].pantothenicAcidB5[0];
      pantoClr = _mealPlan.nutrientValue[12].pantothenicAcidB5[2];
      valPhosphorus = _mealPlan.nutrientValue[13].phosphorus[0];
      phosClr = _mealPlan.nutrientValue[13].phosphorus[2];
      valPotassium = _mealPlan.nutrientValue[14].potassium[0];
      potClr = _mealPlan.nutrientValue[14].potassium[2];
      valProtein = _mealPlan.nutrientValue[15].protein[0];
      proteinClr = _mealPlan.nutrientValue[15].protein[2];
      valRiboflavinB2 = _mealPlan.nutrientValue[16].riboflavinB2[0];
      ribofClr = _mealPlan.nutrientValue[16].riboflavinB2[2];
      valSelenium = _mealPlan.nutrientValue[17].selenium[0];
      seleClr = _mealPlan.nutrientValue[17].selenium[2];
      valSodium = _mealPlan.nutrientValue[18].sodiumNa[0];
      sodClr = _mealPlan.nutrientValue[18].sodiumNa[2];
      valThiaminB1 = _mealPlan.nutrientValue[19].thiaminB1[0];
      thiamClr = _mealPlan.nutrientValue[19].thiaminB1[2];
      valVitaminA = _mealPlan.nutrientValue[20].vitaminA[0];
      vAClr = _mealPlan.nutrientValue[20].vitaminA[2];
      valVitaminC = _mealPlan.nutrientValue[21].vitaminC[0];
      vCClr = _mealPlan.nutrientValue[21].vitaminC[2];
      valVitaminD = _mealPlan.nutrientValue[22].vitaminD[0];
      vDClr = _mealPlan.nutrientValue[22].vitaminD[2];
      valVitaminE = _mealPlan.nutrientValue[23].vitaminE[0];
      vEClr = _mealPlan.nutrientValue[23].vitaminE[2];
      valZinc = _mealPlan.nutrientValue[24].zincZn[0];
      zincClr = _mealPlan.nutrientValue[24].zincZn[2];
      //
      dailyCalVal = _mealPlan.nutrientValue[25].calories[0];
      dailyCalClr = _mealPlan.nutrientValue[25].calories[2];
      //
      valCalciumPhosphorusRatio =
          _mealPlan.feedingPlanDetails[0].food.calciumPhosphorousRatio;
      calPhosRClr =
          _mealPlan.feedingPlanDetails[0].food.calciumPhosphorousRatioColor;
      valOmega3_6Ratio = _mealPlan.feedingPlanDetails[0].food.omegaRatio;
      omegaRClr = _mealPlan.feedingPlanDetails[0].food.omegaRatioColor;

      foodPlanDetails = _mealPlan.feedingPlanDetails;

      setState(() {
        //
        dataMap.update(
            "Muscle Meat",
                (value) =>
            _muscleMeatVal); //.toString() != ''|| null ? _muscleMeatVal : 0);
        print("Muscle Meat " + _muscleMeatVal.toString());
        dataMap.update(
            "Organ Meat",
                (value) =>
            _organMeatVal); //.toString() != '' || null ? _organMeatVal : 0);
        dataMap.update(
            "Fruit & Veg",
                (value) =>
            _fruitNVegVal); //.toString() != '' || null ? _fruitNVegVal : 0);
        dataMap.update("Bone",
                (value) => _boneVal); //.toString() != '' || null ? _boneVal : 0);
        //
        colorList = [
          changeClr(_muscleMeatClr),
          changeClr(_organMeatClr),
          changeClr(_fruitNVegClr),
          changeClr(_boneClr),
          //_muscleMeatClr != '' ? changeClr(_muscleMeatClr) : Colors.green,
          // _organMeatClr != '' ? changeClr(_organMeatClr) : Colors.green,
          // _boneClr != '' ? changeClr(_boneClr) : Colors.green,
          // _fruitNVegClr != '' ? changeClr(_fruitNVegClr) : Colors.green,
        ];
      });
      setState(() {
        _isLoading = false;
        _petName = _mealPlan.petName;
        _isData = true;
        // _petAge = _mealPlan;
      });
      // await pr.hide();
      // setState(() {
      //   // _showMealChips = false;
      //   _isData = true;
      // });
    } else {
      // If that call was no successful (response was unexpected), it throw an error.
      _showSnackbar('A Network Error Occurred.!', errorNet);
      throw Exception('Failed to load data');
    }
  }
  //
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
        setState(() {
          _isData = false;
        });
        //
        // pr.hide().whenComplete(() async{
          //todo update the details page
        pr.hide();
          await getDailyGuideModel();
          await _fetchMealPlanDetails(mealPlanID);
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => MealPlanDetailsScreen(
          //       mealPlanID: mealPlanID,
          //       allCatList: _allCatList,
          //     )));
        // });
        setState(() {
          _isLoading = false;
        });
        //
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
  //
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
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Suggestions',
                        style: kTitleStyleBlackMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    child: ListView(
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
                                    width: MediaQuery.of(context).size.width,
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
                      ).toList(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0,),
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
                                Navigator.of(context).pop();},
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
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            flex: 1,child: new FlatButton(
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
                              onPressed: () {},
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
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    //
    _mealPlanBtmSheet() {
      //_mealPlan
      unit = !isImperial ? 'gm':'ounce';
      int total = 0;
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
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Meal Plan for $_petName', //$_petName
                      style: kTitleStyleBlackLight,
                    ),
                    Text(
                      'Remember to Include Additional Daily Foods',
                      style: kMainHeadingStyleBlack,
                    ),
                    SizedBox(height: 8.0),
                    Container(
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
                              },
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
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
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
                            style: kSubContentStyleBlack,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Container(
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
                              },
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
                          'Weight of One Meal: ' +unit,
                          style: kSubContentStyleBlack,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                        itemCount:  _allUserInputs.length,
                        itemBuilder: (BuildContext context, int index) {
                          _mealPlanQtyController
                              .add(new TextEditingController());
                          //
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width:
                                          MediaQuery.of(context).size.width /
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
                                            // value: _selectedValCategory,
                                            isDense: false,
                                            isExpanded: true,
                                            hint: Text(
                                              _selectedCat[index] != null
                                                  ? _selectedCat[index]
                                                  : 'Category',
                                              style: kSubContentStyleWhitSmaller,
                                            ),
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged: (String newVal){
                                              // _selectedValCategory = newVal;
                                              setState(() {
                                                _selectedFood[index] = null;
                                                _selectedCat[index] = newVal;
                                                _foodsList.clear();
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
                                              });
                                            },
                                            items: _categoryList.map((cat) { //_allCatList
                                              return new DropdownMenuItem<String>(
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
                                          width: MediaQuery.of(context).size.width / 3,
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
                                            // value: _selectedValFood,
                                            isDense: false,
                                            isExpanded: true,
                                            hint: Text(
                                              _selectedFood[index] != null
                                                  ? _selectedFood[index]
                                                  : 'FoodType',
                                              style: kSubContentStyleWhitSmaller,
                                            ),
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged:(String newVal){
                                              setState(() {
                                                _selectedFood[index] = newVal;
                                                _selectedValFood =
                                                _selectedFood[index];
                                                //
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
                                              });
                                            },
                                            items: _foodsList.map((fdt) { //foodTypeList
                                              return new DropdownMenuItem<String>(
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
                                          width:
                                          MediaQuery.of(context).size.width /
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
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(
                                                  3),
                                            ],
                                            onChanged: (String val) {
                                              // int temp;
                                              setState(() {
                                                _mealPlanQtyController[index]
                                                    .text = val;
                                                _allUserInputs[index].quantity = val;
                                                // temp = int.parse(_mealPlanQtyController[index]
                                                //     .text.toString());
                                                // total = total + temp;
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            validator: validateNumberDecimal,
                                            onSaved: (String value) {
                                              _mealPlanQtyController[index]
                                                  .text = value;
                                              _allUserInputs[index].quantity =
                                                  _mealPlanQtyController[index].text;
                                            },
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
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4.0),
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
                              ),
                            ),
                            SizedBox(width: 12.0),
                            Expanded(
                              flex: 1,
                              child: new FlatButton(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  // _showMealChips = false;
                                  if(_mealPlanNumberController.text.isEmpty && _mealPlanNumber2Controller.text.isEmpty){
                                    _showSnackbar('"Meal plans per day" and "This plan is for" fields Must Not be Empty!', errorAPI);
                                  }else {
                                    Navigator.of(context).pop();
                                  }
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
                              ),
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
    void updateListView() {
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((database) {
        Future<List<MealPlan>> mealPlanListFuture = databaseHelper.getTodoList();
        mealPlanListFuture.then((mealPlanList) {
          setState(() {
            this.mealPlanList = mealPlanList;
            this.count = mealPlanList.length;
          });
        });
      });
    }
    //

    if (mealPlanList == null) {
      mealPlanList = List<MealPlan>();
      updateListView();
    }
    //
    final petHeader = Container(
      // alignment: Alignment.centerLeft,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      height: 60.0,
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
                    // radius: 26.0,
                    backgroundColor: Colors.grey[300],
                    child: _petImageView == ''
                        ? Img.Image(
                      image: AssetImage(
                        'assets/images/logo_small.png',
                      ),
                      height: 40.0,
                      width: 40.0,
                    )
                        :
                    // Container(
                    //   width: 60.0,
                    //   height: 60.0,
                    //   decoration: new BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: new DecorationImage(
                    //       fit: BoxFit.cover,
                    //       image:
                    Img.Image(
                      image: NetworkImage(
                        _petImageView,
                        scale: 1.0,
                      ),

                      //     ),
                      //   ),
                    ),
                    // Image(
                    //   image: AssetImage(
                    //     'assets/images/logo_small.png',
                    //   ),
                    //   // height: 40.0,
                    //   // width: 40.0,
                    // ),
                  ),
//        CircleAvatar(
//          radius: 80.0,
//          backgroundColor: Colors.transparent,
//          backgroundImage: AssetImage('assets/images/onboarding_logo_small.png'),
//        ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            // child: Container(
            //   width: MediaQuery.of(context).size.width,
            //   height: MediaQuery.of(context).size.height,
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
                        fit:BoxFit.fitHeight,
                        child: Text(
                          _petName,// _petID == '0' ? 'Name' : _petName,
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
                horizontal: 8.0,vertical: 4.0,
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: const Text(
                  'Meal Plan',
                  style: TextStyle(
                      // fontSize: 32.0,
                      fontFamily: 'poppins',
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
    final calorieBalance = Container(
      // margin: EdgeInsets.only(top: 30.0, left: 4.0, right: 4.0),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            // margin: EdgeInsets.symmetric(horizontal: 4.0),
            width: MediaQuery.of(context).size.width,
            child: LinearPercentIndicator(
              fillColor: Colors.transparent,
              backgroundColor: Colors.blueGrey[100],
              //Color(0xFF058EC9),
              animation: true,
              animationDuration: 1000,
              lineHeight: 30.0,
              percent: 2 / 3,
              //todo calorie balance calculations
              //replace the main percentage value here with the calculated value from the API
              linearStrokeCap: LinearStrokeCap.butt,
              progressColor: Color(0xFF03B898),
            ),
          ),
          SizedBox(height: 12.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total(kCal) : ',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400),
                ),
                // Spacer(),
                Text(
                  dailyCalVal == 0.0 ? '00': dailyCalVal.toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Balanced',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 1000),
      chartLegendSpacing: _chartLegendSpacing,
      chartRadius: MediaQuery.of(context).size.width / 2,
      // / 3.2 > 400
      // ? 400
      // : MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 180,
      chartType: _chartType,
      centerText: _showCenterText ? "" : null,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition,
        showLegends: _showLegends,
        legendShape: _legendShape == LegendShape.Circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'poppins',
          color: Colors.black87,
          fontSize: 16.0,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        chartValueBackgroundColor: Colors.grey[200],
        chartValueStyle: TextStyle(
          fontSize: 12.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: 'poppins',
        ),
        showChartValueBackground: _showChartValueBackground,
        showChartValues: _showChartValues,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth,
    );

    final pieChart = LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth >= 600) {
          return chart;
        } else {
          return
            // SingleChildScrollView(
            //   // child: //chart,
            //
            //   //   flex: 3,
            //     child:
            Container(
              margin: EdgeInsets.only(top: 8.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        calorieBalance,
                        Positioned(
                          left: MediaQuery.of(context).size.width * 0.50,
                          top: 5.0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: 5.0,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 8.0),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(
                  //       left: 12.0,
                  //       top: 12.0,
                  //     ),
                  //     child: const Text(
                  //       'Food Weight',
                  //       style: TextStyle(
                  //           fontSize: 20.0,
                  //           color: Colors.black87,
                  //           fontWeight: FontWeight.w500),
                  //       textAlign: TextAlign.end,
                  //     ),
                  //   ),
                  // ),end
                  // SizedBox(height: 8.0),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: chart,
                    ),
                  ),
                ],
              ),
              // ),
              // ),
              // margin: EdgeInsets.symmetric(
              //   vertical: 32,
              // ),
            );
        }
      },
    );
    //
    final macroFoodChart = Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // height: 200.0,
      // child: Container(
      //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChartLineMeals(
              title: 'Protein ',
              number: double.parse(valProtein),
              rate: roundDouble(double.parse(valProtein) / (baseProtein * 2), 1),
              color: proteinClr != '' ? changeClr(proteinClr) : Colors.green),
          ChartLineMeals(
              title: 'Crude Fat ',
              number: double.parse(valCrudeFat),
              rate: roundDouble(double.parse(valCrudeFat) / (baseCrudeFat * 2), 1),
              color: fatClr != '' ? changeClr(fatClr) : Colors.green),
          // ChartLineMeals(
          //     title: 'Fat', number: 1800, rate: 1, color: Color(0xFF03B898)),
          // ChartLineMeals(
          //     title: 'Protein', number: 600, rate: 0.3, color: Colors.amber),
          // ChartLineMeals(
          //     title: 'Carb', number: 1200, rate: 0.6, color: Color(0xFF03B898)),
          // ChartLineMeals(
          //     title: 'Fibre', number: 800, rate: 0.4, color: Color(0xFF03B898)),
          // ChartLineMeals(
          //     title: 'Sugar', number: 500, rate: 0.2, color: Color(0xFF03B898)),
        ],
      ),
      // ),
    );
    //
    final microFoodChart = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      // margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChartLineSmall(
              title: 'Omega-6 ',
              number: double.parse(valOmega6),
              rate: roundDouble(double.parse(valOmega6) / (baseOmega6 * 2), 1),
              color: omega6Clr != '' ? changeClr(omega6Clr) : Colors.green),
          ChartLineSmall(
              title: 'Omega-3 excl. ALA and SDA ',
              number: double.parse(valOmega3exclALAandSDA),
              rate: roundDouble(
                  double.parse(valOmega3exclALAandSDA) /
                      (baseOmega3exclALAandSDA * 2),
                  1),
              color: omega3Clr != '' ? changeClr(omega3Clr) : Colors.green),
          ChartLineSmall(
              title: 'Calcium ',
              number: double.parse(valCalcium),
              rate:
              roundDouble(double.parse(valCalcium) / (baseCalcium * 2), 1),
              color: calciumClr != '' ? changeClr(calciumClr) : Colors.green),
          ChartLineSmall(
              title: 'Phosphorus ',
              number: double.parse(valPhosphorus),
              rate: roundDouble(
                  double.parse(valPhosphorus) / (basePhosphorus * 2), 1),
              color: phosClr != '' ? changeClr(phosClr) : Colors.green),
          ChartLineSmall(
              title: 'Potassium ',
              number: double.parse(valPotassium),
              rate: roundDouble(
                  double.parse(valPotassium) / (basePotassium * 2), 1),
              color: potClr != '' ? changeClr(potClr) : Colors.green),
          ChartLineSmall(
              title: 'Sodium (Na) ',
              number: double.parse(valSodium),
              rate: roundDouble(double.parse(valSodium) / (baseSodium * 2), 1),
              color: sodClr != '' ? changeClr(sodClr) : Colors.green),
          ChartLineSmall(
              title: 'Magnesium ',
              number: double.parse(valMagnesium),
              rate: roundDouble(
                  double.parse(valMagnesium) / (baseMagnesium * 2), 1),
              color: magClr != '' ? changeClr(magClr) : Colors.green),
          ChartLineSmall(
              title: 'Iron ',
              number: double.parse(valIron),
              rate: roundDouble(double.parse(valIron) / (baseIron * 2), 1),
              color: ironClr != '' ? changeClr(ironClr) : Colors.green),
          ChartLineSmall(
              title: 'Copper ',
              number: double.parse(valCopper),
              rate: roundDouble(double.parse(valCopper) / (baseCopper * 2), 1),
              color: copperClr != '' ? changeClr(copperClr) : Colors.green),
          ChartLineSmall(
              title: 'Manganese ',
              number: double.parse(valManganese),
              rate: roundDouble(
                  double.parse(valManganese) / (baseManganese * 2), 1),
              color: mangClr != '' ? changeClr(mangClr) : Colors.green),
          ChartLineSmall(
              title: 'Zinc (Zn) ',
              number: double.parse(valZinc),
              rate: roundDouble(double.parse(valZinc) / (baseZinc * 2), 1),
              color: zincClr != '' ? changeClr(zincClr) : Colors.green),
          ChartLineSmall(
              title: 'Iodine ',
              number: double.parse(valIodine),
              rate: roundDouble(double.parse(valIodine) / (baseIodine * 2), 1),
              color: iodineClr != '' ? changeClr(iodineClr) : Colors.green),
          ChartLineSmall(
              title: 'Selenium ',
              number: double.parse(valSelenium),
              rate: roundDouble(
                  double.parse(valSelenium) / (baseSelenium * 2), 1),
              color: seleClr != '' ? changeClr(seleClr) : Colors.green),
          ChartLineSmall(
              title: 'Vitamin A ',
              number: double.parse(valVitaminA),
              rate: roundDouble(
                  double.parse(valVitaminA) / (baseVitaminA * 2), 1),
              color: vAClr != '' ? changeClr(vAClr) : Colors.green),
          ChartLineSmall(
              title: 'Vitamin D ',
              number: double.parse(valVitaminD),
              rate: roundDouble(
                  double.parse(valVitaminD) / (baseVitaminD * 2), 1),
              color: vDClr != '' ? changeClr(vDClr) : Colors.green),
          ChartLineSmall(
              title: 'Vitamin E ',
              number: double.parse(valVitaminE),
              rate: roundDouble(
                  double.parse(valVitaminE) / (baseVitaminE * 2), 1),
              color: vEClr != '' ? changeClr(vEClr) : Colors.green),
          ChartLineSmall(
              title: 'Thiamin (B1) ',
              number: double.parse(valThiaminB1),
              rate: roundDouble(
                  double.parse(valThiaminB1) / (baseThiaminB1 * 2), 1),
              color: thiamClr != '' ? changeClr(thiamClr) : Colors.green),
          ChartLineSmall(
              title: 'Riboflavin (B2) ',
              number:double.parse( valRiboflavinB2),
              rate: roundDouble(
                  double.parse(valRiboflavinB2) / (baseRiboflavinB2 * 2), 1),
              color: ribofClr != '' ? changeClr(ribofClr) : Colors.green),
          ChartLineSmall(
              title: 'Niacin (B3) ',
              number: double.parse(valNiacin),
              rate: roundDouble(double.parse(valNiacin )/ (baseNiacin * 2), 1),
              color: niacinClr != '' ? changeClr(niacinClr) : Colors.green),
          ChartLineSmall(
              title: 'Pantothenic acid (B5) ',
              number: double.parse(valPantothenic),
              rate: roundDouble(
                  double.parse(valPantothenic) / (basePantothenic * 2), 1),
              color: pantoClr != '' ? changeClr(pantoClr) : Colors.green),
          ChartLineSmall(
              title: 'Folate ',
              number: double.parse(valFolate),
              rate: roundDouble(double.parse(valFolate) / (baseFolate * 2), 1),
              color: folateClr != '' ? changeClr(folateClr) : Colors.green),
          ChartLineSmall(
              title: 'Choline ',
              number: double.parse(valCholine),
              rate:
              roundDouble(double.parse(valCholine) / (baseCholine * 2), 1),
              color: cholineClr != '' ? changeClr(cholineClr) : Colors.green),
        ],
      ),
    );

    final macroRatioChart = Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChartLineMeals(
              title: 'Calcium/Phosphorus ratio ',
              number: valCalciumPhosphorusRatio,
              rate: roundDouble(
                  valCalciumPhosphorusRatio / (baseCalciumPhosphorusRatio * 2),
                  1),
              color: calPhosRClr != '' ? changeClr(calPhosRClr) : Colors.green),
          ChartLineMeals(
              title: 'Omega-3/6 ratio ',
              number: valOmega3_6Ratio,
              rate: roundDouble(valOmega3_6Ratio / (baseOmega3_6Ratio * 2), 1),
              color: omegaRClr != '' ? changeClr(omegaRClr) : Colors.green),
          //Color(0xFF03B898)),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
          //   child:
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       //   crossAxisAlignment: CrossAxisAlignment.start,
          //       //   children: [
          //       Text(
          //     'Calcium : Phosphorous Ratios = 2:1',
          //     style: TextStyle(
          //         fontSize: 16.0,
          //         color: Colors.black87,
          //         fontWeight: FontWeight.w400),
          //   ),
          //   // Spacer(),
          //   //   Text(
          //   //     '2 : 1',
          //   //     style: TextStyle(
          //   //         fontSize: 16.0,
          //   //         color: Colors.black87,
          //   //         fontWeight: FontWeight.w500),
          //   //   ),
          //   // ],
          //   // ),
          // ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   // margin: EdgeInsets.symmetric(horizontal: 4.0),
          //   width: MediaQuery.of(context).size.width,
          //   child: LinearPercentIndicator(
          //     fillColor: Colors.transparent,
          //     backgroundColor: Color(0xFF01816B),
          //     animation: true,
          //     animationDuration: 1000,
          //     lineHeight: 16.0,
          //     percent: 2 / 3,
          //     //replace the main percentage value here with the calculated value from the API
          //     linearStrokeCap: LinearStrokeCap.butt,
          //     progressColor: Color(0xFF03B898),
          //   ),
          // ),
          // SizedBox(height: 4.0),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
          //   child:
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       //   crossAxisAlignment: CrossAxisAlignment.start,
          //       //   children: [
          //       Text(
          //     'Omega3 : Omega6 Ratios = 1:4',
          //     style: TextStyle(
          //         fontSize: 16.0,
          //         color: Colors.black87,
          //         fontWeight: FontWeight.w400),
          //   ),
          //   //     Spacer(),
          //   //     Text(
          //   //       '1 : 4',
          //   //       style: TextStyle(
          //   //           fontSize: 16.0,
          //   //           color: Colors.black87,
          //   //           fontWeight: FontWeight.w500),
          //   //     ),
          //   //   ],
          //   // ),
          // ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   // margin: EdgeInsets.symmetric(horizontal: 4.0),
          //   width: MediaQuery.of(context).size.width,
          //   child: LinearPercentIndicator(
          //     fillColor: Colors.transparent,
          //     backgroundColor: Color(0xFF01816B),
          //     animation: true,
          //     animationDuration: 1000,
          //     lineHeight: 16.0,
          //     percent: 1 / 5,
          //     //replace the main percentage value here with the calculated value from the API
          //     linearStrokeCap: LinearStrokeCap.butt,
          //     progressColor: Color(0xFF03B898),
          //   ),
          // ),
        ],
      ),
    );
    //
    final macroCharts =
    // Container(
    //   // height: 300.0, //MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     child:
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4.0),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(
                      4.0,
                    ),
                    // child: Padding(
                    //   padding: const EdgeInsets.only(
                    //     // left: 12.0,
                    //     top: 0.0,
                    //   ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nutrient',
                          //change the weight unit value depending on users choice of weight unit value
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                        const Text(
                          'RDI',
                          //change the weight unit value depending on users choice of weight unit value
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
                // ),
                Expanded(
                  flex: 3,
                  child: macroFoodChart,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    // child: Padding(
                    padding: const EdgeInsets.only(
                      // left: 12.0,
                      top: 4.0,
                    ),
                    child: const Text(
                      'Ratios',
                      // update this unit according to the user's selection of unit
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                // ),
                // ),
                Expanded(
                  flex: 3,
                  child: macroRatioChart,
                ),
              ],
            ),
          ),
        ),
      ],
      //   ),
      // ),
    );

    final microCharts = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            alignment: Alignment.centerLeft,
            // margin: const EdgeInsets.all(
            //   4.0,
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nutrient',
                  //change the weight unit value depending on users choice of weight unit value
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  'RDI',
                  //change the weight unit value depending on users choice of weight unit value
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            // ),
          ),
        ),
        Expanded(
          flex: 9,
          child:
          // _isData ?
          Container(
            // margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Stack(
              children: [
                microFoodChart,
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.75,
                  top: 1.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: 5.0,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          //       : new Center(
          //   widthFactor: 100.0,
          //   heightFactor: 100.0,
          //   child: CircularProgressIndicator(),
          // ),
        ),
      ],
    );
    //
    Widget swapTile() {
      return new Center(
        child: isSelected[1]
            ? macroCharts
            : isSelected[2]
            ? microCharts
            : pieChart, //(_swapNutrients == 1) ? macroCharts : (_swapNutrients == 2) ? microCharts : pieChart,
        // (foo==1)?something1():(foo==2)? something2():(foo==3)? something3(): something4();
      );
    }
    //
    final nutrientButton = Container(
      width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.only(top: 2.0, bottom: 4.0),
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
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height,
        fontSize: 16.0,
        initialLabelIndex: isSelected[1] ? 1 : isSelected[2] ? 2 : 0,
        activeBgColor: Color(0xFF03B898),
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey[300],
        inactiveFgColor: Colors.black54,
        labels: ['Calories', '   Macro\nNutrients', '   Micro\nNutrients'],
        onToggle: (index) {
          print('switched to: $index');
          print('switched to: $isSelected');
          setState(() {
            //isSelected[index] = !isSelected[index];//index;//!_swapNutrients;
            for (int indexBtn = 0; indexBtn < isSelected.length; indexBtn++) {
              if (indexBtn == index) {
                isSelected[indexBtn] = true;
              } else {
                isSelected[indexBtn] = false;
              }
            }
          });
        },
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
    final mealPlanListViewTitles = Row(
      children: [
        Expanded(
          flex: 2,
          // child: FittedBox(
          //   fit: BoxFit.fitWidth,
            child: Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          // ),
        ),
        Expanded(
          flex: 4,
          // child: FittedBox(
          //   fit: BoxFit.fitWidth,
            child: Text(
              'Food Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          // ),
        ),
        Expanded(
          flex: 2,
          // child: FittedBox(
          //   fit: BoxFit.fitWidth,
            child: Text(
              'Quantity',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          // ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '',
          ),
        ),
      ],
    );
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
                        ? '${item.quantity}gm'
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
    Widget body() {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          // child: Container(
                          //   alignment: Alignment.center,
                          //   width: MediaQuery.of(context).size.width,
                          //   color: Colors.transparent,
                          // child: Card(
                          //   child: Padding(
                          //     padding: EdgeInsets.only(top: 2.0),
                          child: nutrientButton,
                          // ),
                          // ),
                          // ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: EdgeInsets.only(top: 4.0),
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.transparent,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            // child: Card(
                            child: _isData
                                ? swapTile()
                                : new Center(
                              widthFactor: 120.0,
                              heightFactor: 120.0,
                              child: CircularProgressIndicator(),
                            ), //getCustomContainer(), //,//
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ),
                ),
                // ),
                // ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: 30.0,
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          color: Colors.grey[400],
                          // height: 32.0,
                          child: mealPlanListViewTitles,
                        ),
                        // mealPlanList.length != 0
                        //     ?
                        Flexible(
                          child: _isData
                              ? (foodPlanDetails.length != 0
                              ? //Text('test list')
                          AnimatedList(
                            key: _listKey,
                            initialItemCount: foodPlanDetails.length,
                            itemBuilder: (
                                context,
                                index,
                                animation,
                                ) {
                              return _buildItem(
                                  foodPlanDetails[index],
                                  animation,
                                  index);
                            },
                          )
                              : new Center(
                            widthFactor: 100.0,
                            heightFactor: 100.0,
                            child: Text('Add a Meal Plan'),
                          ))
                              : new Center(
                            widthFactor: 100.0,
                            heightFactor: 100.0,
                            child: CircularProgressIndicator(),
                          ),
                          // getMealPlanListView(),
                        ),
                        //     : Container(
                        //   alignment: Alignment.center,
                        //   width: 200.0,
                        //   height: 100.0,
                        //   child: Text('Add a Meal Plan'),
                        // ),
                      ],
                    ),
                    //
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    //
    final mealButtons = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: FlatButton(
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
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
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
                _mealPlanBtmSheet();
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
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
          ),
        ],
      ),
    );
    //
    final mainBody = Container(
      // margin: EdgeInsets.only(
      //   top: 16.0,
      // ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // padding: EdgeInsets.only(
      //   top: 12.0,
      // ),
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

          Expanded(
            flex: 1,
            child: mealButtons,
          ),

          Expanded(
            flex: 11,
            // child: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: body(),
          ),
          // lorem,
        ],
      ),
    );
    //
    return Scaffold(
      appBar: PreferredSize(
preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          title: petHeader,//Text(''),
          // leading: petHeader,
          backgroundColor: Colors.white,
        ),
      ),
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: mainBody,
    );
  }

}


class UserInputs{
  String foodId;
  String quantity;
  //
  UserInputs({this.foodId = '', this.quantity = ''});
}
// import 'dart:html';

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:pawfect/models/meal_plan_detail_model/category_model.dart'
    as CATM;
import 'package:pawfect/models/meal_plan_model/all_meal_plan.dart';
import 'package:pawfect/models/meal_plan_model/meal_plan_fetch.dart' as MPD;
import 'package:pawfect/models/pets/pet_fetch_model.dart' as PET;
import 'package:pawfect/models/daily_guide_model/daily_guide_model.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/meal_plan.dart';
import 'package:pawfect/screens/daily_guide/chartline_ratio.dart';
import 'package:pawfect/screens/meal_plan/chartline_meals.dart';
import 'package:pawfect/screens/meal_plan/chartline_small.dart';
import 'package:pawfect/screens/meal_plan/meal_plan_modify.dart';
import 'package:pawfect/utils/local/database_helper.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';

enum widgetMarker { macro, micro }
enum LegendShape { Circle, Rectangle }

class MealPlanScreen extends StatefulWidget {
  MealPlanScreen({Key key}) : super(key: key);

  static String tag = 'meal-plan-page';

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {

  var myVariable = 0;

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

  bool _isShowingDialog = false;
  int _swapNutrients = 0;
  List<bool> isSelected = [false, false, false];
  widgetMarker selectedWidget = widgetMarker.macro;
  int selectedSwitchIndex;

  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<MealPlan> mealPlanList = [
    new MealPlan('cat1', 'food type1', '200'),
    new MealPlan('cat2', 'food type2', '300'),
    new MealPlan('cat3', 'food type3', '400'),
    new MealPlan('cat4', 'food type4', '500'),
  ];
  int count = 0;
  MealPlan _mealPlan;
  TextEditingController _mealPlanNumberController = TextEditingController();
  TextEditingController _mealPlanNumber2Controller = TextEditingController();
  TextEditingController _mealPlanQtyController = TextEditingController();
  bool isSwitchedMealPlans = false;
  bool _swapInsideBTMS = true;

  final List<String> _suggestions = [
    "Suggestion 1",
    "Suggestion 2",
    "Suggestion 3",
    "Suggestion 4",
    "Suggestion 5",
  ];

  bool isFirst = false;
  SharedPreferences petPrefs;
  String petName = '';
  String petAge = '';

//
  String _userEmail;
  String _userToken;
  String _petID = '';
  String _petName = 'Name';
  String _petAge = '';
  String petNameApi = '';
  String petAgeApi = '';
  String petIDApi = '';
  bool _isData = false;
  String jsonString = '';
  bool _userSubscribed = false;
  bool onMealPlan = false;

  String _petImage = '';
  String _petImageView = '';

  //
  //
  double _muscleMeatVal = 0.0;
  String _muscleMeatClr = '';
  double _organMeatVal = 0.0;
  String _organMeatClr = '';
  double _fruitNVegVal = 0.0;
  String _fruitNVegClr = '';
  double _boneVal = 0.0;
  String _boneClr = '';

  String dailyCalVal = '';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _defaultChoiceIndex = 0;
  bool _isSelected = false;

//
  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

  //
  String _mealPlanApiUrl = '';
  String _mealCatApiUrl = '';
  bool _showMealChips;

  //
  String foodPlanId = '';
  String foodPlanQty = '';
  String foodID = '';
  String foodType = '';

  ProgressDialog pr;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint('current: MealPlanScreen: initState() called!');
    // swapBodies();
    _showMealChips = true;
    _updateChips();
    // _fetchData();
    loadLocalData().then(
        (value) => getDailyGuideModel());
            // .then(
            //     (value) => _fetchCategoryData()));
    // _fetchCategoryData();
  }

  void _updateChips(){
      _showMealChips = true;
    setState(() {
    });
  }
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // loadLocalData().then((value) =>
  //   //     getDailyGuideModel());
  //   super.dispose();
  // }

  swapBodies() async {
    petPrefs = await SharedPreferences.getInstance();
    _showMealChips = petPrefs.getBool('show_chips');
    if (_showMealChips != null && !_showMealChips) {
      petPrefs.setBool('show_chips', true);
      _showMealChips = true;
      // return Future<bool>.value(false);
    } else {
      petPrefs.setBool('show_chips', true);
      _showMealChips = true;
      // return Future<bool>.value(true);
    }
  }

  List<AllMealPlanModel> _allMealPlanList = new List<AllMealPlanModel>();
  List<CATM.CategoryModel> _allCatList = new List<CATM.CategoryModel>();

  List<CATM.CategoryModel> _selectedCategoryVal = List<CATM.CategoryModel>();
  List<CATM.Food> _selectedFoodVal = List<CATM.Food>();

  List<CATM.CategoryModel> _selectedCategoryList =
      new List<CATM.CategoryModel>();
  CATM.Food _selectedFoodType;
  String catName = '';
  String catID = '';
  String foodTypeID = '';
  String foodTypeName = '';

  // CategoryModel _selectedFoodType;
  List<CATM.Food> foodTypeList = []; //new List<CATM.Food>();
  bool isCatSelected = false;
  bool disableDP1 = false;
  bool disableDP2 = true;
  List<MPD.FeedingPlanDetail> foodPlanDetails;

  //
  //drop down variables
  List<String> _categoryList = new List<String>(); //= List();
  List<String> _foodsList = new List<String>(); //= List();
  List tempList = List();
  CATM.CategoryModel _category; //state
  CATM.Food _foodType; //province
  //
  String _selectedValCategory = 'cat';
  String _selectedValFood = 'food';

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // focusNodeButtonMacro.dispose();
  //   // focusNodeButtonMicro.dispose();
  //   super.dispose();
  // }

  void changeTheCharts(int i) {
    switch (i) {
      case 0:
        {
          // setState(() {
          selectedWidget = widgetMarker.macro;
          // });
          break;
        }
      case 1:
        {
          // setState(() {
          selectedWidget = widgetMarker.micro;
          // });
          break;
        }
      default:
        {
          // setState(() {
          selectedWidget = widgetMarker.macro;
          // });
          break;
        }
        break;
    }
  }

  void _showSnackbar(String msg, Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  // _fetchData() async {
  //   petPrefs = await SharedPreferences.getInstance();
  //   isFirst = petPrefs.getBool('first_time');
  //   petName = petPrefs.getString('pet_name');
  //   petAge = petPrefs.getString('pet_age');
  // }
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
    _petName = petPrefs.getString('pet_name');
    print(_petName);
    _petAge = petPrefs.getString('pet_age');
    print(_petAge);
    // _petName = petPrefs.getString('pet_name');
    // print(_petName);
    // _petAge = petPrefs.getString('pet_age');
    // print(_petAge);
    _userSubscribed = petPrefs.getBool('user_subscribed');
    print(_userSubscribed.toString());
  }

  _dismissSnackBar() {
    Scaffold.of(context).hideCurrentSnackBar();
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future<List<DailyGuideModel>> getDailyGuideModel() async {
    setState(() {
      _isLoading = true;
    });
    pr.show();
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
    String apiUrl =
        'guidelines/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;

    var response = await http.get(_fullUrl);
    print('------------Daily Guides--------------');
    print(response);

    if (response.statusCode == 200) {
      String res = response.body;
      print(response.body);
      //   return breweryModelFromJson(response.body);
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // if (resJson['success']) {
      //   print("user create response------------ " + res);
      // jsonString = resJson;
      List<DailyGuideModel> _dailyGuides = dailyGuideModelFromJson(res);
      //
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
      // baseVitaminC = _dailyGuides.nutrientGuidelines[26].amount;
      //
      await _fetchCategoryData();
      // await _fetchData();
      await _fetchMealPlans(_petID).whenComplete(() => pr.hide());
      //
      // pr.hide().whenComplete(
      //       () => () => setState(() {
      //             _showMealChips = true;
      //           }),
      //     );
      setState(() {
        // _showMealChips = true;
        _isLoading = false;
      });
      // return
      // } else {
      //   print("user failed response------------ " + res);
      //   ErrorModel _error = errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }
    } else {
      pr.hide().whenComplete(
            () => _showSnackbar('A Network Error Occurred.!', errorNet),
          );
      // If that call was not successful (response was unexpected), it throw an error.
      throw Exception('Failed to load Pet');
    }
  }

  Future<List<CATM.CategoryModel>> _fetchCategoryData() async {
    // pr.show();
    _mealCatApiUrl =
        'food_categories/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + _mealCatApiUrl;
    final response = await CallApi().getData(_mealCatApiUrl);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _allCatList.add(CATM.CategoryModel.fromJson(map));
            debugPrint('Id-------${map['id']}');
            debugPrint('name-------${map['name']}');
            debugPrint('foods-------${map['foods']}');
          }
        }
      }
      print(_allCatList.toString());
      for(int i = 0; i < _allCatList.length; i++){
        _categoryList.add(_allCatList[i].name);
      }
      print(_categoryList.toString());
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
    } else {
      // pr.hide();
      return _allCatList = [];//_allCatList = [];
      // If that call was not successful, throw an error.
      // throw Exception('Failed to load data');
    }
  }

  _fetchMealPlanDetails(int item) async {
    setState(() {
      _isLoading = true;
    });
    pr.show();
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
        _muscleMeatVal = 0.0;
        _muscleMeatClr = 'Green';
      } else {
        _muscleMeatVal = resDailyPercentages['Muscle Meat'][0];
        _muscleMeatClr = resDailyPercentages['Muscle Meat'][1];
      }
      if (resDailyPercentages['Bone'] == null) {
        _boneVal = 0.0;
        _boneClr = 'Green';
      } else {
        _boneVal = resDailyPercentages['Bone'][0];
        _boneClr = resDailyPercentages['Bone'][1];
      }
      if (resDailyPercentages['Organ Meat'] == null) {
        _organMeatVal = 0.0;
        _organMeatClr = 'Green';
      } else {
        _organMeatVal = resDailyPercentages['Organ Meat'][0];
        _organMeatClr = resDailyPercentages['Organ Meat'][1];
      }
      if (resDailyPercentages['Fruit and Veg'] == null) {
        _fruitNVegVal = 0.0;
        _fruitNVegClr = 'Green';
      } else {
        _fruitNVegVal = resDailyPercentages['Fruit and Veg'][0];
        _fruitNVegClr = resDailyPercentages['Fruit and Veg'][1];
      }

      MPD.MealPlanFetchModel _mealPlan =
          MPD.MealPlanFetchModel.fromJson(resJson);

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
      });
      await pr.hide();
      setState(() {
        // _showMealChips = false;
        _isData = true;
      });
    } else {
      // If that call was no successful (response was unexpected), it throw an error.
      _showSnackbar('A Network Error Occurred.!', errorNet);
      throw Exception('Failed to load Pet');
    }
  }

  // _fetchData() async {
  // String _baseUrl = '';
  // String _fullUrl = '';
  // String apiUrl = '';
  // if (_petID != null) {
  //   apiUrl =
  //   'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_petID';
  //   _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //   _fullUrl = _baseUrl + apiUrl;
  // } else {
  //   apiUrl =
  //   'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=1';
  //   _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //   _fullUrl = _baseUrl + apiUrl;
  // }
  // var response = await http.get(_fullUrl);
  // print('------------Pet Info--------------');
  // print(response);
  //
  // if (response.statusCode == 200) {
  //   String res = response.body;
  //   // _future = PET.petFetchFromJson(res) as Future<PET.PetFetch>;
  //   // If the call to the server was successful (returns OK), parse the JSON.
  //   var resJson = json.decode(res);
  //   // jsonString = resJson;
  //   // if (resJson['success']) {
  //   //   print("user create response------------ " + res);
  //   PET.PetFetch _pet = PET.PetFetch.fromJson(resJson);
  //   //
  //   _muscleMeatVal = _pet.dailyAllowanceGuidelinesDetails[0].percentage;
  //   _organMeatVal = _pet.dailyAllowanceGuidelinesDetails[1].percentage;
  //   _fruitNVegVal = _pet.dailyAllowanceGuidelinesDetails[2].percentage;
  //   _boneVal = _pet.dailyAllowanceGuidelinesDetails[3].percentage;
  //   //
  //   valProtein = _pet.nutrientGuidelineDetail[0].amount;
  //   valCrudeFat = _pet.nutrientGuidelineDetail[1].amount;
  //   //
  //   valCalciumPhosphorusRatio = _pet.nutrientGuidelineDetail[2].amount;
  //   valOmega3_6Ratio = _pet.nutrientGuidelineDetail[3].amount;
  //   //
  //   valOmega6 = _pet.nutrientGuidelineDetail[4].amount;
  //   valOmega3exclALAandSDA = _pet.nutrientGuidelineDetail[5].amount;
  //   valCalcium = _pet.nutrientGuidelineDetail[6].amount;
  //   valPhosphorus = _pet.nutrientGuidelineDetail[7].amount;
  //   valPotassium = _pet.nutrientGuidelineDetail[8].amount;
  //   valSodium = _pet.nutrientGuidelineDetail[9].amount;
  //   valMagnesium = _pet.nutrientGuidelineDetail[10].amount;
  //   valIron = _pet.nutrientGuidelineDetail[11].amount;
  //   valCopper = _pet.nutrientGuidelineDetail[12].amount;
  //   valManganese = _pet.nutrientGuidelineDetail[13].amount;
  //   valZinc = _pet.nutrientGuidelineDetail[14].amount;
  //   valIodine = _pet.nutrientGuidelineDetail[15].amount;
  //   valSelenium = _pet.nutrientGuidelineDetail[16].amount;
  //   valVitaminA = _pet.nutrientGuidelineDetail[17].amount;
  //   valVitaminD = _pet.nutrientGuidelineDetail[18].amount;
  //   valVitaminE = _pet.nutrientGuidelineDetail[19].amount;
  //   valThiaminB1 = _pet.nutrientGuidelineDetail[20].amount;
  //   valRiboflavinB2 = _pet.nutrientGuidelineDetail[21].amount;
  //   valNiacin = _pet.nutrientGuidelineDetail[22].amount;
  //   valPantothenic = _pet.nutrientGuidelineDetail[23].amount;
  //   valFolate = _pet.nutrientGuidelineDetail[24].amount;
  //   valCholine = _pet.nutrientGuidelineDetail[25].amount;
  //   // valVitaminC = _pet.nutrientGuidelineDetail[26].amount;
  //   //
  //   _petImage = _pet.image.url.toString();
  //
  //   print(_petImage);
  //

  //     setState(() {
  //       _isData = true;
  //       petNameApi = _pet.name;
  //       petAgeApi = _pet.age.toString();
  //       _petImageView = _petImage;
  //       //
  //       dataMap.update("Muscle Meat", (value) => _muscleMeatVal);
  //       print("Muscle Meat " + _muscleMeatVal.toString());
  //       dataMap.update("Organ Meat", (value) => _organMeatVal);
  //       dataMap.update("Fruit & Veg", (value) => _fruitNVegVal);
  //       dataMap.update("Bone", (value) => _boneVal);
  //       //
  //
  //       print('-------value sample 1 -------' +
  //           roundDouble(valProtein / (baseProtein * 2), 1).toString());
  //       print('-------value sample 2 -------' +
  //           roundDouble(valCrudeFat / (baseCrudeFat * 2), 1).toString());
  //       //
  //     });
  //     // return
  //     // } else {
  //     //   print("user failed response------------ " + res);
  //     //   ErrorModel _error = errorModelFromJson(res);
  //     //   String msg = _error.message;
  //     //   _showSnackbar(msg, errorAPI);
  //     // }
  //   } else {
  //     // If that call was not successful (response was unexpected), it throw an error.
  //     _showSnackbar('A Network Error Occurred.!', errorNet);
  //     throw Exception('Failed to load Pet');
  //   }
  // }

  Future<List<AllMealPlanModel>> _fetchMealPlans(String item) async {
    _mealPlanApiUrl =
        'feeding_plans/fetch_all?user_email=$_userEmail&user_token=$_userToken&pet_id=$item';
    String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    String _fullUrl = _baseUrl + _mealPlanApiUrl;
    final response = await CallApi().getData(_mealPlanApiUrl);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();
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
      return _allMealPlanList;
    } else {
      _allMealPlanList = [];
      return _allMealPlanList;
      // If that call was not successful, throw an error.
      // throw Exception('Failed to load data');
    }
  }

  // _fetchMealPlans() async {
  //   String _baseUrl = '';
  //   String _fullUrl = '';
  //   String apiUrl = '';
  //   if(_petID != null) {
  //     apiUrl =
  //     'feeding_plans/fetch_all?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_petID';
  //     _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //     _fullUrl = _baseUrl + apiUrl;
  //   }
  //   // else{
  //   //   apiUrl =
  //   //   'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=1';
  //   //   _baseUrl = 'https://api.pawfect-balance.oz.to/';
  //   //   _fullUrl = _baseUrl + apiUrl;
  //   // }
  //   var response = await http.get(_fullUrl);
  //   print('------------Pet Info--------------');
  //   print(response);
  //
  //   if (response.statusCode == 200) {
  //     String res = response.body;
  //     // _future = PET.petFetchFromJson(res) as Future<PET.PetFetch>;
  //     // If the call to the server was successful (returns OK), parse the JSON.
  //     var resJson = json.decode(res);
  //     // jsonString = resJson;
  //     if(resJson['success']){
  //       print("user create response------------ "+ res);
  //       PET.PetFetch _pet = PET.PetFetch.fromJson(resJson);
  //       //
  //       _muscleMeatVal = _pet.dailyAllowanceGuidelinesDetails[0].percentage;
  //       _organMeatVal = _pet.dailyAllowanceGuidelinesDetails[1].percentage;
  //       _fruitNVegVal = _pet.dailyAllowanceGuidelinesDetails[2].percentage;
  //       _boneVal = _pet.dailyAllowanceGuidelinesDetails[3].percentage;
  //       //
  //       valProtein = _pet.nutrientGuidelineDetail[0].amount;
  //       valCrudeFat = _pet.nutrientGuidelineDetail[1].amount;
  //       //
  //       valCalciumPhosphorusRatio = _pet.nutrientGuidelineDetail[2].amount;
  //       valOmega3_6Ratio = _pet.nutrientGuidelineDetail[3].amount;
  //       //
  //       valOmega6 = _pet.nutrientGuidelineDetail[4].amount;
  //       valOmega3exclALAandSDA = _pet.nutrientGuidelineDetail[5].amount;
  //       valCalcium = _pet.nutrientGuidelineDetail[6].amount;
  //       valPhosphorus = _pet.nutrientGuidelineDetail[7].amount;
  //       valPotassium = _pet.nutrientGuidelineDetail[8].amount;
  //       valSodium = _pet.nutrientGuidelineDetail[9].amount;
  //       valMagnesium = _pet.nutrientGuidelineDetail[10].amount;
  //       valIron = _pet.nutrientGuidelineDetail[11].amount;
  //       valCopper = _pet.nutrientGuidelineDetail[12].amount;
  //       valManganese = _pet.nutrientGuidelineDetail[13].amount;
  //       valZinc = _pet.nutrientGuidelineDetail[14].amount;
  //       valIodine = _pet.nutrientGuidelineDetail[15].amount;
  //       valSelenium = _pet.nutrientGuidelineDetail[16].amount;
  //       valVitaminA = _pet.nutrientGuidelineDetail[17].amount;
  //       valVitaminD = _pet.nutrientGuidelineDetail[18].amount;
  //       valVitaminE = _pet.nutrientGuidelineDetail[19].amount;
  //       valThiaminB1 = _pet.nutrientGuidelineDetail[20].amount;
  //       valRiboflavinB2 = _pet.nutrientGuidelineDetail[21].amount;
  //       valNiacin = _pet.nutrientGuidelineDetail[22].amount;
  //       valPantothenic = _pet.nutrientGuidelineDetail[23].amount;
  //       valFolate = _pet.nutrientGuidelineDetail[24].amount;
  //       valCholine = _pet.nutrientGuidelineDetail[25].amount;
  //       // valVitaminC = _pet.nutrientGuidelineDetail[26].amount;
  //       //
  //       _petImage = _pet.image.url.toString();
  //
  //       print(_petImage);
  //       //
  //
  //       setState(() {
  //         _isData = true;
  //         petNameApi = _pet.name;
  //         petAgeApi = _pet.age.toString();
  //         _petImageView = _petImage;
  //         //
  //         dataMap.update("Muscle Meat", (value) => _muscleMeatVal);
  //         print("Muscle Meat " + _muscleMeatVal.toString());
  //         dataMap.update("Organ Meat", (value) => _organMeatVal);
  //         dataMap.update("Fruit & Veg", (value) => _fruitNVegVal);
  //         dataMap.update("Bone", (value) => _boneVal);
  //         //
  //         print('-------value sample 1 -------' +
  //             roundDouble(valProtein / (baseProtein * 2), 1).toString());
  //         print('-------value sample 2 -------' +
  //             roundDouble(valCrudeFat / (baseCrudeFat * 2), 1).toString());
  //         //
  //       });
  //       // return
  //     }else{
  //       print("user failed response------------ "+ res);
  //       ErrorModel _error =  errorModelFromJson(res);
  //       String msg = _error.message;
  //       _showSnackbar(msg, errorAPI);
  //     }
  //   } else {
  //     // If that call was not successful (response was unexpected), it throw an error.
  //     _showSnackbar('A Network Error Occurred.!', errorNet);
  //     throw Exception('Failed to load Pet');
  //   }
  // }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Text(message),
          GestureDetector(
            child: Text('Dismiss'),
            onTap: _dismissSnackBar,
          ),
        ],
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

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

  // void _delete(BuildContext context, MPD.FeedingPlanDetail mealPlan) async {
  //   int result = await databaseHelper.deleteTodo(mealPlan.id);
  //   if (result != 0) {
  //     _showSnackBar(context, 'MealPlan Deleted Successfully');
  //     updateListView();
  //   }
  // }

  // ListView getMealPlanListView() {
  //   return ListView.builder(
  //     itemCount: foodPlanDetails.length,
  //     itemBuilder: (BuildContext context, int position) {
  //       //
  //       CATM.CategoryModel category;
  //       for (var i = 0; i < _allCatList.length; i++) {
  //         List<CATM.Food> _foods = _allCatList[i].foods;
  //         for (var j = 0; j < _foods.length; j++) {
  //           if (_foods[j].id == foodPlanDetails[position].food.id) {
  //             category = _allCatList[i];
  //           }
  //         }
  //       }
  //       return Card(
  //         color: Colors.white,
  //         elevation: 1.0,
  //         child: ListTile(
  //           title: Container(
  //             width: MediaQuery.of(context).size.width,
  //             height: 32.0,
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     foodPlanDetails != null ? category.name : "category",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontFamily: 'poppins',
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     foodPlanDetails != null
  //                         ? this.foodPlanDetails[position].food.name
  //                         : "Type",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontFamily: 'poppins',
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     foodPlanDetails != null
  //                         ? this.foodPlanDetails[position].quantity
  //                         : "000",
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontFamily: 'poppins',
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Container(
  //                     child: GestureDetector(
  //                       child: Icon(
  //                         Icons.delete,
  //                         color: Colors.red,
  //                       ),
  //                       onTap: () {
  //                         _delete(context, foodPlanDetails[position]);
  //                       },
  //                       // onTap: () async {
  //                       //   key:
  //                       //   ValueKey(mealPlans[position].mealPlanID);
  //                       //   //_delete(context, mealPlans[index]);
  //                       //   final result = await showDialog(
  //                       //       context: context, builder: (_) => MealPlanDelete());
  //                       //   print(result);
  //                       //   return result;
  //                       // },
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             // mealPlans[index].mealPlanCategory,
  //             // style: TextStyle(color: Theme.of(context).primaryColor),
  //           ),
  //           // subtitle: Text('Last edited on ${formatDateTime(notes[index].latestEditDateTime)}'),
  //           onTap: () {
  //             // Navigator.of(context).push(MaterialPageRoute(
  //             //     builder: (_) =>
  //             // navigateToDetail(this.mealPlanList[position]);
  //           },
  //         ),
  //         // ),
  //       );
  //     },
  //   );
  // }

  // List<String> _categoryList = ['cat1', 'cat2', 'cat3', 'cat4', 'cat5'];
  // String _categorySelected;
  // List<String> _foodTypeList = ['type1', 'type2', 'type3', 'type4', 'type5'];
  // String _foodTypeSelected;



  // navigateToDetail(MealPlan mealPlan) async {
  //   bool result =
  //   await Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return _mealPlanBtmSheet(mealPlan);
  //     MealPlanModify(mealPlan);
  //   }));
  //
  //   if (result == true) {
  //     updateListView();
  //   }
  // }

  // void _addItem() {
  //   int i = mealPlanList.length > 0 ? mealPlanList.length : 0;
  //   setState(() {
  //     mealPlanList.insert(
  //         i,
  //         MealPlan(
  //             'cat${mealPlanList.length + 1}',
  //             'food type${mealPlanList.length + 1}',
  //             '${mealPlanList.length + 1}*100'));
  //   });
  //   Navigator.of(context).pop();
  // }

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
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   stops: [0.5, 1.0],
          //   colors: [
          //     Color(0xFF03B898),
          //     Color(0xFF01816B),
          //   ],
          // ),
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
              // ),
              // SizedBox(height: 12.0),
              // ),
              // Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  // height: 180,
                  // margin: EdgeInsets.only(top: 8.0),
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
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
//                                 Expanded(
//                                   flex: 1,
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12.0),
//                                     child: Container(
//                                       height: MediaQuery.of(context).size.height * 0.75,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Expanded(
//                                             flex: 1,
//                                             // padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                    child: Container(
// //                      width: 150.0,
// //                      color: Colors.white, //Color(0xFF01816B),
// //                    width: MediaQuery.of(context).size.width,
//                                             child: new FlatButton(
//                                               padding: const EdgeInsets.symmetric(
//                                                   horizontal: 12.0),
//                                               minWidth: 150.0,
//                                               height: 60.0,
//                                               color: Colors.white,
//                                               colorBrightness: Brightness.light,
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(5),
//                                                 side: BorderSide(
//                                                   width: 2.0,
//                                                   color: Color(0xFF01816B),
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 Navigator.of(context).pop();
//                                                 // _isSubscribed = false;
//                                                 // _isLoading ? null : _handleSubmitUser(context);
//                                               },
//                                               child: new Text(
//                                                 'CANCEL',
//                                                 style: TextStyle(
//                                                   color: Color(0xFF01816B),
//                                                   fontFamily: 'poppins',
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 24.0,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
// //                          ),
// //                       padding: EdgeInsets.all(2),
//                                             ),
// //                    ),
//                                           ),
//                                           SizedBox(width: 12.0),
//                                           Expanded(
//                                             flex: 1,
//                                             // padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                    child: Container(
// //                      width: 150.0,
// //                      color: Color(0xFF01816B),
//                                             child: new FlatButton(
//                                               padding: const EdgeInsets.symmetric(
//                                                   horizontal: 12.0),
//                                               minWidth: 150.0,
//                                               height: 60.0,
//                                               color: Color(0xFF01816B),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                 BorderRadius.circular(5),
//                                                 side: BorderSide(
//                                                   width: 2.0,
//                                                   color: Color(0xFF01816B),
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 // _addItem();
//                                                 // _isSubscribed = true;
//                                                 // _isLoading ? null : _handleSubmitUser(context);
//                                               },
//                                               child: new Text(
//                                                 'APPLY',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontFamily: 'poppins',
//                                                   fontWeight: FontWeight.w600,
//                                                   fontSize: 24.0,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
// //                        ),
// //                       padding: EdgeInsets.all(2),
//                                             ),
// //                    ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   // ),
//                                 ),
//                                 ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    // itemCount: _suggestions.length,
                    // itemBuilder: (BuildContext context, int index) {
                    //   return
                    // }
                    // ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.80,
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
                          // padding: EdgeInsets.symmetric(horizontal: 16.0),
//                    child: Container(
//                      width: 150.0,
//                      color: Color(0xFF01816B),
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

  final oneMealCal = Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    alignment: Alignment.centerLeft,
    child: Text(
      'Weight of One Meal: 425 gm',
      style: kSubContentStyleBlack,
    ),
  );

  final balancedMealCal = Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    alignment: Alignment.centerLeft,
    child: Text(
      'Weight of a Balanced Meal: 395 gm',
      style: kSubContentStyleBlack,
    ),
  );

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

  @override
  Widget build(BuildContext context) {
    // _showMealChips = true;

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
    // pr.update(
    //   progress: 60.0,
    //   message: "Almost There...",
    //   progressWidget: Container(
    //       padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
    //   maxProgress: 100.0,
    //   progressTextStyle: TextStyle(
    //       color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    //   messageTextStyle: TextStyle(
    //       color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    // );

    // add/edit meal plan bottom Sheet //
    _mealPlanBtmSheet(_mealPlan) {
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
              margin: EdgeInsets.only(top: 100.0),
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
                          'Weight of One Meal: 425 gm',
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
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          // for (int i = 0; i < 5; i++) {
                          //   if (_selectedCategoryList.length < 5) {
                          //     _selectedCategoryList.add(new CATM.CategoryModel());
                          //   }
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Category",
                                          style: kSubContentStyleWhiteLight,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Food Type",
                                          style: kSubContentStyleWhiteLight,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Quantity",
                                          style: kSubContentStyleWhiteLight,
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
                                          // height: 48.0,
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
                                          child: DropdownButton<String>( //<CATM.CategoryModel>(
                                            //<CATM.CategoryModel>(
                                            value: _selectedValCategory, //_category,
                                            // _selectedCategory,
                                            isDense: false,
                                            isExpanded: true,
                                            // icon: Icon(Icons.arrow_downward),
                                            hint: Text(
                                              'Category',
                                              style: kSubContentStyleWhitSmaller,
                                            ),
                                            // iconSize: 24,
                                            // elevation: 16,
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged:
                                            // (_allCatList == null) ? null :
                                            // (CATM.CategoryModel selectedCat) {
                                                (newVal){
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
                                              _selectedValCategory = newVal;

                                              setState(() {
                                                _selectedValFood = null;
                                                // _foodType = null;
                                                // _category
                                                _selectedValCategory = newVal;
                                                // foodTypeList.clear();
                                                _foodsList.clear();
                                                // foodTypeList.clear();
                                                // this._selectedCategory =
                                                //     selectedCat;
                                                // foodTypeList =
                                                // _selectedCategoryList[index]
                                                for(int i=0; i < _allCatList.length; i++){
                                                  if(_allCatList[i].name == _selectedValCategory){
                                                    foodTypeList = _allCatList[i].foods;
                                                    //
                                                    for(int j = 0; j<foodTypeList.length; j++){
                                                      _foodsList.add(foodTypeList[j].name);
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
                                            items: _categoryList.map((cat) { //_allCatList
                                              return new DropdownMenuItem<String>( //<CATM.CategoryModel>(
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
                                          child: DropdownButton<String>( //<CATM.Food>(
                                            //<CATM.Food>(
                                            value: _selectedValFood, //_foodType,
                                            //_selectedFoodType,
                                            isDense: false,
                                            isExpanded: true,
                                            hint: Text(
                                              'FoodType',
                                              style: kSubContentStyleWhitSmaller,
                                            ),
                                            // iconSize: 24,
                                            // elevation: 2,
                                            style:
                                            kSubContentStyleBlackLightSmall,
                                            onChanged:
                                            // disableDP2 ? null : (CATM.Food newValue) {
                                            // (CATM.Food newValue) {
                                                (newVal){
                                              // _selectedValFood = newVal;
                                              setState(() {
                                                // _selectedFoodType = null;
                                                // foodTypeList.clear();
                                                // _foodType = newValue;
                                                _selectedValFood = newVal;
                                                // _selectedFoodType = newValue;
                                                // for(var item in _)
                                                // foodTypeName = newValue
                                                //     _selectedFoodType.name;
                                                // foodTypeID = _selectedFoodType.id
                                                //     .toString();
                                                // disableDP2 = false;
                                              });
                                            },
                                            items: _foodsList.map((fdt) { //foodTypeList
                                              return new DropdownMenuItem<String>( // <CATM.Food>(
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
                                          width:
                                          MediaQuery.of(context).size.width /
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
                                            // controller: _mealPlanQtyController,
                                            inputFormatters: [
                                              new LengthLimitingTextInputFormatter(
                                                  3),
                                            ],
                                            // decoration: InputDecoration(
                                            //   border: OutlineInputBorder(),
                                            // ),
                                            keyboardType: TextInputType.number,
                                            autofocus: false,
                                            validator: validateNumberDecimal,
                                            onSaved: (String value) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                                  // _addItem();
                                  // setState((){
                                  _showMealChips = false;
                                  // });
                                  Navigator.of(context).pop();
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
      ).whenComplete(() => print('calling after hide bottomSheet'));
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
      // return
      // Expanded(
      // child:
      //   ListView.builder(
      // itemCount: _allMealPlanList.length,
      // itemBuilder: (BuildContext context, int index) {
      return Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: List<Widget>.generate(
            _allMealPlanList.length,
            (index) => ChoiceChip(
              padding: EdgeInsets.all(4.0),
              avatar: CircleAvatar(
                child: Text(
                  _allMealPlanList[index].petName[0].toUpperCase(),
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500),
                ),
                backgroundColor: Color(0xFF03B898),
              ),
              label: Text(
                _allMealPlanList[index].petName + '\'s Meal Plan',
              ),
              selected: _defaultChoiceIndex == index,
              selectedColor: Colors.green,
              onSelected: (bool selected) async {
                await _fetchMealPlanDetails(_allMealPlanList[index].id);
                setState(() {
                  _defaultChoiceIndex = selected ? index : 0;
                });
              },
              backgroundColor: Colors.blue,
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w500),
            ),
          )
          // [
          //
          // ],
          // child:
          );
      // },
      // ),
      //   );
    }

    // Iterable<Widget> get allMealPlanWidgets sync* {
    // for (AllMealPlanModel mealPlans in _allMealPlanList) {
    // yield Padding(
    // padding: const EdgeInsets.all(6.0),
    // // child: FilterChip(
    // // avatar: CircleAvatar(
    // // child: Text(mealPlans.petName[0].toUpperCase()),
    // // ),
    // // label: Text(mealPlans.petName),
    // // selected: _filters.contains(company.name),
    // // onSelected: (bool selected) {
    // // setState(() {
    // // if (selected) {
    // // _filters.add(company.name);
    // // } else {
    // // _filters.removeWhere((String name) {
    // // return name == company.name;
    // // });
    // // }
    // // });
    // // },
    // // ),
    // );
    // }
    // }
    //
    // Wrap(
    // children: allMealPlanWidgets.toList(),
    // ),

    // var swapMealPlans = new Container(
    //   child: _swapInsideBTMS ? balancedMealCal : oneMealCal,
    // );
    // //
    // if (mealPlanList == null) {
    //   mealPlanList = List<MealPlan>();
    //   updateListView();
    // }

    final petHeader = Container(
      alignment: Alignment.center,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      // height: 48.0,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Hero(
              tag: 'hero',
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey[300],
                  child: _petImageView == null
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
          Expanded(
            flex: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // margin: EdgeInsets.only(left: 4.0,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _petID == null ? 'Name' : _petName,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: 'poppins',
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _petID == null ? 'Name' : _petAge + ' years',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'poppins',
                        color: Colors.black87,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: const Text(
                'Meal Plan',
                style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );

    final mealPlanListViewTitles = Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            'Food Type',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Quantity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '',
          ),
        ),
      ],
    );
    // }

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
                  dailyCalVal,
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
              rate:
                  roundDouble(double.parse(valProtein) / (baseProtein * 2), 1),
              color: proteinClr != '' ? changeClr(proteinClr) : Colors.green),
          ChartLineMeals(
              title: 'Crude Fat ',
              number: double.parse(valCrudeFat),
              rate: roundDouble(
                  double.parse(valCrudeFat) / (baseCrudeFat * 2), 1),
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
              number: double.parse(valRiboflavinB2),
              rate: roundDouble(
                  double.parse(valRiboflavinB2) / (baseRiboflavinB2 * 2), 1),
              color: ribofClr != '' ? changeClr(ribofClr) : Colors.green),
          ChartLineSmall(
              title: 'Niacin (B3) ',
              number: double.parse(valNiacin),
              rate: roundDouble(double.parse(valNiacin) / (baseNiacin * 2), 1),
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
    // Center(
    //   child: Text('macro chart here'),
    // );

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
                  left: MediaQuery.of(context).size.width * 0.50,
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

    Widget getMacroChart() {
      return Center(
        child: Text('macro chart here'),
      );
    }

    Widget getMicroChart() {
      return Center(
        child: Text('micro chart here'),
      );
    }

    Widget getCustomContainer() {
      switch (selectedWidget) {
        case widgetMarker.macro:
          return getMacroChart();
        case widgetMarker.micro:
          return getMicroChart();
      }
      return getMacroChart();
    }
    //
    // Widget swapWidget;
    // if (_swapNutrients) {
    //   swapWidget = macroCharts;
    // } else {
    //   swapWidget = microCharts;
    // }

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
                _mealPlanBtmSheet(MealPlan(
                    '', '', '')); //navigateToDetail(MealPlan('', '', ''));
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

    // void _addItem(){
    //   int i = mealPlanList.length > 0 ? mealPlanList.length: 0;
    //   mealPlanList.insert(i, MealPlan('cat${mealPlanList.length+1}', 'food type${mealPlanList.length+1}', '${mealPlanList.length+1}*100'));
    // }
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
                      // SizedBox(height: 12.0),
                      Expanded(
                        flex: 9,
                        child: choiceChips(),
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
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'Calorie Calculator',
//             style: TextStyle(
//                 fontSize: 32.0,
//                 fontFamily: 'poppins',
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 24.0),
//           const Text(
//             'The calorie calculator results are an estimate only. The condition of your dog is the best indicator of your dog’s energy requirements and must be monitored closely.',
//             style: TextStyle(
//                 fontSize: 24.0,
//                 fontFamily: 'poppins',
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 48.0),
//           Container(
//             child: FlatButton(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               onPressed: () {
//                 setState(() {
//                   isFirst = true;
//                 });
// //          _handleSubmit(context);
// //          Navigator.of(context).pushNamed(HomeScreen.tag);
//               },
//               padding: EdgeInsets.all(12),
//               color: Color(0xFF03B898),
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Text(
//                   'AGREED',
//                   style: kMainHeadingStyleWhite,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             // ),
//           )
//         ],
//       ),
        );

    Widget body() {
      // _showMealChips = true;
      // Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   child:
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
              // Expanded(
              Expanded(
                flex: 2,
                // child: Container(
                //   color: Colors.transparent,
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
                                  ? AnimatedList(
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

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

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
            child: _showMealChips ? _disclaimer() : body(),
          ),
          // lorem,
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: mainBody, //_isShowingDialog ? bodyWithDialog : bodyWithCharts
    );
  }
}
// }

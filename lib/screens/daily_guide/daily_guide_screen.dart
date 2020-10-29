import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:pawfect/models/daily_guide_model/daily_guide_model.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/pets/pet_fetch_model.dart' as PET;
import 'package:pawfect/models/pets/pet_model.dart';
import 'package:pawfect/screens/daily_guide/chartline.dart';
import 'package:pawfect/screens/daily_guide/chartline_ratio.dart';
import 'package:pawfect/screens/daily_guide/chartline_small.dart';
import 'package:pawfect/screens/profiles/pet/pet_add_new_screen.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

enum widgetMarker { macro, micro }
enum LegendShape { Circle, Rectangle }

class DailyGuideScreen extends StatefulWidget {
  DailyGuideScreen({Key key}) : super(key: key);
  static String tag = 'daily-guide-page';

  @override
  _DailyGuideScreenState createState() => _DailyGuideScreenState();
}

class _DailyGuideScreenState extends State<DailyGuideScreen> {
  bool isFirst = false;
  Future<List<DailyGuideModel>> dailyGuideObject;

  //
  // Future<bool> isFirstTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var isFirstTime = prefs.getBool('first_time_dailyGuide');
  //   if (isFirstTime != null && !isFirstTime) {
  //     prefs.setBool('first_time_dailyGuide', false);
  //     isFirst = true;
  //     return Future<bool>.value(false);
  //   } else {
  //     prefs.setBool('first_time_dailyGuide', false);
  //     isFirst = false;
  //     return Future<bool>.value(true);
  //   }
  // }

  //
  Map<String, double> dataMap = {
    "Muscle Meat": 60,
    "Organ Meat": 10,
    "Fruit & Veg": 20,
    "Bone": 10,
  };

  //
  List<Color> colorList = [
    Color(0xFF087AAA),
    Color(0xFF5f74bb),
    Color(0xFF20a7fa),
    Color(0xFF18b3c1),
    // Colors.green,
    // Colors.blue,
    // Colors.yellow,
  ];

//
  //pie chart specifications
  ChartType _chartType = ChartType.disc;
  bool _showCenterText = true;
  double _ringStrokeWidth = 12;
  double _chartLegendSpacing = 24;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = true;
  bool _showChartValuesOutside = false;

  LegendShape _legendShape = LegendShape.Rectangle;
  LegendPosition _legendPosition = LegendPosition.left;

  int key = 0;

  // List<bool> isSelectedBtn = [true, false];
  // FocusNode focusNodeButtonMacro = FocusNode();
  // FocusNode focusNodeButtonMicro = FocusNode();
  // List<FocusNode> focusToggle;

  // Future<bool> isFirstTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var isFirstTime = prefs.getBool('first_time');
  //   if (isFirstTime != null && !isFirstTime) {
  //     prefs.setBool('first_time', false);
  //     return false;
  //   } else {
  //     prefs.setBool('first_time', false);
  //     return true;
  //   }
  // }

  bool _isShowingDialog = false;
  bool _swapNutrients = true;
  widgetMarker selectedWidget = widgetMarker.macro;
  int selectedSwitchIndex = 0;

  SharedPreferences petPrefs;
  String _userEmail='';
  String _userToken='';
  String _petID = '0';
  String _petName = 'name';
  String _petAge = '0';
  String petNameApi = '';
  String petAgeApi = '';
  String petIDApi = '';
  bool _isData = false;
  String jsonString = '';
  bool _userSubscribed = false;

  String _petImage = '';
  String _petImageView = '';

  ProgressDialog pr;
  bool _isLoading = false;
  //
  double _muscleMeatVal = 1.0;
  double _organMeatVal = 1.0;
  double _fruitNVegVal = 1.0;
  double _boneVal = 1.0;

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
  double valProtein = 1.0;
  double valCrudeFat = 1.0;

  //
  double valCalciumPhosphorusRatio = 1.0;
  double valOmega3_6Ratio = 1.0;

  //
  double valOmega6 = 1.0;
  double valOmega3exclALAandSDA = 1.0;
  double valCalcium = 1.0;
  double valPhosphorus = 1.0;
  double valPotassium = 1.0;
  double valSodium = 1.0;
  double valMagnesium = 1.0;
  double valIron = 1.0;
  double valCopper = 1.0;
  double valManganese = 1.0;
  double valZinc = 1.0;
  double valIodine = 1.0;
  double valSelenium = 1.0;
  double valVitaminA = 1.0;
  double valVitaminD = 1.0;
  double valVitaminE = 1.0;
  double valThiaminB1 = 1.0;
  double valRiboflavinB2 = 1.0;
  double valNiacin = 1.0;
  double valPantothenic = 1.0;
  double valFolate = 1.0;
  double valCholine = 1.0;
  double valVitaminC = 1.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];
  //
  Future<PET.PetFetch> _future;

  @override
  void initState() {
    super.initState();
    // isFirstTime();
    // dailyGuideObject =
    _getLocalData(); //.then(getDailyGuideModel());
    // fetchGuideLineData() ;
    // _fetchData();
    // focusToggle = [focusNodeButtonMacro, focusNodeButtonMicro];
    // Timer(Duration(seconds: 6), ()
    // {
//     isFirstTime().then((isFirstTime) {
//       isFirstTime
//           ?
// //        print("First time")
//           //show the modal dialog
//           _isShowingDialog = true
//           :
// //        print("Not first time")
//           //show the guideline chart for current  pet
//           _isShowingDialog = false;
//     });
    // });
  }

  _getLocalData() async{
    petPrefs = await SharedPreferences.getInstance();
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
    _userSubscribed = petPrefs.getBool('user_subscribed');
    print(_userSubscribed.toString());
    //
    _dailyGuides = await getDailyGuideModel();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   // focusNodeButtonMacro.dispose();
  //   // focusNodeButtonMicro.dispose();
  //   super.dispose();
  // }
  void _showSnackbar(String msg, Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  List<DailyGuideModel> _dailyGuides = new List<DailyGuideModel>();//dailyGuideModelFromJson(res);

  //roundDouble(12.3412, 2)
//
  Future<List<DailyGuideModel>> getDailyGuideModel() async {

    //
    setState(() {
      _isLoading = true;
    });

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
      setState(() {});
      // pr.hide();
      _fetchData();

      return _dailyGuides;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    //
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
    // petPrefs = await SharedPreferences.getInstance();
    // isFirst = petPrefs.getBool('first_time');
    // // var prefJson = viewPrefs.getString('userData');
    // // var user = json.decode(prefJson);
    // _userEmail = petPrefs.getString('user_email');
    // print(_userEmail);
    // _userToken = petPrefs.getString('user_token');
    // print(_userEmail);
    // _petID = petPrefs.getString('pet_id');
    // print(_petID);
    // _petName = petPrefs.getString('pet_name');
    // print(_petName);
    // _petAge = petPrefs.getString('pet_age');
    // print(_petAge);
    // // _petName = petPrefs.getString('pet_name');
    // // print(_petName);
    // // _petAge = petPrefs.getString('pet_age');
    // // print(_petAge);
    // _userSubscribed = petPrefs.getBool('user_subscribed');
    // print(_userSubscribed.toString());
    //
    // String apiUrl = 'guidelines/fetch_all?user_email=$_userEmail&user_token=$_userToken';
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
    //   //   return breweryModelFromJson(response.body);
    //   // If the call to the server was successful (returns OK), parse the JSON.
    //   var resJson = json.decode(res);
      // if(resJson['success']){
      //   print("user create response------------ "+ res);
      // jsonString = resJson;
      // List<DailyGuideModel> _dailyGuides = dailyGuideModelFromJson(res);
      //

      // return
      // }else{
      //   print("user failed response------------ "+ res);
      //   ErrorModel _error =  errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }
    // } else {
    //   // If that call was not successful (response was unexpected), it throw an error.
    //   _showSnackbar('A Network Error Occurred.!', errorNet);
    //   throw Exception('Failed to load Pet');
    // }
  }

  _fetchData() async {
    String _baseUrl = '';
    String _fullUrl = '';
    String apiUrl = '';
    if(_petID != null) {
      apiUrl =
          'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_petID';
      _baseUrl = 'https://api.pawfect-balance.oz.to/';
      _fullUrl = _baseUrl + apiUrl;
    }else{
      apiUrl =
      'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=1';
      _baseUrl = 'https://api.pawfect-balance.oz.to/';
      _fullUrl = _baseUrl + apiUrl;
    }
    var response = await http.get(_fullUrl);
    print('------------Pet Info--------------');
    print(response);

    if (response.statusCode == 200) {
      String res = response.body;
      // _future = PET.petFetchFromJson(res) as Future<PET.PetFetch>;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // if(resJson['success']){
      //   print("user create response------------ "+ res);
      // jsonString = resJson;
      PET.PetFetch _pet = PET.PetFetch.fromJson(resJson);
      //
      _muscleMeatVal = _pet.dailyAllowanceGuidelinesDetails[0].percentage;
      _organMeatVal = _pet.dailyAllowanceGuidelinesDetails[1].percentage;
      _fruitNVegVal = _pet.dailyAllowanceGuidelinesDetails[2].percentage;
      _boneVal = _pet.dailyAllowanceGuidelinesDetails[3].percentage;
      //
      valProtein = _pet.nutrientGuidelineDetail[0].amount;
      valCrudeFat = _pet.nutrientGuidelineDetail[1].amount;
      //
      valCalciumPhosphorusRatio = _pet.nutrientGuidelineDetail[2].amount;
      valOmega3_6Ratio = _pet.nutrientGuidelineDetail[3].amount;
      //
      valOmega6 = _pet.nutrientGuidelineDetail[4].amount;
      valOmega3exclALAandSDA = _pet.nutrientGuidelineDetail[5].amount;
      valCalcium = _pet.nutrientGuidelineDetail[6].amount;
      valPhosphorus = _pet.nutrientGuidelineDetail[7].amount;
      valPotassium = _pet.nutrientGuidelineDetail[8].amount;
      valSodium = _pet.nutrientGuidelineDetail[9].amount;
      valMagnesium = _pet.nutrientGuidelineDetail[10].amount;
      valIron = _pet.nutrientGuidelineDetail[11].amount;
      valCopper = _pet.nutrientGuidelineDetail[12].amount;
      valManganese = _pet.nutrientGuidelineDetail[13].amount;
      valZinc = _pet.nutrientGuidelineDetail[14].amount;
      valIodine = _pet.nutrientGuidelineDetail[15].amount;
      valSelenium = _pet.nutrientGuidelineDetail[16].amount;
      valVitaminA = _pet.nutrientGuidelineDetail[17].amount;
      valVitaminD = _pet.nutrientGuidelineDetail[18].amount;
      valVitaminE = _pet.nutrientGuidelineDetail[19].amount;
      valThiaminB1 = _pet.nutrientGuidelineDetail[20].amount;
      valRiboflavinB2 = _pet.nutrientGuidelineDetail[21].amount;
      valNiacin = _pet.nutrientGuidelineDetail[22].amount;
      valPantothenic = _pet.nutrientGuidelineDetail[23].amount;
      valFolate = _pet.nutrientGuidelineDetail[24].amount;
      valCholine = _pet.nutrientGuidelineDetail[25].amount;
      // valVitaminC = _pet.nutrientGuidelineDetail[26].amount;
      //
      _petImage = _pet.image.url.toString();
      petNameApi = _pet.name;
      petAgeApi = _pet.age.toString();
      print(_petImage);
      //

      setState(() {
        _isData = true;
        _petName = petNameApi;
        _petAge = petAgeApi;
        _petImageView = _petImage;
        //
        dataMap.update("Muscle Meat", (value) => _muscleMeatVal);
        print("Muscle Meat " + _muscleMeatVal.toString());
        dataMap.update("Organ Meat", (value) => _organMeatVal);
        dataMap.update("Fruit & Veg", (value) => _fruitNVegVal);
        dataMap.update("Bone", (value) => _boneVal);
        //
        print('-------value sample 1 -------' +
            roundDouble(valProtein / (baseProtein * 2), 1).toString());
        print('-------value sample 2 -------' +
            roundDouble(valCrudeFat / (baseCrudeFat * 2), 1).toString());
        //
      });
      // return
      // }else{
      //   print("user failed response------------ "+ res);
      //   ErrorModel _error =  errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      _showSnackbar('A Network Error Occurred.!', errorNet);
      throw Exception('Failed to load Pet');
    }
  }

  AlertDialog buildAlertDialog(String str) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          str,
          style: kMainContentStyleDarkBlack,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        FlatButton(
          child: new Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final petHeader = Container(
      // alignment: Alignment.center,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      // height: 48.0,
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
                        fit: BoxFit.fitHeight,
                        child: Text(
                          _petName , //'Dog Name',
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
                          _petAge +' years', //'Age',
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
            flex: 4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 4.0,vertical: 4.0,
              ),
              child:
                  // Row(
                  //   children: [
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: const Text(
                'Daily Guide',
                style: TextStyle(
                      // fontSize: 20.0,
                      fontFamily: 'poppins',
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
                  ),
              //   ],
              // ),
            ),
          ),
          Expanded(
            flex: 2,
            child:
            _userSubscribed ?
            FittedBox(
              fit: BoxFit.fitHeight,
              child: Container(
                      // width: 60.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                              child: PetAddNewScreen(),
                              type: PageTransitionType.leftToRight,
                            ),
                          );
                        },
                        child: ClipOval(
                          child: Container(
                            color: Color(0xFF01816B),
                            // height: 50.0, // height of the button
                            // width: 50.0, // width of the button
                            child: new Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                    ),
            )
                : Container(
                    child: Text(''),
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
        chartValueBackgroundColor: Colors.grey[100],
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
        // if (constraints.maxWidth >= 500) {
        //   return chart;
        // } else {
        return
            // SingleChildScrollView(
            // child:
            Container(
                child:
                    // _isData ?
                    chart
                //       : new Center(
                //   widthFactor: 100.0,
                //   heightFactor: 100.0,
                //   child: CircularProgressIndicator(),
                // ),
                // margin: EdgeInsets.symmetric(
                //   vertical: 32,
                // ),
                // ),
                );
        // }
      },
    );

    final macroFoodChart =
    Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // child: Container(
      //   margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChartLine(
              title: 'Protein ',
              number: valProtein,
              rate: roundDouble(valProtein / (baseProtein * 2), 1)),
          ChartLine(
              title: 'Crude Fat ',
              number: valCrudeFat,
              rate: roundDouble(valCrudeFat / (baseCrudeFat * 2), 1)),
        ],
      ),
      // ),
    );

    final microFoodChart = Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // child: FutureBuilder(
        // future: _future,
        // builder: (context, AsyncSnapshot<PET.PetFetch> snapshot) {
        //   switch (snapshot.connectionState) {
        //     case ConnectionState.none:
        //       return Text('No Data');
        //     case ConnectionState.waiting:
        //       return Center(child: CircularProgressIndicator());
        //     case ConnectionState.active:
        //       return Text('');
        //     case ConnectionState.done:
        //       if (snapshot.hasError) {
        //         return Text(
        //           '${snapshot.error}',
        //           style: TextStyle(color: Colors.red),
        //         );
        //       } else {
        //         return
        // margin: const EdgeInsets.symmetric(horizontal: 16.0),
        // child:
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ListView.builder(
            // shrinkWrap: true,
            // itemCount: snapshot.data.nutrientGuidelineDetail.length,
            // itemBuilder: (context, index) {
            //   return
            //     ChartLineSmall(
            //         title:
            //         snapshot.data.nutrientGuidelineDetail[index].name, //'Vitamin - A ',
            //        number: snapshot.data.nutrientGuidelineDetail[index].amount,
            //         rate: snapshot.data.nutrientGuidelineDetail[index].amount/);
            // ],
            // ),
            ChartLineSmall(
                title: 'Omega-6 ',
                number: valOmega6,
                rate: roundDouble(valOmega6 / (baseOmega6 * 2), 1)),
            ChartLineSmall(
                title: 'Omega-3 excl. ALA and SDA ',
                number: valOmega3exclALAandSDA,
                rate: roundDouble(
                    valOmega3exclALAandSDA / (baseOmega3exclALAandSDA * 2), 1)),
            ChartLineSmall(
                title: 'Calcium ',
                number: valCalcium,
                rate: roundDouble(valCalcium / (baseCalcium * 2), 1)),
            ChartLineSmall(
                title: 'Phosphorus ',
                number: valPhosphorus,
                rate: roundDouble(valPhosphorus / (basePhosphorus * 2), 1)),
            ChartLineSmall(
                title: 'Potassium ',
                number: valPotassium,
                rate: roundDouble(valPotassium / (basePotassium * 2), 1)),
            ChartLineSmall(
                title: 'Sodium (Na) ',
                number: valSodium,
                rate: roundDouble(valSodium / (baseSodium * 2), 1)),
            ChartLineSmall(
                title: 'Magnesium ',
                number: valMagnesium,
                rate: roundDouble(valMagnesium / (baseMagnesium * 2), 1)),
            ChartLineSmall(
                title: 'Iron ',
                number: valIron,
                rate: roundDouble(valIron / (baseIron * 2), 1)),
            ChartLineSmall(
                title: 'Copper ',
                number: valCopper,
                rate: roundDouble(valCopper / (baseCopper * 2), 1)),
            ChartLineSmall(
                title: 'Manganese ',
                number: valManganese,
                rate: roundDouble(valManganese / (baseManganese * 2), 1)),
            ChartLineSmall(
                title: 'Zinc (Zn) ',
                number: valZinc,
                rate: roundDouble(valZinc / (baseZinc * 2), 1)),
            ChartLineSmall(
                title: 'Iodine ',
                number: valIodine,
                rate: roundDouble(valIodine / (baseIodine * 2), 1)),
            ChartLineSmall(
                title: 'Selenium ',
                number: valSelenium,
                rate: roundDouble(valSelenium / (baseSelenium * 2), 1)),
            ChartLineSmall(
                title: 'Vitamin A ',
                number: valVitaminA,
                rate: roundDouble(valVitaminA / (baseVitaminA * 2), 1)),
            ChartLineSmall(
                title: 'Vitamin D ',
                number: valVitaminD,
                rate: roundDouble(valVitaminD / (baseVitaminD * 2), 1)),
            ChartLineSmall(
                title: 'Vitamin E ',
                number: valVitaminE,
                rate: roundDouble(valVitaminE / (baseVitaminE * 2), 1)),
            ChartLineSmall(
                title: 'Thiamin (B1) ',
                number: valThiaminB1,
                rate: roundDouble(valThiaminB1 / (baseThiaminB1 * 2), 1)),
            ChartLineSmall(
                title: 'Riboflavin (B2) ',
                number: valRiboflavinB2,
                rate: roundDouble(valRiboflavinB2 / (baseRiboflavinB2 * 2), 1)),
            ChartLineSmall(
                title: 'Niacin (B3) ',
                number: valNiacin,
                rate: roundDouble(valNiacin / (baseNiacin * 2), 1)),
            ChartLineSmall(
                title: 'Pantothenic acid (B5) ',
                number: valPantothenic,
                rate: roundDouble(valPantothenic / (basePantothenic * 2), 1)),
            ChartLineSmall(
                title: 'Folate ',
                number: valFolate,
                rate: roundDouble(valFolate / (baseFolate * 2), 1)),
            ChartLineSmall(
                title: 'Choline ',
                number: valCholine,
                rate: roundDouble(valCholine / (baseCholine * 2), 1)),
            // ChartLineSmall(title: 'Vitamin C ', number: valVitaminC, rate: roundDouble(valVitaminC/(baseVitaminC*2),1)),
          ],
        ),
      ),
    );
    //           }
    //       }
    //     },
    //   ),
    //   ),
    // );

    final macroRatioChart = Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ChartLineRatio(
              title: 'Calcium/Phosphorus ratio ',
              number: valCalciumPhosphorusRatio,
              rate: roundDouble(
                  valCalciumPhosphorusRatio / (baseCalciumPhosphorusRatio * 2),
                  1)),
          ChartLineRatio(
              title: 'Omega-3/6 ratio ',
              number: valOmega3_6Ratio,
              rate: roundDouble(valOmega3_6Ratio / (baseOmega3_6Ratio * 2), 1)),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
          //   child:
          //       // Row(
          //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       // crossAxisAlignment: CrossAxisAlignment.start,
          //       // children: [
          //       Text(
          //     'Calcium : Phosphorous Ratio = 2:1',
          //     style: TextStyle(
          //         fontSize: 16.0,
          //         color: Colors.black87,
          //         fontWeight: FontWeight.w400),
          //   ),
          //   // Spacer(),
          //   // Text(
          //   //   '2 : 1',
          //   //   style: TextStyle(
          //   //       fontSize: 16.0,
          //   //       color: Colors.black87,
          //   //       fontWeight: FontWeight.w500),
          //   // ),
          //   // ],
          //   // ),
          // ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   width: MediaQuery.of(context).size.width,
          //   child: LinearPercentIndicator(
          //     fillColor: Colors.transparent,
          //     backgroundColor: Colors.transparent,
          //     //Color(0xFF058EC9),
          //     animation: true,
          //     animationDuration: 1000,
          //     lineHeight: 30.0,
          //     percent: 2 / 3,
          //     //replace the main percentage value here with the calculated value from the API
          //     linearStrokeCap: LinearStrokeCap.butt,
          //     progressColor: Color(0xFF32BEFA),
          //   ),
          // ),
          // SizedBox(height: 8.0),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
          //   child:
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       //   crossAxisAlignment: CrossAxisAlignment.start,
          //       //   children: [
          //       Text(
          //     'Omega3 : Omega6 Ratio = 1:4',
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
          //     backgroundColor: Colors.transparent,
          //     //Color(0xFF058EC9),
          //     animation: true,
          //     animationDuration: 1000,
          //     lineHeight: 30.0,
          //     percent: 1 / 5,
          //     //replace the main percentage value here with the calculated value from the API
          //     linearStrokeCap: LinearStrokeCap.butt,
          //     progressColor: Color(0xFF32BEFA),
          //   ),
          // ),
        ],
      ),
    );

    final macroCharts = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            // padding: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width*0.95,
            color: Colors.transparent,
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.topLeft,
                //   child:
                Expanded(
                  flex: 1,
                  // child: Container(
                  //   alignment: Alignment.centerLeft,
                  //   margin: const EdgeInsets.all(
                  //     4.0,
                  //   ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    // ),
                  // ),
                ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child:
                Expanded(
                  flex: 4,
                  child:
                      // _isData ?
                      macroFoodChart,
                  //       : new Center(
                  //   widthFactor: 100.0,
                  //   heightFactor: 100.0,
                  //   child: CircularProgressIndicator(),
                  // ),
                ),
                // ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            // margin: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width*0.95,
            color: Colors.transparent,
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.topLeft,
                //   child:
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    // margin: const EdgeInsets.all(
                    //   4.0,
                    // ),
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Text(
                        'Ratios',
                        // update this unit according to the user's selection of unit
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black87,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  // ),
                ),
                // Align(
                //   alignment: Alignment.center,
                //   child:
                Expanded(
                  flex: 4,
                  child: macroRatioChart,
                ),
                // Container(
                //   child: Text('macroRatioChart'),
                // ),
                // ),
              ],
            ),
          // ),
        ),
        ),
      ],
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
            // padding: EdgeInsets.symmetric(horizontal: 12.0),
            width: MediaQuery.of(context).size.width*0.95,
            alignment: Alignment.centerLeft,
            // margin: const EdgeInsets.all(
            //   4.0,
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            // ),
          ),
        ),
        Expanded(
          flex: 9,
          child:
              // _isData ?
              Container(
            // margin: EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 12.0),
            // padding: EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child:
                // _isData ?
                microFoodChart,
            //       : new Center(
            //   widthFactor: 100.0,
            //   heightFactor: 100.0,
            //   child: CircularProgressIndicator(),
            // ),
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

    final userSaveBtn = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5.0),
      // alignment: Alignment.center,
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
        initialLabelIndex: _swapNutrients ? 0 : 1,
        activeBgColor: Color(0xFF03B898),
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey[300],
        inactiveFgColor: Colors.black54,
        labels: ['   Macro\nNutrients', '   Micro\nNutrients'],
        onToggle: (index) {
          print('switched to: $index');
          print('switched to: $_swapNutrients');
          setState(() {
            _swapNutrients = !_swapNutrients;
          });
        },
      ),
    );

    Widget swapTile() {
      return _swapNutrients ? macroCharts : microCharts;
    }

    // final userSaveBtn =
    //   Container(
    //     alignment: Alignment.center,
    //     width: MediaQuery.of(context).size.width,
    //     child:
    // //   Column(
    // // mainAxisAlignment: MainAxisAlignment.spaceAround,
    // // crossAxisAlignment: CrossAxisAlignment.center,
    // // children: <Widget>[
    //   ToggleButtons(
    //     color: Colors.grey[300],
    //     selectedColor: Color(0xFF03B898),
    //     fillColor: Color(0xFF03B898),
    //     splashColor: Color(0xFF03B898),
    //     highlightColor: Color(0xFF03B898),
    //     borderColor: Colors.white,
    //     borderWidth: 1,
    //     selectedBorderColor: Colors.white,
    //     renderBorder: true,
    //     borderRadius: BorderRadius.all(Radius.circular(5),),
    //     disabledColor: Colors.blueGrey,
    //     disabledBorderColor: Colors.blueGrey,
    //     focusColor: Color(0xFF03B898),
    //     focusNodes: focusToggle,
    //     // constraints: BoxConstraints(
    //     //   maxWidth: double.infinity,
    //     // ),
    //     children: <Widget>[
    //       Expanded(
    //         flex: 1,
    //         child: Container(
    //           width: 100.0,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text(
    //               'Macro\nNutrients',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 16,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //       ),
    //       Expanded(
    //         flex: 1,
    //         child: Container(
    //           width: 100.0,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Text(
    //               'Micro\nNutrients',
    //               style: TextStyle(
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.w600,
    //                 fontSize: 16,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //       ),
    //       // Icon(Icons.link),
    //     ],
    //     isSelected: isSelectedBtn,
    //     onPressed: (int index) {
    //       setState(() {
    //         for (int indexBtn = 0;
    //             indexBtn < isSelectedBtn.length;
    //             indexBtn++) {
    //           if (indexBtn == index) {
    //             isSelectedBtn[index] = !isSelectedBtn[index];
    //           } else {
    //             isSelectedBtn[indexBtn] = false;
    //           }
    //         }
    //       });
    //     },
    //   ),
    //   );
    // Container(
    //   decoration: BoxDecoration(
    //     color: Colors.black,
    //   ),
    //   // child: Column(
    //   //   children: <Widget>[
    //   // Text('TV remote'),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       RaisedButton(
    //         child: Text('Previous'),
    //         onPressed: () {
    //           FocusScope.of(context).requestFocus(focusNodeButtonMacro);
    //         },
    //       ),
    //       SizedBox(
    //         width: 2,
    //       ),
    //       RaisedButton(
    //         child: Text('Next'),
    //         onPressed: () {
    //           FocusScope.of(context).requestFocus(focusNodeButtonMicro);
    //         },
    //       ),
    //     ],
    //   ),
    //   //   ],
    //   // ),
    // )
    // ],
    // ),
    // );

    // final userSaveBtn =
    //     Padding(
    //       padding: EdgeInsets.all(2.0),
    //       child:
    //     Container(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       Expanded(
    //         flex: 1,
    //         child: new FlatButton(
    //           padding: EdgeInsets.all(4.0),
    //           minWidth: 100.0,
    //           color: Color(0xFF03B898),
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           onPressed: () => {
    //             // _handleSave(context),
    //           },
    //           child: new Text(
    //             'Micro \n Nutrients',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontWeight: FontWeight.w600,
    //               fontSize: 12,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //           // padding: EdgeInsets.all(2),
    //         ),
    //       ),
    //       SizedBox(width: 2.0),
    //       Expanded(
    //         flex: 1,
    //         child: FlatButton(
    //           padding: EdgeInsets.all(4.0),
    //           minWidth: 100.0,
    //           color: Colors.white,
    //           colorBrightness: Brightness.light,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(5),
    //             side: BorderSide(
    //               width: 2.0,
    //               color: Color(0xFF03B898),
    //             ),
    //           ),
    //           onPressed: () => {},
    //           child: new Text(
    //             'Macro \n Nutrients',
    //             style: TextStyle(
    //               color: Color(0xFF03B898),
    //               fontWeight: FontWeight.w600,
    //               fontSize: 12,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //           // padding: EdgeInsets.all(2),
    //         ),
    //       ),
    //     ],
    //   ),
    //   ),
    // );

    Widget _disclaimer() => Container(
          width: MediaQuery.of(context).size.width*0.96,
          // height: MediaQuery.of(context).size.height*0.90,
          padding: EdgeInsets.symmetric(horizontal: 12.0, ),
          margin: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Calorie Calculator',
                  style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'poppins',
                      color: Colors.black87,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              const Text(
                'The calorie calculator results are an estimate only. The condition of your dog is the best indicator of your dog’s energy requirements and must be monitored closely.',
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'poppins',
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.0),
              Container(
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () {
                    setState(() {
                      isFirst = true;
                    });
//          _handleSubmit(context);
//          Navigator.of(context).pushNamed(HomeScreen.tag);
                  },
                  padding: EdgeInsets.all(12),
                  color: Color(0xFF03B898),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'AGREED',
                      style: kMainHeadingStyleWhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // ),
              )
            ],
          ),
        );

    Widget body() =>
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 8.0, ),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                // color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      margin: const EdgeInsets.only(
                        left: 12.0,
                        top: 4.0,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: const Text(
                          'Food Weight',
                          style: TextStyle(
                              // fontSize: 24.0,
                              fontFamily: 'poppins',
                              color: Colors.black87,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    pieChart,
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              // child: Container(
              //   color: Colors.transparent,
              child: Container(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        child: userSaveBtn,
                        // ),
                        // ),
                        // ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          margin: EdgeInsets.only(top: 2.0),
                          width: MediaQuery.of(context).size.width,
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
            ),
          ],
          ),
        );

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final mainBody = Container(
      // margin: EdgeInsets.only(
      //   top: 16.0,
      // ),
      width: MediaQuery.of(context).size.width,
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
          // SizedBox(height: 32.0),
          Expanded(
            flex: 1,
            child: petHeader,
          ),
          Expanded(
            flex: 12,
            // child: Padding(
            //   padding: const EdgeInsets.all(0.0),
              child: !isFirst ? _disclaimer() : body(),
              // ? _disclaimer() : body(),
            // ),
          ),
          // lorem,
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: mainBody, //_isShowingDialog ? bodyWithDialog : bodyWithCharts
      ),
    );
  }
}

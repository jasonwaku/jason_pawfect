import 'dart:async';
import 'dart:convert';
import 'dart:io' as IO;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:mime/mime.dart';
import 'package:pawfect/models/pets/activity_level.dart';
import 'package:pawfect/models/pets/dog_breed.dart';
import 'package:pawfect/models/pets/pet_model.dart' as PET;
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/navigation/general_home_screen.dart';
import 'package:pawfect/screens/navigation/premium_home_screen.dart';
import 'package:pawfect/screens/navigation/pro_home_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';
// import 'package:pawfect/utils/ri_keys.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/utility.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetRegistrationScreen extends StatefulWidget {
  static String tag = 'pet-registration-page';

  @override
  _PetRegistrationScreenState createState() => _PetRegistrationScreenState();
}

class _PetRegistrationScreenState extends State<PetRegistrationScreen> {
//
  List<String> _breeds = [
    'Airedale Terrier',
    'American Bulldog',
    'American Foxhound',
    'AussieDoodle',
    'Australian Shepherd Husky',
    'Beagle',
    'Bloodhound',
    'Boxer',
    'German Shepherd',
    'Husky',
    'really really long dog breed name goes here..'
  ];
  String _selectedBreed;
  String _breedApiUrl;
  String _dogBreed;
  List breedData = List();

  // List<DogBreed> _breeds = List();

  List<String> _activityLevel = [
    'Beginner',
    'Junior',
    'Intermediate',
    'Moderate',
    'Energetic',
    'Hyperactive',
    'Inactive'
  ];
  String _selectedActivityLevel;
  String _activityLevelApiUrl;
  String _activityLevels;
  List activityLvlData = List();

  // int _sliderAgeValue = 1;
  // int _sliderWeightValue = 1;
  // int _sliderIdealWeightValue = 1;
  bool isSwitchedSex = false;
  bool isSwitchedEatBones = false;
  bool isSwitchedUnit = true;
  String birthDateInString;
  String bdDate;
  String bdMonth;
  String bdYear;
  DateTime birthDate; // instance of DateTime
  bool isDateSelected = false;
  String initValue = 'Birth/Gotcha Date';

  // int _weightRadioUnit = 0;
  bool _isLoading = false;

  // final TextEditingController _weightController = new TextEditingController();
  // double _resultInKg = 0.0;
  // double _inputInLb = 0.0;
  // String _textResult = '';

  //
  String _petImage;

  // String _imagePath;
  String _petName;
  String _petAge;
  String _petBreed;
  String _petWeight;
  String _petIdealWeight;
  String _petActivityLevel;
  String _petSex;
  String _petEatBone;
  String _petBirthDate;

  bool _isSubscribed;

  //
  final GlobalKey<FormState> _petRegisterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController petNameController = new TextEditingController();
  TextEditingController petAgeController = new TextEditingController();
  TextEditingController petWeightController = new TextEditingController();
  TextEditingController petIdealWeightController = new TextEditingController();

  //
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _ageFocusNode = FocusNode();
  FocusNode _breedFocusNode = FocusNode();
  FocusNode _weightFocusNode = FocusNode();

  // FocusNode _idealWeightFocusNode = FocusNode();
  // FocusNode _lifeStageFocusNode = FocusNode();
  FocusNode _activityLevelFocusNode = FocusNode();

  // FocusNode _birthDateFocusNode = FocusNode();
  FocusNode _sexFocusNode = FocusNode();

  // FocusNode _eatBoneFocusNode = FocusNode();

  //image ImagePicker
  File _imageURI;
  final picker = ImagePicker();

  // Image imageFromPrefs;
  SharedPreferences userPrefs;
  SharedPreferences petPrefs;
  String _inputUnit = 'kg';
  bool _imperial = false;
  String userToken = '';
  String userEmail = '';
  String userID= '';
  bool userSubscribed = false;
  bool userImperial = false;

  PET.Pet petData;
  UserCreate _userData;

  PET.PetCreate _pet;
  UserCreate _user;

  bool _autoValidate = false;
  ProgressDialog pr;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

//  final picker = ImagePicker();

  @override
  void initState() {
    //
    super.initState();
    // _setInitialValues();
    _getUserInfo();
  }

  // _setInitialValues() async{
  //   // isSwitched ? _inputUnit = 'kg' : _inputUnit = 'lb';
  //   isSwitchedUnit = true;
  //   //
  //   _dogBreedList =  await _fetchDogBreeds();
  //   _activityLevelList =  await _fetchActivityLevels();
  // }

  List<DogBreed> _dogBreedList = new List<DogBreed>();
  List<ActivityLevel> _activityLevelList = new List<ActivityLevel>();

  Future<List<DogBreed>> _fetchDogBreeds() async {
    //
    setState(() {
      _isLoading = true;
    });

    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/dog_breed.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      _dogBreedList = dogBreedFromJson(response.body);
      // pr.hide();
      return _dogBreedList;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    // final response = await CallApi().getData(_breedApiUrl);
    // if (response.statusCode == 200) {
    //   // If the call to the server was successful, parse the JSON
    //   List<dynamic> values = new List<dynamic>();
    //   values = json.decode(response.body);
    //   if (values.length > 0) {
    //     for (int i = 0; i < values.length; i++) {
    //       if (values[i] != null) {
    //         Map<String, dynamic> map = values[i];
    //         _dogBreedList.add(DogBreed.fromJson(map));
    //         debugPrint('Id-------${map['id']}');
    //         debugPrint('name-------${map['name']}');
    //       }
    //     }
    //   }
    //   return _dogBreedList;
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('Failed to load data');
    // }
  }

  Future<List<ActivityLevel>> _fetchActivityLevels() async {
    //
    setState(() {
      _isLoading = true;
    });

    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/activity_level.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      _activityLevelList = activityLevelFromJson(response.body);
      // pr.hide();
      return _activityLevelList;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    // final response = await CallApi().getData(_activityLevelApiUrl);
    // if (response.statusCode == 200) {
    //   // If the call to the server was successful, parse the JSON
    //   List<dynamic> values = new List<dynamic>();
    //   values = json.decode(response.body);
    //   if (values.length > 0) {
    //     for (int i = 0; i < values.length; i++) {
    //       if (values[i] != null) {
    //         Map<String, dynamic> map = values[i];
    //         _activityLevelList.add(ActivityLevel.fromJson(map));
    //         debugPrint('Id-------${map['id']}');
    //         debugPrint('name-------${map['name']}');
    //       }
    //     }
    //   }
    //   return _activityLevelList;
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('Failed to load data');
    // }
  }

  void _showSnackbar(String msg, Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  _getUserInfo() async {
    SharedPreferences userViewPrefs = await SharedPreferences.getInstance();
    var userJson = userViewPrefs.getString('user_data');
    // var user = json.decode(userJson);
    userToken = userViewPrefs.getString('user_token');
    userEmail = userViewPrefs.getString('user_email');
    userID = userViewPrefs.getString('user_id');
    userSubscribed = userViewPrefs.getBool('user_subscribed');
    userImperial = userViewPrefs.getBool('user_imperial');
    print(userToken);
    print(userEmail);
    print(userID);

    _breedApiUrl =
        'breeds/fetch_all?user_email=$userEmail&user_token=$userToken';
    _activityLevelApiUrl =
        'activity_levels/fetch_all?user_email=$userEmail&user_token=$userToken';

    //
    // isSwitchedUnit = true;
    //
    _dogBreedList =  await _fetchDogBreeds();
    _activityLevelList =  await _fetchActivityLevels();
    // await _fetchDogBreeds();
    // await _fetchActivityLevels();
    // updateView();
  }

  onChangeDropdownItemBreed(selectedBreed) {
    setState(() {
      // fieldFocusChange(context, _breedFocusNode, _weightFocusNode);
      _selectedBreed = selectedBreed;
      // _petBreed = _dogBreed;
    });
  }

  onChangeDropdownItemActivityLevel(selectedActivityLevel) {
    setState(() {
      fieldFocusChange(context, _activityLevelFocusNode, _sexFocusNode);
      _selectedActivityLevel = selectedActivityLevel;
      // _petActivityLevel = _selectedActivityLevel;
    });
  }

//  void _handleWeightRadioChange(int value) {
//    setState(() {
//      _weightRadioUnit = value;
//      switch (_weightRadioUnit) {
//        case 0:
////         do nothing
//          break;
//        case 1:
////          convert to kg
//          //value from the textField
//          _resultInKg = _inputInLb * (453.6) / 1000;
//          break;
//      }
//    });
//  }

//  num getMass(num val, bool isInKg) => isInKg?val:((val*453.6)/1000);
  //covert of pounds to KG here

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // image selection bottom sheet //
  void _imageSelectionBtmSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        alignment: Alignment.center,
        height: 260,
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
          // color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Container(
//                  child: new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  color: Color(0xFF01816B),
//                    width: MediaQuery.of(context).size.width,
                  child: new FlatButton(
                    colorBrightness: Brightness.light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => _getImageFromGallery(),
                    child: new Text(
                      'Select from Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
//                          ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  color: Color(0xFF01816B),
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => _getImageFromCamera(),
                    child: new Text(
                      'Take from Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
//                        ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width*0.75,
                  color: Colors.white,//Color(0xFF01816B),
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
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
//                        ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  //image picker from camera
  Future _getImageFromCamera() async {
    //using this method of getting an image
//     final File pickedFile =
//         (await picker.getImage(source: ImageSource.camera)) as File;
// //
//     if (pickedFile == null) return;
// //
//     File tempFile = File(pickedFile.path);
//     tempFile = await tempFile.copy(tempFile.path);
    //
    PickedFile petImage = await picker.getImage(source: ImageSource.camera,maxHeight: 1000);
    // Utility.saveImageToPreferences(
    //     Utility.base64String(petImage.readAsBytesSync()));
    //convert the image to base 64 string value
//     final bytes = IO.File(pickedFile.path).readAsBytesSync();
// //
//     _petImage = base64Encode(bytes);
//     print(_petImage.substring(0, 100));
    //_petImage = Utility.base64String(pickedFile.readAsBytesSync());
    // );

    setState(() {
      // if (pickedFile != null) {
      _imageURI = File(petImage.path);
      print(_imageURI.toString());
      print(_imageURI.path); //File(pickedFile.path);
      print(_imageURI.toString().split('/'));
      var str = _imageURI.path.toString().split('/');
      print(str[str.length - 1]);
      print(Image.file(File(_imageURI.path)));
      // } else {
      //   print('No image selected.');
    }
        // _imageURI = tempFile;
        // print(_imageURI.path);
        );

    Navigator.pop(context);
  }

//image picker from Gallery
  Future _getImageFromGallery() async {
    var petImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    // Utility.saveImageToPreferences(
    //     Utility.base64String(petImage.readAsBytesSync()));
    setState(() {
      _imageURI = petImage;
      print(_imageURI.path);
    });

    Navigator.pop(context);
  }

  // Subscription bottom Sheet //
  void _subscriptionBtmSheet() {
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
//                  child: new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
          margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    'Subscribe to',
                    style: TextStyle(
                      color: Color(0xFF03B898),
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w500,
                      // fontSize: 24.0,
                    ),
                  ),
                ),
              ),
//              SizedBox(height: 12.0),
              Expanded(
                flex: 4,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    'Premium',
                    style: TextStyle(
                      color: Color(0xFF03B898),
                      // fontSize: 48.0,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
//              SizedBox(height: 12.0),
              Expanded(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    'Try Premium for only \$4.49/month for \n 12 months OR \$6.49/month for 3 months',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF03B898),
                      // fontSize: 16.0,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 12.0),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
              //   child:
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                              _isSubscribed = false;
                              _isLoading ? null : _handleSubmitUser(context);
                            },
                            child: new Text(
                              'Later',
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
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                              _isSubscribed = true;
                              _isLoading ? null : _handleSubmitUser(context);
                            },
                            child: new Text(
                              'Okay',
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
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGeneralHomeScreen() {
    Navigator.of(context).push(PageTransition(
      child: GeneralHomeScreen(),
      type: PageTransitionType.rightToLeft,
    ));
  }

  void _navigateToPremiumHomeScreen() {
    Navigator.of(context).push(PageTransition(
      child: ProHomeScreen(),
      type: PageTransitionType.rightToLeft,
    ));
  }

//   Future<void> _handleSubmit(BuildContext context) async {
//     Navigator.pop(context);
//     try {
//       petPrefs = await SharedPreferences.getInstance();
//       petPrefs.setString('pet-name', _petName);
//       LoadingDialog.showLoadingDialog(context, _petFormKey); //invoking login
// //    await service.login(user.uid);
//     _setNavigation();
//       //
//     } catch (error) {
//       print(error);
//     }
//   }

//   void _setNavigation() {
//     Timer(Duration(seconds: 3), () {
//       Navigator.of(_petRegisterFormKey.currentContext, rootNavigator: true)
//           .pop(); //close the dialog
//       //Navigator.pushReplacementNamed(context, "/home");
//       _isSubscribed
//           ? _navigateToPremiumHomeScreen()
//           : _navigateToGeneralHomeScreen();
//       // _navigateToHomeScreen();
// //      Navigator.of(context).pushNamed(HomeScreen.tag);
//     });
//   }

  Future<void> _handleSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context);//,_petRegisterFormKey);
    pr.show();
    // updateUserData();
    String bdate = DateFormat("dd-MMMM-yyyy").format(birthDate);
    print(bdate);

    // prepare file to send.
    var profilePhoto;
    String base64Image;
    if(_imageURI != null) {
      //
      // Get file path
      // eg:- "Volume/VM/abcd.jpeg"
      final filePath = _imageURI.absolute.path;

      // Create output file path
      // eg:- "Volume/VM/abcd_out.jpeg"
      final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          filePath,
          outPath,
          minWidth: 1000,
          minHeight: 1000,
          quality: 70);
      //
      List<int> imageBytes = compressedImage.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
      ///Splits the path and returns only the filename and type
      // final mimeTypeData =lookupMimeType(_imageURI.path, headerBytes: [0xFF, 0xD8]).split('/');
      // print(mimeTypeData);
      // final file = await http.MultipartFile.fromPath('image', _imageURI.path,contentType: MediaType(mimeTypeData[0], mimeTypeData[1]), filename: _imageURI.path);
      // print(file);
      // profilePhoto = http.MultipartFile(
      //     'upload', _imageURI.readAsBytes().asStream(), _imageURI.lengthSync(),
      //     filename: _imageURI.path);
      // print(profilePhoto);
      // print(profilePhoto.toString());
      // request.files.add(profilePhoto);
    }else{
      profilePhoto = 'image';
    }
    print(
        '......................................save pet data called........................................');
    // petData = new Pet(
    //   petImage: _petImage != null ? '' : _petImage,
    //   name: petNameController.text,
    //   petAge: petAgeController.text,
    //   petBreed: _petBreed,
    //   weight: petWeightController.text,
    //   ideal_weight: petIdealWeightController.text,
    //   petActivityLevel: _petActivityLevel,
    //   petSex: _petSex,
    //   eatbone: _petEatBone,
    //   petBirthDate: _petBirthDate,
    // );
    // savePetPreferences(petData).then((bool committed) {
    //   _setNavigation();
    //   // Navigator.of(context).popAndPushNamed(PetProfileScreen.tag);
    // });
// saving dog registration data
    var dogData = {
      'user_email': userEmail,
      'user_token': userToken,
      'pet': {
        "age": petAgeController.text,
        "birth_date": bdate,
        'eatbone': isSwitchedEatBones.toString(),
        'ideal_weight': petIdealWeightController.text,
        'image': base64Image,
        'name': petNameController.text,
        "sex": _petSex,
        'weight': petWeightController.text,
        'guideline_id': '1',
        'activity_level_id': _selectedActivityLevel,
        'breed_id': _selectedBreed,
        'user_id': userID,
      }
    };

    // final PET.PetCreate
    final pet = await CallApi().createThePet(dogData, 'pets/create');
    if (pet != null) {
      if (pet.success) {
        setState(() {
          _pet = pet;
        });
        print('///////////////////////// success //////////////////////////');
        petPrefs = await SharedPreferences.getInstance();
        petPrefs.remove('pet_image');
        petPrefs.remove('pet_id');
        petPrefs.remove('pet_name');
        petPrefs.remove('pet_age');
        //
        petPrefs.setString('pet_image', _pet.pet.image.thumb.url);
        // petPrefs.setString('pet_data', json.encode(_pet.pet));
        // localStoragePet.setString('petImage', _petImage);
        //todo do not save data locally even they are not passed in the API. keep them blank till that get resolved
        // petPrefs.setString('petActivityLevel', _petActivityLevel);
        // petPrefs.setString('petBreed', _petBreed);
        // petPrefs.setString('petAge', petAgeController.text);
        // petPrefs.setString('petBDate', _petBirthDate);
        // petPrefs.setString('petSex', _petSex);
        // petPrefs.setString('inputUnit', _inputUnit);
        petPrefs.setString('pet_id', _pet.pet.id.toString());
        petPrefs.setString('pet_name', _pet.pet.name.toString());
        petPrefs.setString('pet_age', _pet.pet.age.toString());
        // petPrefs.setString('pet_bdate', birthDateInString);

        // print('pet image : ' + _pet.pet.image.thumb.url);
        print('petId' + _pet.pet.id.toString());
        // print('pet json: ' + json.encode(_pet.pet));
        // print('pet name : ' + _pet.pet.name);
        // print('pet id : ' + _pet.pet.id.toString());
        // print(_petImage +
        //     ' | ' +
        //     _petActivityLevel +
        //     ' | ' +
        //     _petBreed +
        //     ' | ' +
        //     petAgeController.text +
        //     ' | ' +
        //     _petBirthDate);
        //
        // _subscriptionBtmSheet();
        // _setNavigation();
        //
        // }
        pr.hide().whenComplete(() {
          _showSnackbar('Successfully Updated.!', successAPI);
          if(userSubscribed){
            _isSubscribed = true;
            _handleSubmit(context);
          }else{
            _subscriptionBtmSheet();
          }
        });
      } else {
        String msg = pet.message;
        print(msg);
        setState(() {
          _isLoading = false;
        });
        pr.hide().whenComplete(() {
          _showSnackbar(msg, errorAPI);
        });
      }
      // Navigator.pop(context);
      // showScaffold('nnnnnn');
    } else {
      setState(() {
        _isLoading = false;
      });
      pr.hide().whenComplete(() {
        _showSnackbar('A Network Error Occurred.!', errorNet);
      });
    }
//  print(body);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _handleSubmitUser(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context);//,_petRegisterFormKey);
    // await updateUserData();
    //user data load from the local storage
    // userPrefs.setBool('user_imperial', _inputUnit)

    //
    pr.show();
    var userData = {
      'user_email': userEmail,
      'user_token': userToken,
      'user': {
        'imperial': (_inputUnit == 'kg' ? false : true).toString(),
        'subscribed': _isSubscribed.toString(),
      }
    };

    // final UserCreate user =
    final user = await CallApi().updateTheUser(userData, 'users/update');
    if (user != null) {
      if (user.success) {
        setState(() {
          _user = user;
        });

        // if (_user.success) {
        //for local reference
        userPrefs = await SharedPreferences.getInstance();
        userPrefs.remove('user_subscribed');
        userPrefs.remove('user_imperial');
        //
        userPrefs.setBool('user_subscribed', _user.user.subscribed);
        userPrefs.setBool('user_imperial', _user.user.imperial);
        //
        print('user json: ' + json.encode(_user.user));
        pr.hide();
          //   .whenComplete(() {
          // Navigator.of(_petRegisterFormKey.currentContext, rootNavigator: true)
          //     .pop(); //close the dialog
          //Navigator.pushReplacementNamed(context, "/home");
          _isSubscribed
              ? _navigateToPremiumHomeScreen()
              : _navigateToGeneralHomeScreen();
          //_setNavigation();
        // });
      } else {
        String msg = user.message;
        print(msg);
        setState(() {
          _isLoading = false;
        });
        pr.hide().whenComplete(() {
          _showSnackbar(msg, errorAPI);
        });
      }
      // _showScaffold('nnnnnn');
    } else {
      setState(() {
        _isLoading = false;
      });
      pr.hide().whenComplete(() {
        _showSnackbar('A Network Error Occurred.!', errorNet);
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  AlertDialog buildAlertDialog(String message) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: kMainContentStyleDarkBlack,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            // ignore: unnecessary_statements
            // Navigator.of(context).pop;
          },
        ),
      ],
    );
  }

//   savePetData() async {
// //     String bdate = DateFormat("dd-MMMM-yyyy").format(birthDate);
// //     print(bdate);
// //
// //     // prepare file to send.
// //     var profilePhoto = http.MultipartFile(
// //         'upload', _imageURI.readAsBytes().asStream(), _imageURI.lengthSync(),
// //         filename: _imageURI.path);
// //     print(profilePhoto);
// //     print(profilePhoto.toString());
// //     // request.files.add(profilePhoto);
// //
// //     print(
// //         '......................................save pet data called........................................');
// //     // petData = new Pet(
// //     //   petImage: _petImage != null ? '' : _petImage,
// //     //   name: petNameController.text,
// //     //   petAge: petAgeController.text,
// //     //   petBreed: _petBreed,
// //     //   weight: petWeightController.text,
// //     //   ideal_weight: petIdealWeightController.text,
// //     //   petActivityLevel: _petActivityLevel,
// //     //   petSex: _petSex,
// //     //   eatbone: _petEatBone,
// //     //   petBirthDate: _petBirthDate,
// //     // );
// //     // savePetPreferences(petData).then((bool committed) {
// //     //   _setNavigation();
// //     //   // Navigator.of(context).popAndPushNamed(PetProfileScreen.tag);
// //     // });
// // // saving dog registration data
// //     var dogData = {
// //       'user_email': userEmail,
// //       'user_token': userToken,
// //       'pet': {
// //         "age": petAgeController.text,
// //         "birth_date": bdate,
// //         'eatbone': isSwitchedEatBones.toString(),
// //         'ideal_weight': petIdealWeightController.text,
// //         'image': profilePhoto.toString(),
// //         'name': petNameController.text,
// //         "sex": _petSex,
// //         'weight': petWeightController.text,
// //         'guideline_id': '1',
// //         'activity_level_id': _selectedActivityLevel,
// //         'breed_id': _selectedBreed,
// //         'user_id': userID,
// //       }
// //     };
// //
// //     // final PET.PetCreate
// //     final pet = await CallApi().createThePet(dogData, 'pets/create');
// //     if (pet != null) {
// //       if (pet.success) {
// //         setState(() {
// //           _pet = pet;
// //         });
// //         print('///////////////////////// success //////////////////////////');
// //         petPrefs = await SharedPreferences.getInstance();
// //         petPrefs.setString('pet_image', _pet.pet.image.thumb.url);
// //         // petPrefs.setString('pet_data', json.encode(_pet.pet));
// //         // localStoragePet.setString('petImage', _petImage);
// //         //todo do not save data locally even they are not passed in the API. keep them blank till that get resolved
// //         // petPrefs.setString('petActivityLevel', _petActivityLevel);
// //         // petPrefs.setString('petBreed', _petBreed);
// //         // petPrefs.setString('petAge', petAgeController.text);
// //         // petPrefs.setString('petBDate', _petBirthDate);
// //         // petPrefs.setString('petSex', _petSex);
// //         petPrefs.setString('inputUnit', _inputUnit);
// //         petPrefs.setString('pet_id', _pet.pet.id.toString());
// //         petPrefs.setString('pet_name', _pet.pet.name.toString());
// //         petPrefs.setString('pet_age', _pet.pet.age.toString());
// //         petPrefs.setString('pet_bdate', birthDateInString);
// //
// //         // print('pet image : ' + _pet.pet.image.thumb.url);
// //         print('petId' + _pet.pet.id.toString());
// //         // print('pet json: ' + json.encode(_pet.pet));
// //         // print('pet name : ' + _pet.pet.name);
// //         // print('pet id : ' + _pet.pet.id.toString());
// //         // print(_petImage +
// //         //     ' | ' +
// //         //     _petActivityLevel +
// //         //     ' | ' +
// //         //     _petBreed +
// //         //     ' | ' +
// //         //     petAgeController.text +
// //         //     ' | ' +
// //         //     _petBirthDate);
// //         //
// //         // _subscriptionBtmSheet();
// //         // _setNavigation();
// //         //
// //       // }
// //     } else {
// //       Navigator.of(context).pop();
// //       String msg = pet.message;
// //       print(msg);
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       // var snackbar = new SnackBar(
// //       //   content: new Text("Cars enabled"),
// //       //   backgroundColor: Colors.white,
// //       //   duration: new Duration(seconds: 2),
// //       // );
// //       Scaffold.of(context).showSnackBar(SnackBar(
// //         content: new Text("Cars enabled"),
// //         backgroundColor: Colors.red,
// //         duration: new Duration(seconds: 2),
// //       ));
// //       // _showScaffold('jjjjjjj \n$msg');
// //       // buildAlertDialog('An Error Occurred. \n$msg' ); //\n$msg'
// //     }
// //     Navigator.pop(context);
// //     // showScaffold('nnnnnn');
// //   } else {
// //   Navigator.pop(context);
// //   // _showScaffold('ooooooo');
// //   // buildAlertDialog('A Network Error Occurred.' );
// //   }
// //     Navigator.pop(context);
//     // _showScaffold('nnnnnn');
//   }
//
//   updateUserData() async {
//     // //user data load from the local storage
//     //
//     // //
//     // var userData = {
//     //   'user_email': userEmail,
//     //   'user_token': userToken,
//     //   'user': {
//     //     'imperial': (_inputUnit == 'kg' ? false : true).toString(),
//     //     'subscribed': _isSubscribed.toString(),
//     //   }
//     // };
//     //
//     // // final UserCreate user =
//     // final user = await CallApi().updateTheUser(userData, '/users/update');
//     // if (user != null) {
//     //   if (user.success) {
//     //     setState(() {
//     //       _user = user;
//     //     });
//     //
//     //     // if (_user.success) {
//     //     //for local reference
//     //     userPrefs = await SharedPreferences.getInstance();
//     //     userPrefs.setString(
//     //         'user_subscribed', _user.user.subscribed.toString());
//     //     userPrefs.setString('user_imperial', _user.user.imperial.toString());
//     //     print('user json: ' + json.encode(_user.user));
//     //     Navigator.pop(context);
//     //     _setNavigation();
//     //   } else {
//     //     Navigator.of(context).pop();
//     //     String msg = user.message;
//     //     print(msg);
//     //     setState(() {
//     //       _isLoading = false;
//     //     });
//     //     // var snackbar = new SnackBar(
//     //     //   content: new Text("Cars enabled"),
//     //     //   backgroundColor: Colors.white,
//     //     //   duration: new Duration(seconds: 2),
//     //     // );
//     //     Scaffold.of(context).showSnackBar(SnackBar(
//     //       content: new Text("Cars enabled"),
//     //       backgroundColor: Colors.red,
//     //       duration: new Duration(seconds: 2),
//     //     ));
//     //     // buildAlertDialog("An Error Occurred \n$msg");
//     //   }
//     //   Navigator.pop(context);
//     //   // _showScaffold('nnnnnn');
//     // } else {
//     //   Navigator.pop(context);
//     // }
//     // Navigator.pop(context);
//   }

  Future<bool> savePetPreferences(PET.Pet pet) async {
    petPrefs = await SharedPreferences.getInstance();
    String petJson = jsonEncode(pet.toJson()); //userPrefs.getString('user');
    // Map decodeOptions = jsonDecode(userJson);
    // String user = jsonEncode(User.fromJson(decodeOptions));
    petPrefs.setString('petData', petJson);
    print(petJson);
    return petPrefs.commit();
  }

  @override
  Widget build(BuildContext context) {
    //
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      // textDirection: TextDirection.ltr,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );
    //
    pr.style(
      message:
      'Please Wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontFamily: 'poppins', fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 24.0, fontFamily: 'poppins', fontWeight: FontWeight.w600),
    );
    //// pet name ////
    final petName = TextFormField(
      inputFormatters: [
        new LengthLimitingTextInputFormatter(15),
      ],
      keyboardType: TextInputType.name,
      autofocus: true,
      controller: petNameController,
      focusNode: _nameFocusNode,
      validator: validateNameDog,
      onSaved: (String value) {
        _petName = value;
      },
      // onFieldSubmitted: (_) {
      //   fieldFocusChange(context, _nameFocusNode, _ageFocusNode);
      // },
//      initialValue: 'alucard@gmail.com',
      style: kMainContentStyleLightBlack,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        filled: true,
        fillColor: Color(0xFFF0F0F0),
        hintText: "enter your dog's name",
        labelText: 'Dog Name',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// pet age ////
    final petAge = Container(
      width: 100,
      child: TextFormField(
        controller: petAgeController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}?$')),
          new LengthLimitingTextInputFormatter(2),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        focusNode: _ageFocusNode,
        validator: validateNumber,
        onSaved: (String value) {
          _petAge = value; //int.parse(value);
        },
        // onFieldSubmitted: (_) {
        //   fieldFocusChange(context, _ageFocusNode, _breedFocusNode);
        // },
//      initialValue: 'alucard@gmail.com',
        style: kMainContentStyleLightBlack,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          ),
          filled: true,
          fillColor: Color(0xFFF0F0F0),
          hintText: "age",
          labelText: 'Age',
          hintStyle: TextStyle(color: Colors.black45),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );

    //// pet weight ////
    final petWeight = Container(
      // width: 120,
      child: TextFormField(
        controller: petWeightController,
        inputFormatters: [
          new LengthLimitingTextInputFormatter(5),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: false,
        // focusNode: _weightFocusNode,
        validator: validateNumberDecimal,
        onSaved: (String value) {
          _petWeight = value; //double.parse(value);
        },
        // onFieldSubmitted: (_) {
        //   fieldFocusChange(context, _weightFocusNode, _idealWeightFocusNode);
        // },
//      initialValue: 'alucard@gmail.com',
        style: kSubContentStyleBlack,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          ),
          filled: true,
          fillColor: Color(0xFFF0F0F0),
          hintText: "weight",
          labelText: 'Weight',
          hintStyle: TextStyle(color: Colors.black45),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );

    //// pet ideal weight ////
    final petIdealWeight = Container(
      // width: 120,
      child: TextFormField(
        controller: petIdealWeightController,
        inputFormatters: [
          new LengthLimitingTextInputFormatter(5),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: false,
        // focusNode: _weightFocusNode,
        validator: validateNumberDecimal,
        onSaved: (String value) {
          _petIdealWeight = value; //double.parse(value);
        },
        // onFieldSubmitted: (_) {
        //   fieldFocusChange(context, _idealWeightFocusNode, _birthDateFocusNode);
        // },
//      initialValue: 'alucard@gmail.com',
        style: kSubContentStyleBlack,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1.0),
          ),
          filled: true,
          fillColor: Color(0xFFF0F0F0),
          hintText: "ideal weight",
          labelText: 'IdealWeight',
          hintStyle: TextStyle(
            color: Colors.black45,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );

    final weightUnit = Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 4.0),
      child: Text(
        _inputUnit,
        style: kMainContentStyleLightBlack,
      ),
    );

    //// pet sex ////
    final genderToggle = Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Select Sex',
                style: kMainContentStyleLightBlack,
              ),
            ),
            Container(
              height: 36.0,
              child: LiteRollingSwitch(
                value: true,
                textOn: 'Male',
                textOff: 'Female',
                textSize: 16.0,
                colorOn: Color(0xFF03B898),
                colorOff: Color(0xFF01816B),
                iconOn: Icons.pets,
                iconOff: Icons.pets,
                onChanged: (bool state) {
                  print('turned ${(state) ? 'male' : 'female'}');
                  isSwitchedSex = state;
                  print(isSwitchedSex.toString());
                  isSwitchedSex ? _petSex = 'male' : _petEatBone = 'female';
                  // _petSex = isSwitched.toString();
//                  fieldFocusChange(context, _sexFocusNode, _eatBoneFocusNode);
                },
              ),
            ),
          ],
        ),
      ),
    );

    //// pet eat bones ////
    final eatBonesToggle = Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Does your dog eat bones?',
                style: kMainContentStyleLightBlack,
              ),
            ),
            Container(
              height: 36.0,
              child: LiteRollingSwitch(
                value: true,
                textOn: 'Yes',
                textOff: 'No',
                textSize: 16.0,
                colorOn: Color(0xFF03B898),
                colorOff: Color(0xFF01816B),
                iconOn: Icons.check_circle_outline,
                iconOff: Icons.remove_circle,
                onChanged: (bool state) {
                  print('turned ${(state) ? 'yes' : 'no'}');
                  isSwitchedEatBones = state;
                  print(isSwitchedEatBones.toString());
                  isSwitchedEatBones ? _petEatBone = 'Yes' : _petEatBone = 'No';
                  // _petEatBone = isSwitched.toString();
//                  fieldFocusChange(context, _countryFocusNode);
                },
              ),
            ),
          ],
        ),
      ),
    );

    //// pet weight unit ////
    final weightUnitToggle = Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(
          //   flex: 1,
          //   child:
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Weight Units',
              style: kMainContentStyleLightBlack,
            ),
          ),
          // ),
          // Expanded(
          //   flex: 1,
          Container(
            height: 36.0,
            child: LiteRollingSwitch(
              value: isSwitchedUnit ? true : false,
              textOn: 'Metric',
              textOff: 'Imperial',
              textSize: 16.0,
              colorOn: Color(0xFF03B898),
              colorOff: Color(0xFF01816B),
              iconOn: Icons.arrow_left,
              iconOff: Icons.arrow_right,
              onChanged: (bool state) {
                Future.delayed(Duration.zero, () async {
                  print('turned ${(state) ? 'metric' : 'imperial'}');
                  isSwitchedUnit = state;
                  print(isSwitchedUnit.toString());
                  setState(() {
                    isSwitchedUnit ? _inputUnit = 'kg' : _inputUnit = 'lb';
                  });
                });
                // _petEatBone = isSwitched.toString();
//                  fieldFocusChange(context, _countryFocusNode);
              },
              // ),
            ),
          ),
        ],
      ),
      //     ),
      //   ],
      // ),
    );

    final weightUnitRadio = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Radio(
            value: 0,
            groupValue: 'metric',
            onChanged: (_) {
              setState(() {
                _inputUnit = 'kg';
              });
            },
          ),
          new Text(
            'Metric',
            style: new TextStyle(fontSize: 16.0),
          ),
          new Radio(
            value: 1,
            groupValue: 'imperial',
            onChanged: (_) {
              setState(() {
                _inputUnit = 'lb';
              });
            },
          ),
          new Text(
            'Imperial',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );

    //// pet birth date ////
    final birthDatePicker = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
//        Text('Select Birth Date'),
          Text(
            isDateSelected
                ? "Birth/Gotcha On ${DateFormat('dd-MMMM-yyyy').format(birthDate)}"
                : initValue,
            style: kMainContentStyleLightBlack,
          ),
          GestureDetector(
              child: new Icon(
                Icons.calendar_today,
                size: 32.0,
                color: Color(0xFF03B898),
              ),
              onTap: () async {
                final datePick = await showDatePicker(
                    context: context,
                    initialDate: new DateTime.now(),
                    firstDate: new DateTime(1900),
                    lastDate: new DateTime(2100));
                if (datePick != null && datePick != birthDate) {
                  setState(() {
//                  fieldFocusChange(context, _birthDateFocusNode, _sexFocusNode);
                    birthDate = datePick;
                    isDateSelected = true;
                    birthDateInString =
                        "${birthDate.month}/${birthDate.day}/${birthDate.year}";
                    print(birthDateInString);
                    _petBirthDate = birthDateInString; // 08/14/2019
                    bdDate = birthDate.day.toString();
                    bdMonth = birthDate.month.toString();
                    bdYear = birthDate.year.toString();
                  });
                }
              }),
        ],
      ),
    );

    //// pet breed ////
    final breedDropdown = Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(
            10.0,
          )),
          color: Color(0xFFF0F0F0),
          shape: BoxShape.rectangle),
      width: MediaQuery.of(context).size.width,
      child:
          // FutureBuilder<List<DogBreed>>(
          //     future: _getDropDownBreedData(),
          //     builder:
          //         (BuildContext context, AsyncSnapshot<List<DogBreed>> snapshot) {
          //       if (!snapshot.hasData) return Center(
          //         widthFactor: 100.0,
          //         child: CircularProgressIndicator(),
          //       );
          //       return
          DropdownButton(
        isExpanded: true,
        hint: Text(
          'Select Breed',
          style: kMainContentStyleLightBlack,
        ),
        autofocus: true,
        value: _selectedBreed,
        onChanged: onChangeDropdownItemBreed,
        isDense: false,
        items: _dogBreedList
            .map((dp) => DropdownMenuItem(
                  child: new Text(dp.name),
                  value: dp.id.toString(),
                ))
            .toList(),
        style: kSubContentStyle2Black,
      ),
      //   ;
      // }),
    );

    //// pet activity level ////
    final activityLevelDropdown = Container(
      // width: 150.0,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(
            10.0,
          )),
          color: Color(0xFFF0F0F0),
          shape: BoxShape.rectangle),
      width: MediaQuery.of(context).size.width,
      child:
          // FutureBuilder<List<ActivityLevel>>(
          //     future: _getDropDownActivityLevelData(),
          //     builder: (BuildContext context,
          //         AsyncSnapshot<List<ActivityLevel>> snapshot) {
          //       if (!snapshot.hasData)
          //         return Center(
          //           widthFactor: 100.0,
          //           child: CircularProgressIndicator(),
          //         );
          //       return
          DropdownButton(
        isExpanded: true,
        hint: Text(
          'Select Activity Level',
          style: kMainContentStyleLightBlack,
        ),
        autofocus: true,
        value: _selectedActivityLevel,
        onChanged: onChangeDropdownItemActivityLevel,
        isDense: false,
        items: _activityLevelList
            .map((al) => DropdownMenuItem(
                  child: new Text(al.name),
                  value: al.id.toString(),
                ))
            .toList(),
        style: kSubContentStyle2Black,
      ),
      // ;
      //       }),
    );

    //// pet title ////
    final title = Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
        child: Text(
          'Dog Profile',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
          ),
        ),
      ),
    );

    //// pet continue button ////
    final continueBtn = Container(
      // Padding(
      //   padding: EdgeInsets.symmetric(vertical: 40.0),
      //   child:
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          // if (_selectedBreed == null && _selectedActivityLevel == null) {
          //   buildAlertDialog('Breed and Activity Level must be selected');
          // } else {
            if (!_petRegisterFormKey.currentState.validate()) {
              return;
            } else {
              _petRegisterFormKey.currentState.save();
              // setState(() =>
              //   _autoValidate = true);
              // print(_userName);
              // print(_userEmail);
              // print(_userPassword);
              // print(_userAddress);
              // print(_userPhoneNo);
//            _navigateToPetProfileScreen();
              _isLoading ? null : _handleSubmit(context);
            }
          // }
//          _handleSubmit(context);
//          Navigator.of(context).pushNamed(HomeScreen.tag);
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF03B898),
        child: Container(
          width: MediaQuery.of(context).size.width,
//          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
          child: Text(
            _isLoading ? 'SAVING...' : 'SAVE',
            style: kMainHeadingStyleWhite,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      // ),
    );

    //// pet logo ////
    final logo = Container(
      margin: EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: Center(
        child: Img.Image.asset(
          'assets/images/logo_large.png',
          height: 200.0,
          width: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );

    //// pet input form ////
    final form = Container(
      // color: Colors.transparent,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        // child: SingleChildScrollView(
        child: Form(
          key: _petRegisterFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              title,
              SizedBox(height: 16.0),
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: petName,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      flex: 1,
                      child: petAge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: breedDropdown,
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: activityLevelDropdown,
              ),
              SizedBox(height: 16.0),
              // weightUnitRadio,
              weightUnitToggle,
              // Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
// //                    lifeStageDropdown,
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child:
//                   Expanded(
//                     flex: 5,
//                     child:
//                     activityLevelDropdown,
//                   ),
//                   ),
//                   SizedBox(width: 4.0),
//                   Expanded(
//                     flex: 3,
//                     child: Text('toggle'),
//                   // weightUnitToggle,
//                   ),
//                 ],
//               ),
              SizedBox(height: 16.0),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: petWeight,
                          ),
                          Expanded(
                            flex: 1,
                            child: weightUnit,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 4,
                            child: petIdealWeight,
                          ),
                          Expanded(
                            flex: 1,
                            child: weightUnit,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              genderToggle,
              SizedBox(height: 16.0),
              eatBonesToggle,
              SizedBox(height: 16.0),
              birthDatePicker,
              SizedBox(height: 32.0),
              continueBtn,
              SizedBox(height: 44.0),
            ],
          ),
          // ),
        ),
      ),
    );

    //// pet body ////
    final body = Container(
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
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              logo,
              Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                child: form, //Text('this text here'),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 150,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF01816B),
                borderRadius: BorderRadius.circular(80),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _imageURI == null
                      ? Container(
                          child: GestureDetector(
                            onTap: () {
                              _imageSelectionBtmSheet(context);
                            },
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
//                    margin: EdgeInsets.only(top: 4.0, bottom: 4.0,),
                                child: new Icon(
                                  Icons.camera_alt,
                                  size: 32.0,
                                  color: Colors.white,
                                ),
//                                 onPressed: () {
// //                        _showImageSelectionBtmSheet(context);
//                                   _imageSelectionBtmSheet(context);
//                                 },
//                               ),
                              ),
                              Text(
                                'Upload\n Image',
                                style:
                                    kSubContentStyleWhiteDark, //TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ],
                        ),
                          ))
                      : new Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            // image: new DecorationImage(
                            //   fit: BoxFit.cover,
                            //   image: new FileImage(
                            //     Image.file(_imageURI,),
                            //     scale: 1.0,
                            //   ),
                            // ),
                          ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                          width: 120.0,
                          height: 120.0,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                          child: Image.file(
                            _imageURI,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ),
                        ),
//                  Image.file(imageURI, width: 120, height: 120, fit: BoxFit.fill),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: body,
        ),
      ),
    );
  }
}

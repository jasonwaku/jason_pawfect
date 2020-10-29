//import 'dart:html';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/pets/activity_level.dart';
import 'package:pawfect/models/pets/dog_breed.dart';
import 'package:pawfect/models/pets/pet_fetch_model.dart';
import 'package:pawfect/models/pets/pet_model.dart' as PET;
import 'package:pawfect/models/pets/pet_model.dart';
import 'package:http/http.dart' as http;
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';

// import 'package:pawfect/utils/ri_keys.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pet_profile_view_screen.dart';

class PetProfileEditScreen extends StatefulWidget {
  static String tag = 'pet-profile-edit-page';

  //  final Pet petData;
  //  // PetProfileEditScreen({this.petData});
  //
  // PetProfileEditScreen({Key key, @required this.petData}) : super(key: key);

  @override
  _PetProfileEditScreenState createState() => _PetProfileEditScreenState();
}

class _PetProfileEditScreenState extends State<PetProfileEditScreen> {
//
  String _breedApiUrl;
  List breedData = List();
  DogBreed _selectedBreed;
  String breedId = '';
  // int breedId = 1;
  int actId = 1;

  ActivityLevel _selectedActivityLevel;
  String activityLevelId = '';
  String _activityLevelApiUrl;
  List activityLvlData = List();

  bool isSwitched = true;
  bool isSwitchedSex = false;
  bool isSwitchedEatBones = false;
  bool isSwitchedUnit = false;
  String birthDateInString;
  String bdDate;
  String bdMonth;
  String bdYear;
  DateTime birthDate; // instance of DateTime
  bool isDateSelected = false;
  String initValue = 'Birth/Gotcha Date';
  bool _isLoading = false;

  //
  String _petImage = '';
  String _petImageView = '';
  String _petName = '';
  String _petAge = '';
  String _petBreed = '';
  String _petWeight = '';
  String _petIdealWeight = '';
  String _petLifeStage;
  String _petActivityLevel = '';
  String _petSex = 'male';
  bool _petEatBones = false;
  String _petBirthDate = '';
  String petBirthDate = '';
  bool _petSubscribed = false;
  bool _imperial = false;
  String _inputUnit = 'kg';
  bool _isData = false;

  //
  final GlobalKey<FormState> _petEditFormKey = GlobalKey<FormState>();
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
  FocusNode _idealWeightFocusNode = FocusNode();
  FocusNode _lifeStageFocusNode = FocusNode();
  FocusNode _activityLevelFocusNode = FocusNode();
  FocusNode _birthDateFocusNode = FocusNode();
  FocusNode _sexFocusNode = FocusNode();
  FocusNode _eatBoneFocusNode = FocusNode();

  //image ImagePicker
  File _imageURI;
  PET.Pet _petData;
  User _userData;
  String _userToken;
  String _userEmail;
  String _userID;
  String _petID;
  String _id;

  SharedPreferences petPrefs;
  PetCreate _pet;
  String apiUrl;

  bool _autoValidate = false;

  ProgressDialog pr;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];
//  final picker = ImagePicker();

  @override
  void initState() {
    //set the initial values for the inputs
    super.initState();
    _setInitialValues().then(fetchData());
    // fetchData();
  }
  _setInitialValues() async{
    //
    _dogBreedList =  await _fetchDogBreeds();
    _activityLevelList =  await _fetchActivityLevels();
    // getPetData().then(updateView);
    // _getUserInfo().then(updateViewUser);
    // _inputUnit = 'kg';
    // isSwitched ? _inputUnit = 'kg' : _inputUnit = 'lb';
    //
  }

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

  void _showSnackbar(String msg , Color clr) {
    final snack = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
      backgroundColor: clr,
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  fetchData() async {
    SharedPreferences viewPrefs = await SharedPreferences.getInstance();
    _userToken = viewPrefs.getString('user_token');
    _userEmail = viewPrefs.getString('user_email');
    _userID = viewPrefs.getString('user_id');
    _petID = viewPrefs.getString('pet_id');
    // _petBirthDate = viewPrefs.getString('pet_bdate');
    bool isImperial = viewPrefs.getBool('user_imperial');
    //
    // _inputUnit = viewPrefs.getString('inputUnit'); // kg,lb
    _imperial = viewPrefs.getBool('user_imperial'); // kg,lb
    _petSubscribed = viewPrefs.getBool('user_subscribed'); //true,false
    //
    print(_userToken);
    print(_userEmail);
    print(_userID);
    // print('_inputUnit '+_inputUnit);
//
    _breedApiUrl =
        'breeds/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    _activityLevelApiUrl =
        'activity_levels/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    //
    // await _fetchDogBreeds();
    // await _fetchActivityLevels();
    //
    apiUrl = 'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_petID';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;

    var response = await http.get(_fullUrl);
    print('--------------------------');
    print(response);

    if (response.statusCode == 200) {
      String res = response.body;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // if(resJson['success']) {
      //   print("user create response------------ " + res);
      PetFetch _pet = PetFetch.fromJson(resJson);
      _petName = _pet.name;
      print(_petName);
      _petAge = _pet.age.toString();
      _petActivityLevel = _pet.activityLevelName;
      _petEatBones = _pet.eatbone;
      _petIdealWeight = _pet.idealWeight.toString();
      _petWeight = _pet.weight.toString();
      _petImage = _pet.image.thumb.url;
      _petBreed = _pet.breedName;
      _petBirthDate = DateFormat('dd-MMMM-yyyy').format(_pet.birthDate).toString();
          // petBirthDate; //DateFormat.yMMMd().format(DateTime.now()).toString();
      // _petSex = 'sex';
      //
      DogBreed breed;
      for (var i = 0; i < _dogBreedList.length; i++) {
        if(_dogBreedList[i].name == _petBreed){
          breed = _dogBreedList[i];
        }
      }
      //
      ActivityLevel aLevel;
      for (var i = 0; i < _activityLevelList.length; i++) {
        if(_activityLevelList[i].name == _petActivityLevel){
          aLevel = _activityLevelList[i];
        }
      }//
      setState(() {
        _isData = true;
        _selectedActivityLevel = aLevel;
        _selectedBreed = breed; //breedData[_pet.breed.id];
        _petImageView = _petImage;
        _inputUnit = !isImperial ? 'kg':'lb';
        //
        petNameController.text = _petName;
        petAgeController.text = _petAge;
        petWeightController.text = _petWeight;
        petIdealWeightController.text = _petIdealWeight;
        //
        isSwitchedSex = _pet.sex.toString() == 'male' ? true: false;
        isSwitchedEatBones = _petEatBones;
        isSwitchedUnit = !isImperial;
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

  void updateView(PET.Pet pet) {
    setState(() {
      this._petData = pet;
    });
  }

  Future<PET.Pet> getPetData() async {
    petPrefs = await SharedPreferences.getInstance();
    String petData = petPrefs.getString('petData');
    _petImage = petPrefs.getString('petImage');
    _petAge = petPrefs.getString('petAge');
    _petBreed = petPrefs.getString('petBreed');
    _petActivityLevel = petPrefs.getString('petActivityLevel');
    _petSex = petPrefs.getString('petSex');
    _petBirthDate = petPrefs.getString('petBDate');
    _inputUnit = petPrefs.getString('inputUnit');
    isSwitchedUnit = (_inputUnit == 'kg') ? true : false;
    _id = petPrefs.getString('petId');

    //
    var pet = json.decode(petData);
    apiUrl =
        '/pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_id';
    // Pet pet = Pet.fromJson(jsonString);
    return pet;
  }

  void updateViewUser(User user) {
    setState(() {
      this._userData = user;
    });
  }

  Future<User> _getUserInfo() async {
    SharedPreferences userViewPrefs = await SharedPreferences.getInstance();
    var userJson = userViewPrefs.getString('userData');
    var user = json.decode(userJson);
    _userToken = userViewPrefs.getString('user_token');
    _userEmail = userViewPrefs.getString('user_email');
    // userEmail = user.email;

    return user;
  }

  onChangeDropdownItemBreed(DogBreed selectedBreed) {
    setState(() {
      // fieldFocusChange(context, _breedFocusNode, _weightFocusNode);
      _selectedBreed = selectedBreed; //.name;
      breedId = _selectedBreed.id.toString();
      // breedId = selectedBreed.id;
      // this._petBreed = _selectedBreed;
    });
  }

  onChangeDropdownItemActivityLevel(ActivityLevel selectedActivityLevel) {
    setState(() {
      // fieldFocusChange(context, _activityLevelFocusNode, _sexFocusNode);
      _selectedActivityLevel = selectedActivityLevel;
      activityLevelId = _selectedActivityLevel.id.toString();
      // this._petActivityLevel = _selectedActivityLevel;
    });
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _imageSelectionBtmSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        alignment: Alignment.center,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: 260.0,
                  color: Color(0xFF01816B),
                  child: new FlatButton(
                    colorBrightness: Brightness.light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () => _getImageFromGallery(),
                    child: new Text(
                      'Select from Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: 260.0,
                  color: Color(0xFF01816B),
                  child: new FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () => _getImageFromCamera(),
                    child: new Text(
                      'Take from Camera',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    padding: EdgeInsets.all(12),
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
    var petImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageURI = petImage;
      print(_imageURI.path);
    });

    Navigator.pop(context);
  }

//image picker from Gallery
  Future _getImageFromGallery() async {
    var petImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    File tmpFile = File(petImage.path);

    setState(() {
      _imageURI = petImage;
      print(_imageURI.path);
    });

    Navigator.pop(context);
  }

  Future<void> _handleSave(BuildContext context) async {
    // Navigator.pop(context);
    // try {
      // LoadingDialog.showLoadingDialog(
      //     context);//, _petEditFormKey); //invoking login
      setState(() {
        _isLoading = true;
      });
      pr.show();
      String bdate = birthDate != null ? DateFormat("dd-MM-yyyy").format(birthDate):_petBirthDate;
      String ageVal = petAgeController.text.toString();
      String idealWVal = petIdealWeightController.text.toString();
      String wVal = petWeightController.text.toString();
      String nameVal = petNameController.text.toString();
      String breedVal = breedId == '' ? _selectedBreed.id.toString() : breedId;
      String actVal = activityLevelId == '' ? _selectedActivityLevel.id.toString() : activityLevelId;
      var petData = {
        'user_email': _userEmail,
        'user_token': _userToken,
        'pet': {
          'id': _petID,
          'age': ageVal,
          "birth_date": bdate,
          'eatbone': _petEatBones.toString(),
          'ideal_weight': idealWVal,
          // 'image': _imageURI.toString(),
          'name': nameVal,
          "sex": _petSex,
          'weight': wVal,
          'guideline_id': '1',
          'activity_level_id': actVal,
          'breed_id': breedVal,
          'user_id': _userID,
        }
      };

      // final PetCreate
      final pet = await CallApi().updateThePet(petData, 'pets/update');
      if (pet != null) {
        if (pet.success) {
          setState(() {
            _pet = pet;
          });
          print('///////////////////////// success //////////////////////////');
          petPrefs = await SharedPreferences.getInstance();
          petPrefs.remove('pet_image');
          petPrefs.remove('pet_name');
          petPrefs.remove('pet_age');
          petPrefs.remove('inputUnit');
          petPrefs.remove('user_subscribed');
          petPrefs.remove('user_imperial');
          //
          petPrefs.setString('pet_image', _pet.pet.image.thumb.url);
          // localStoragePet.setString('petImage', _petImage);
          //todo do not save data locally even they are not passed in the API. kleep them blank till that get resolved
          petPrefs.setString('inputUnit', _inputUnit);
          petPrefs.setString('pet_name', _petName);
          petPrefs.setString('pet_age', _petAge);
          // petPrefs.setString('user_subscribed', _petSubscribed);
          petPrefs.setBool('user_subscribed', _petSubscribed);
          petPrefs.setBool('user_imperial', _inputUnit == 'kg' ? false : true);

          pr.hide().whenComplete(() {
            updateUserData();
          });
          // _setNavigation();
          //
        } else {
          // Navigator.of(context).pop();
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
      // updateUserData();
      setState(() {
        _isLoading = false;
      });
      //
    // } catch (error) {
    //   print(error);
    // }
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

  // void updatePetData() async {
  //   //
  //   var dogData = {
  //     'user_email': _userData.email,
  //     'user_token': _userToken,
  //     'Pet': {
  //       'id' : '1',
  //       'eatbone' : _petEatBones,
  //       'ideal_weight': petIdealWeightController.text,
  //       'name': petNameController.text,
  //       'weight': petWeightController.text,
  //       'guideline_id': '1',
  //       'activity_level_id': '1',
  //       'breed_id': '1',
  //       'user_id': '1',
  //     }
  //   };
  //
  //   var res = await CallApi().putData(dogData, '/pets/update');
  //   var body = json.decode(res.body);
  //   if(body['success']){
  //     SharedPreferences localStoragePet = await SharedPreferences.getInstance();
  //     //remove existing data
  //     localStoragePet.remove('petImage');
  //     localStoragePet.remove('petSuccess');
  //     localStoragePet.remove('petData');
  //     localStoragePet.remove('petImage');
  //     localStoragePet.remove('petActivityLevel');
  //     localStoragePet.remove('petBreed');
  //     localStoragePet.remove('petAge');
  //     localStoragePet.remove('petBDate');
  //     localStoragePet.remove('petSex');
  //     localStoragePet.remove('inputUnit');
  //     //add the new data values
  //     localStoragePet.setString('petImage', _petImage);
  //     localStoragePet.setString('petSuccess', body['success']);
  //     localStoragePet.setString('petData', json.encode(body['pet']));
  //     localStoragePet.setString('petImage', _petImage);
  //     localStoragePet.setString('petActivityLevel', _petActivityLevel);
  //     localStoragePet.setString('petBreed', _petBreed);
  //     localStoragePet.setString('petAge', petAgeController.text);
  //     localStoragePet.setString('petBDate', _petBirthDate);
  //     localStoragePet.setString('petSex', _petSex);
  //     localStoragePet.setString('inputUnit', _inputUnit);
  //
  //     print(body);
  //     print(body['success']);
  //   // petData = new Pet(
  //   //   petImage: _petImage,
  //   //   name: _petName,
  //   //   petAge: _petAge,
  //   //   petBreed: _petBreed,
  //   //   weight: _petWeight,
  //   //   ideal_weight: _petIdealWeight,
  //   //   petActivityLevel: _petActivityLevel,
  //   //   petSex: _petSex,
  //   //   eatbone: _petEatBone,
  //   //   petBirthDate: _petBirthDate,
  //   // );
  //   // savePetPreferences(petData).then((bool committed) {
  //   updateUserData();
  //
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     //
  //     buildAlertDialog();
  //   }
  //   // _subscriptionBtmSheet(context);
  //   // Navigator.of(context).popAndPushNamed(PetProfileScreen.tag);
  //   // });
  // }

  void updateUserData() async {
    //user data load from the local storage
    setState(() {
      _isLoading = true;
    });
    pr.show();
    //
    var userData = {
      'user_email': _userEmail,
      'user_token': _userToken,
      'user': {
        // 'username': _userData.username,
        // 'address': _userData.address,
        'imperial': (_inputUnit == 'kg' ? false : true).toString(),
        // 'mobile': _userData.mobile,
        // 'password': _userData.password,
        // 'role': _userData.role,
        // 'subscribed': _petSubscribed.toString(), //_isSubscribed.toString(),
        // 'country_id': '1',
      }
    };

    // final UserCreate
    final res = await CallApi().updateTheUser(userData, 'users/update');
    // var body = json.decode(res.body);
    if (res != null) {
      if (res.success) {
        // setState(() {
        //
        // });
        //for local reference
        // SharedPreferences localStorageUser =
        //     await SharedPreferences.getInstance();
        // localStorageUser.setString('user_token', body['token']);
        // localStorageUser.setString('user_data', json.encode(body['user']));

        print(res.success);
        print(res.user);
        print(res.token);

        pr.hide().whenComplete(() {
          _setNavigation();
        });
      } else {
        String msg = res.message;
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
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> savePetPreferences(PET.Pet pet) async {
    petPrefs = await SharedPreferences.getInstance();
    String petJson = jsonEncode(pet.toJson()); //userPrefs.getString('user');
    // Map decodeOptions = jsonDecode(userJson);
    // String user = jsonEncode(User.fromJson(decodeOptions));
    petPrefs.setString('petData', petJson);
    print(petJson);
    return petPrefs.commit();
  }

//   Future<void> _handleSubmit(BuildContext context) async {
//     setState(() {
//       _isLoading = true;
//     });
//     LoadingDialog.showLoadingDialog(context, _petFormKey);
//     savePetData();
// //  print(body);
//     setState(() {
//       _isLoading = false;
//     });
  void savePetData() async {
    // String bdate = DateFormat("dd-MM-yyyy").format(birthDate);
    //
    // var petData = {
    //   'user_email': _userEmail,
    //   'user_token': _userToken,
    //   'pet': {
    //     'id': _petID,
    //     'age': petAgeController.text,
    //     "birth_date": bdate,
    //     'eatbone': _petEatBones.toString(),
    //     'ideal_weight': petIdealWeightController.text,
    //     'image': _imageURI.toString(),
    //     'name': petNameController.text,
    //     "sex": _petSex,
    //     'weight': petWeightController.text,
    //     'guideline_id': '1',
    //     'activity_level_id': _selectedActivityLevel,
    //     'breed_id': _selectedBreed,
    //     'user_id': _userID,
    //   }
    // };
    //
    // // final PetCreate
    // final pet = await CallApi().updateThePet(petData, 'pets/update');
    // if (pet != null) {
    //   if (pet.success) {
    //     setState(() {
    //       _pet = pet;
    //     });
    //     print('///////////////////////// success //////////////////////////');
    //   petPrefs = await SharedPreferences.getInstance();
    //   petPrefs.remove('pet_image');
    //   petPrefs.remove('inputUnit');
    //   petPrefs.remove('user_subscribed');
    //   //
    //   petPrefs.setString('pet_image', _pet.pet.image.thumb.url);
    //   // localStoragePet.setString('petImage', _petImage);
    //   //todo do not save data locally even they are not passed in the API. kleep them blank till that get resolved
    //   petPrefs.setString('inputUnit', _inputUnit);
    //   petPrefs.setString('user_subscribed', _petSubscribed);
    //
    //   updateUserData();
    //   // _setNavigation();
    //   //
    //   } else {
    //     Navigator.of(context).pop();
    //     String msg = pet.message;
    //     print(msg);
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     // var snackbar = new SnackBar(
    //     //   content: new Text("Cars enabled"),
    //     //   backgroundColor: Colors.white,
    //     //   duration: new Duration(seconds: 2),
    //     // );
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //       content: new Text("Cars enabled"),
    //       backgroundColor: Colors.red,
    //       duration: new Duration(seconds: 2),
    //     ));
    //     // _showScaffold('jjjjjjj \n$msg');
    //     // buildAlertDialog('An Error Occurred. \n$msg' ); //\n$msg'
    //   }
    //   Navigator.pop(context);
    //   // showScaffold('nnnnnn');
    // } else {
    //   Navigator.pop(context);
    //   // _showScaffold('ooooooo');
    //   // buildAlertDialog('A Network Error Occurred.' );
    // }
    // Navigator.pop(context);
    // _showScaffold('nnnnnn');
  }

  AlertDialog buildConfirmDialog() {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Profile Updated Successfully.!",
          style: kMainContentStyleDarkBlack,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _setNavigation() {
    Timer(Duration(seconds: 3), () {
      // Navigator.of(_petEditFormKey.currentContext, rootNavigator: true).pop();
      // Navigator.of(_petFormKey.currentContext, rootNavigator: true)
      //     .pop(); //close the dialog
      _navigateToProfileViewScreen();
    });
  }

  void _navigateToProfileViewScreen() {
    Navigator.of(context).pop(
      PageTransition(
        child: PetProfileViewScreen(),
        type: PageTransitionType.leftToRightWithFade,
      ),
    );
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

    final petName = TextFormField(
      // initialValue: widget.petData.petName != null ? '${widget.petData.petName}' : 'name',
      //widget.pet.petName != null ? '${widget.pet.petName}' : 'name',
      inputFormatters: [
        new LengthLimitingTextInputFormatter(15),
      ],
      keyboardType: TextInputType.name,
      autofocus: true,
      controller: petNameController,
      onChanged: (text) => {},//..text = _petName,
      //(_petData != null ? '${_petData.name}' : ''),
      focusNode: _nameFocusNode,
      validator: validateNameDog,
      onSaved: (String value) {
        this._petName = value;
      },
      // onFieldSubmitted: (_) {
      //   fieldFocusChange(context, _nameFocusNode, _ageFocusNode);
      // },
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

    final petAge = Container(
      width: 100,
      child: TextFormField(
        controller: petAgeController, //..text = _petAge,
        onChanged: (text) => {},
        //(_petData != null ? '${_petData.name}' : ''),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}?$')),
          new LengthLimitingTextInputFormatter(2),
        ],
        // initialValue: widget.petData.petAge != null ? '${widget.petData.petAge}' : 00,
        //widget.pet.petAge != null ? '${widget.pet.petAge}' : 'age',
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        focusNode: _ageFocusNode,
        validator: validateNumber,
        onSaved: (String value) {
          this._petAge = value; //int.parse(value);
        },
        // onFieldSubmitted: (_) {
        //   fieldFocusChange(context, _ageFocusNode, _breedFocusNode);
        // },
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

    final petWeight = Container(
      // width: 120,
      child: TextFormField(
        controller: petWeightController, //..text = _petWeight,
        onChanged: (text) => {},
        //(_petData != null ? '${_petData.weight}' : ''),
        // initialValue: widget.petData.petWeight != null ? '${widget.petData.petWeight}' : 0.0,
        //idget.pet.petWeight != null ? '${widget.pet.petWeight}' : '00',
        inputFormatters: [
          new LengthLimitingTextInputFormatter(5),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        // focusNode: _weightFocusNode,
        validator: validateNumberDecimal,
        onSaved: (String value) {
          this._petWeight = value; //double.parse(value);
        },
        // onFieldSubmitted: (_) {
        //   fieldFocusChange(context, _weightFocusNode, _idealWeightFocusNode);
        // },
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

    final petIdealWeight = Container(
      child: TextFormField(
        // initialValue: widget.petData.petIdealWeight != null ? '${widget.petData.petIdealWeight}' : 0.0,
        //widget.pet.petIdealWeight != null ? '${widget.pet.petIdealWeight}' : '00',
        controller: petIdealWeightController, //..text = _petIdealWeight,
        onChanged: (text) => {},
        //(_petData != null ? '${_petData.idealWeight}' : ''),
        inputFormatters: [
          new LengthLimitingTextInputFormatter(5),
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
        // focusNode: _weightFocusNode,
        validator: validateNumberDecimal,
        onSaved: (String value) {
          this._petIdealWeight = value; //double.parse(value);
        },
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
          labelText: 'Ideal Weight',
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
                value: _petSex == 'male' ? true : false,
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
                  isSwitchedSex ? _petSex = 'male' : _petSex = 'female';
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                value: _petEatBones ? true : false,
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
                  isSwitchedEatBones
                      ? _petEatBones = true
                      : _petEatBones = false;
                },
              ),
            ),
          ],
        ),
      ),
    );

    final weightUnitToggle = Container(
      alignment: Alignment.center,
      // child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Weight Unit',
              style: kMainContentStyleLightBlack,
            ),
          ),
          Container(
            height: 36.0,
            child: LiteRollingSwitch(
              value: _inputUnit == 'kg' ? true : false,
              textOn: 'Metric',
              textOff: 'Imperial',
              textSize: 16.0,
              colorOn: Color(0xFF03B898),
              colorOff: Color(0xFF01816B),
              iconOn: Icons.check_circle_outline,
              iconOff: Icons.remove_circle,
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
            ),
          ),
        ],
      ),
      // ),
    );

    final birthDatePicker = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
//        Text('Select Birth Date'),
          Text(
            isDateSelected
                ? "Birth/Gotcha On ${DateFormat('dd-MMMM-yyyy').format(birthDate)}"
                : "Birth/Gotcha On $_petBirthDate",
            //widget.petData.petBirthDate,
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
                        "${birthDate.month}/${birthDate.day}/${birthDate.year}"; // 08/14/2019
                    _petBirthDate = birthDateInString;
                    bdDate = birthDate.day.toString();
                    bdMonth = birthDate.month.toString();
                    bdYear = birthDate.year.toString();
                  });
                }
              }),
        ],
      ),
    );

    final breedDropdown = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<DogBreed>(
        isExpanded: true,
        hint: Text(
          'Select Breed',
          style: kMainContentStyleLightBlack,
        ),
        autofocus: true,
        value: _selectedBreed,
        //_petBreed, //widget.petData.petBreed = null ? widget.petData.petBreed : _selectedBreed,
        onChanged: onChangeDropdownItemBreed,
        isDense: false,
        items: _dogBreedList.map((breed) {
          return DropdownMenuItem<DogBreed>(
            child: new Text(breed.name),
            value: breed,
          );
        }).toList(),
        style: kSubContentStyleBlack,
      ),
    );

    final activityLevelDropdown = Container(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton<ActivityLevel>(
        isExpanded: true,
        hint: Text(
          'Select Activity Level',
          style: kMainContentStyleLightBlack,
        ),
        autofocus: true,
        value: _selectedActivityLevel,
        // _petActivityLevel, //_selectedActivityLevel,
        items: _activityLevelList.map((activityLevel) {
          return DropdownMenuItem<ActivityLevel>(
            child: new Text(activityLevel.name),
            value: activityLevel,
          );
        }).toList(),
        style: kSubContentStyleBlack,
        onChanged: onChangeDropdownItemActivityLevel,
      ),
    );

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

    final saveBtn = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: new FlatButton(
              minWidth: 140.0,
              color: Colors.white,
              colorBrightness: Brightness.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: 2.0,
                  color: Color(0xFF01816B),
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(
                  PageTransition(
                    child: PetProfileViewScreen(),
                    type: PageTransitionType.leftToRight,
                  ),
                ),
              },
              child: new Text(
                'CANCEL',
                style: TextStyle(
                  color: Color(0xFF01816B),
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(12),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            flex: 1,
            child: new FlatButton(
              minWidth: 140.0,
              color: Color(0xFF01816B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (!_petEditFormKey.currentState.validate()) {
                  return;
                } else {
                  _petEditFormKey.currentState.save();
                  // setState(() => _autoValidate = true);
//            _navigateToPetProfileScreen();
                  _isLoading ? null : _handleSave(context);
                }
                // _handleSave(context),
                // Navigator.of(context).pop(
                //   PageTransition(
                //     child: PetProfileViewScreen(),
                //     type: PageTransitionType.leftToRight,
                //   ),
                // ),
              },
              child: new Text(
                _isLoading ? 'Saving...' : 'SAVE',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );

    final logo = Container(
      margin: EdgeInsets.only(top: 8.0),
      alignment: Alignment.center,
      child: Center(
        child: Img.Image.asset(
          'assets/images/logo_small.png',
          // height: 150.0,
          // width: 150.0,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget petForm() {
      return new Container(
        // color: Colors.transparent,
        // alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Form(
            key: _petEditFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // SizedBox(height: 12.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: breedDropdown,
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: activityLevelDropdown,
                  ),
                  SizedBox(height: 16.0),
                  weightUnitToggle,
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
                  saveBtn,
                  SizedBox(height: 44.0),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final body = Container(
      //add width here
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
              Expanded(
                flex: 1,
                child: logo,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  // alignment: Alignment.center,
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
                  child:
                      // FutureBuilder<PET.Pet>(
                      //   future: CallApi().retrieveThePet(apiUrl),
                      //   //sets the getQuote method as the expected Future
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       final petD = snapshot.data;
                      //       _petName = petD.name;
                      //       _petAge = '0';
                      //       _petWeight = petD.weight.toString();
                      //       _petIdealWeight = petD.idealWeight.toString();
                      //       _petBreed = petD.breed.name;
                      //       _petActivityLevel = petD.activityLevelName;
                      //       _petSex = 'male';
                      //       _petBirthDate = 'null';
                      //       _petEatBones = petD.eatbone;
                      //       _petImage = petD.image.thumb.url;
                      //       //checks if the response returns valid data
                      //       return
                      _isData
                          ? petForm()
                          : new Center(
                              widthFactor: 120.0,
                              heightFactor: 120.0,
                              child: CircularProgressIndicator(),
                            ),
//   } else if (snapshot.hasError) {
//   //checks if the response throws an error
//   return Text("${snapshot.error}");
//   }
//   return CircularProgressIndicator();
// }, //Text('this text here'),
//               ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 150,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Color(0xFF01816B),
                borderRadius: BorderRadius.circular(80),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _petImageView == null
                      ? Container(
                          child: Center(
                            child: Img.Image.asset(
                              'assets/images/logo_small.png',
                              height: 128.0,
                              width: 128.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        //   Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       child: IconButton(
                        //         icon: Icon(Icons.camera_alt),
                        //         color: Colors.white,
                        //         onPressed: () {
                        //           _imageSelectionBtmSheet(context);
                        //         },
                        //       ),
                        //     ),
                        //     Text(
                        //       'Upload Image',
                        //       style:
                        //           TextStyle(fontSize: 12, color: Colors.white),
                        //     ),
                        //   ],
                        // ),
                  )
                      : new Container(
                          width: 128.0,
                          height: 128.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                _petImageView,
                                scale: 1.0,
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
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // child: SingleChildScrollView(
        child: body,
        // ),
      ),
    );
  }
}

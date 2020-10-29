import 'dart:convert';
import 'dart:io';
import 'dart:io' as IO;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/pets/all_pet_model.dart';
import 'package:pawfect/models/pets/pet_fetch_model.dart';
import 'package:pawfect/models/pets/pet_model.dart' as PET;
import 'package:http/http.dart' as http;
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_edit_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetProfileViewScreen extends StatefulWidget {
  PetProfileViewScreen({Key key}) : super(key: key);
  static String tag = 'pet-profile-page';

  @override
  _PetProfileViewScreenState createState() => _PetProfileViewScreenState();
}

class _PetProfileViewScreenState extends State<PetProfileViewScreen> {
  // Image petImage = Image(url, thumb);
  // int id;
  // String activityLevelName;
  // int age;
  // String birthDay;
  // String birthMonth;
  // String birthYear;
  // String breedName;
  // List<DailyAllowanceGuidelinesDetail> dailyAllowanceGuidelinesDetails;
  // bool eatbone;
  // int idealWeight;
  // Image image;
  // double imperialWeight;
  // String name;
  // List<NutrientGuidelineDetail> nutrientGuidelineDetail;
  // dynamic petLifeStageName;
  // String sex;
  // String totalDailyCalories;
  // int weight;
  List<AllPetsModel> _allPetsObject;

  List<PET.Pet> _pets = [
    PET.Pet(
      image: PET.Image(
          url:
          'assets/images/logo_large.png',
          thumb: PET.Thumb(
              url:
              'assets/images/logo_large.png')),
      name: 'Dog',
      id: 1,
      birthDate: DateFormat('dd-MM-yyyy').parse("12-12-2018"),
      breedName: 'breed',
      age: 2,
      activityLevelName: '',
      eatbone: true,
      weight: 0,
      idealWeight: 0,
      nutrientGuidelineDetail: [
        PET.NutrientGuidelineDetail(name: '', amount: 0.0, unit: PET.Unit.G)
      ],
      dailyAllowanceGuidelinesDetails: [
        PET.DailyAllowanceGuidelinesDetail(
            name: '', bones: true, percentage: 10)
      ],
      totalDailyCalories: '',
    ),
    PET.Pet(
      image: PET.Image(
          url:
              'https://images.unsplash.com/photo-1561037404-61cd46aa615b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
          thumb: PET.Thumb(
              url:
                  'https://images.unsplash.com/photo-1561037404-61cd46aa615b?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80')),
      name: 'max',
      id: 2,
      birthDate: DateFormat('dd-MM-yyyy').parse("12-12-2018"),
      breedName: 'breed',
      age: 6,
      activityLevelName: '',
      eatbone: true,
      weight: 0,
      idealWeight: 0,
      nutrientGuidelineDetail: [
        PET.NutrientGuidelineDetail(name: '', amount: 0.0, unit: PET.Unit.G)
      ],
      dailyAllowanceGuidelinesDetails: [
        PET.DailyAllowanceGuidelinesDetail(
            name: '', bones: true, percentage: 10)
      ],
      totalDailyCalories: '',
    ),
    PET.Pet(
      image: PET.Image(
          url:
              'https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=933&q=80',
          thumb: PET.Thumb(
            url:
                'https://images.unsplash.com/photo-1503256207526-0d5d80fa2f47?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=933&q=80',
          )),
      name: 'tommy',
      id: 3,
      birthDate: DateFormat('dd-MM-yyyy').parse("12-12-2018"),
      breedName: 'breed',
      age: 3,
      activityLevelName: '',
      eatbone: true,
      weight: 0,
      idealWeight: 0,
      nutrientGuidelineDetail: [
        PET.NutrientGuidelineDetail(name: '', amount: 0.0, unit: PET.Unit.G)
      ],
      dailyAllowanceGuidelinesDetails: [
        PET.DailyAllowanceGuidelinesDetail(
            name: '', bones: true, percentage: 10)
      ],
      totalDailyCalories: '',
    ),
    PET.Pet(
      image: PET.Image(
          url:
              'https://images.unsplash.com/photo-1502673530728-f79b4cab31b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80',
          thumb: PET.Thumb(
            url:
                'https://images.unsplash.com/photo-1502673530728-f79b4cab31b1?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80',
          )),
      name: 'marcel',
      id: 4,
      birthDate: DateFormat('dd-MM-yyyy').parse("12-12-2018"),
      breedName: 'breed',
      age: 2,
      activityLevelName: '',
      eatbone: true,
      weight: 0,
      idealWeight: 0,
      nutrientGuidelineDetail: [
        PET.NutrientGuidelineDetail(name: '', amount: 0.0, unit: PET.Unit.G)
      ],
      dailyAllowanceGuidelinesDetails: [
        PET.DailyAllowanceGuidelinesDetail(
            name: '', bones: true, percentage: 10)
      ],
      totalDailyCalories: '',
    ),
    PET.Pet(
      image: PET.Image(
          url:
              'https://images.unsplash.com/photo-1546460573-e6c02e39568a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80',
          thumb: PET.Thumb(
            url:
                'https://images.unsplash.com/photo-1546460573-e6c02e39568a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=934&q=80',
          )),
      name: 'tony',
      id: 5,
      birthDate: DateFormat('dd-MM-yyyy').parse("12-12-2018"),
      breedName: 'breed',
      age: 5,
      activityLevelName: '',
      eatbone: true,
      weight: 0,
      idealWeight: 0,
      nutrientGuidelineDetail: [
        PET.NutrientGuidelineDetail(name: '', amount: 0.0, unit: PET.Unit.G)
      ],
      dailyAllowanceGuidelinesDetails: [
        PET.DailyAllowanceGuidelinesDetail(
            name: '', bones: true, percentage: 10)
      ],
      totalDailyCalories: '',
    ),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String petAge = '';
  String petBdate = '';
  String petName = '';
  //
  String _petId = '';
  String _inputUnit = '';
  String _petName = '';
  String _petAge = '';
  String _petBreed = '';
  String weightUnit = '';

  // change accordingly for the selection of metric/imperial types
  String _petWeight = '';
  String _petIdealWeight = '';
  String _petLifeStage = 'life stage ';
  String _petActivityLevel = '';
  String _petBirthDate = '';
  String _petSex = '';
  bool _petEatBones = false;

  String _petImage = '';
  String _petImageView = '';
  bool _isData = false;

  bool _status = true;
  File _imageURI;

  //
  SharedPreferences petViewPrefs;
  PET.Pet _petData;
  var petEditData;
  Img.Image imageFromPrefs;

  User _userData;
  String _userToken;
  String _userEmail;
  int selectedIndex = 0;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

  @override
  void initState() {
    super.initState();
    fetchAllPets();
    // fetchPet();
    // getPetData().then(updateView);
    // _getUserInfo().then(updateViewUser);
    // loadImage();
  }

  // get  user info from prefs //
  void updateView(PET.Pet pet) {
    setState(() {
      this._petData = pet;
    });
  }

  // Future<PET.Pet> getPetData() async {
  //   petViewPrefs = await SharedPreferences.getInstance();
  //   String petData = petViewPrefs.getString('petData');
  //   var pet = json.decode(petData);
  //   _petImage = petViewPrefs.getString('petImage');
  //   _petBreed = petViewPrefs.getString('petBreed');
  //   _petActivityLevel = petViewPrefs.getString('petActivityLevel');
  //   _petAge = petViewPrefs.getString('petAge');
  //   _petBirthDate = petViewPrefs.getString('petBDate');
  //   _petSex = petViewPrefs.getString('petSex');
  //   // Map jsonString = json.decode(petData);
  //   // Pet pet = Pet.fromJson(jsonString);
  //   //
  //   // convert the image back from string value
  //   final decodedBytes = base64Decode(_petImage);
  //   _imageURI = IO.File("decodedImage.png");
  //   _imageURI.writeAsBytesSync(decodedBytes);
  //   print(_imageURI);
  //   apiUrl = '/pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$_id';
  //
  //
  //   return pet;
  // }

  void updateViewUser(User user) {
    setState(() {
      this._userData = user;
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

  //fetch all pets data
  Future<List<AllPetsModel>> fetchAllPets() async{
    petViewPrefs = await SharedPreferences.getInstance();
    // var prefJson = viewPrefs.getString('userData');
    // var user = json.decode(prefJson);
    _userEmail = petViewPrefs.getString('user_email');
    print(_userEmail);
    _userToken = petViewPrefs.getString('user_token');
    print(_userToken);
    _petId = petViewPrefs.getString('pet_id');
    print(_petId);
    //
    String apiUrl = 'pets/fetch_all?user_email=$_userEmail&user_token=$_userToken';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;
    //
    var response = await http.get(_fullUrl);
    print('------------All Pets Data--------------');
    print(response);
    //
    if (response.statusCode == 200) {
      String res = response.body;
      print(response.body);
      //   return breweryModelFromJson(response.body);
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // jsonString = resJson;
      _allPetsObject = allPetsModelFromJson(res);
      print(_allPetsObject.toString());
      //
      // baseProtein = _dailyGuides[0].nutrientGuidelines[0].amount;
      // setState(() {});
      // _fetchData();
      // fetchPet();
      _profileSelectionBottomSheet();
      // return
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      buildAlertDialog(
          "Failed to Load Pet Profile. \nResponse Code : ${response.statusCode}");
      throw Exception('Failed to load Pet');
    }
  }

  //fetch single pet data
  void fetchPet(int petID) async {
    bool isImperial = petViewPrefs.getBool('user_imperial'); // kg,lb
    // _petId = petViewPrefs.getString('pet_id');
    // petName = petViewPrefs.getString('pet_name');
    // petBdate = petViewPrefs.getString('pet_bdate');
    // petAge = petViewPrefs.getString('pet_bdate');
    // _inputUnit = viewPrefs.getString('inputUnit');
    // print(_petId);
    print(_inputUnit);

    String apiUrl =
        'pets/fetch?user_email=$_userEmail&user_token=$_userToken&pet[id]=$petID';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;

    var response = await http.get(_fullUrl);
    print('------------Pets Data--------------');
    print(response);

    if (response.statusCode == 200) {
      String res = response.body;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // if(resJson['success']){
      //   print("user create response------------ "+ res);
      PetFetch _pet = PetFetch.fromJson(resJson);
      _petName = _pet.name;
      print(_petName);
      _petActivityLevel = _pet.activityLevelName;
      _petEatBones = _pet.eatbone;
      print(_petEatBones);
      _petIdealWeight = _pet.idealWeight.toString();
      _petWeight = _pet.weight.toString();
      _petImage = _pet.image.thumb.url.toString();
      _petBreed = _pet.breedName;
      _petBirthDate = DateFormat("dd-MMMM-yyyy").format(_pet.birthDate);
      _petSex = _pet.sex;
      _petAge = _pet.age.toString();
      _petId = _pet.id.toString();
      if (this.mounted) {
        setState(() {
          _isData = true;
          _petImageView = _petImage;
          _inputUnit = !isImperial ? 'kg':'lb';
          // _profileSelectionBottomSheet();
        });
      }
      //
      petViewPrefs.remove('pet_id');
      petViewPrefs.remove('pet_name');
      petViewPrefs.remove('pet_age');
      petViewPrefs.remove('pet_image');
      //
      petViewPrefs.setString('pet_id', _petId);
      petViewPrefs.setString('pet_name', _petName);
      petViewPrefs.setString('pet_age', _petAge);
      petViewPrefs.setString('pet_image', _petImage);
      //
      print('new pet id: ' + _petId);
      // Navigator.of(context).push(_profileSelectionBottomSheet());
      // _profileSelectionBottomSheet();
      // return
      // }else{
      //   print("user failed response------------ "+ res);
      //   ErrorModel _error =  errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      // buildAlertDialog(
      //     "Failed to Load Pet Profile. \nResponse Code : ${response.statusCode}");
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

  void loadImage() {
    Utility.getImageFromPreferences().then((image) {
      if (null == image) {
        return;
      }
      imageFromPrefs = Utility.imageFromBase64String(image);
    });
  }

  // void _getPetInfo() async {
  //   petViewPrefs = await SharedPreferences.getInstance();
  //   //gte
  //
  //   var petJson = petViewPrefs.getString('user');
  //   var petStringDecode = json.decode(petJson);
  //   print(petJson);
  //   print(petStringDecode['id']);
  //   //
  //   setState(() {
  //     petData = petStringDecode;
  //   });
  // }

  void _navigateToPetProfileEditScreen() {
    // petEditData = Pet(
    //   petImage: _petData.petImage,
    //   petName: _petData.petName,
    //   petAge: _petData.petAge,
    //   petBreed: _petData.petBreed,
    //   petWeight: _petData.petWeight,
    //   petIdealWeight: _petData.petIdealWeight,
    //   petActivityLevel: _petData.petActivityLevel,
    //   petSex: _petData.petSex,
    //   petEatBones: _petData.petEatBones,
    //   petBirthDate: _petData.petBirthDate,
    // );
    //
    // Navigator.of(context).push(PageTransition(
    //   child: PetProfileEditScreen(petData: petEditData),
    //   type: PageTransitionType.rightToLeftWithFade,
    // ));
    // _awaitEditedValues(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetProfileEditScreen(),
        ));
  }

  // void _awaitEditedValues(BuildContext context) async {
  //
  //   // start the SecondScreen and wait for it to finish with a result
  //   final result = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PetProfileEditScreen(petData: petEditData,),
  //       ));
  //
  //   // after the SecondScreen result comes back update the Text widget with it
  //   setState(() {
  //     petEditData = result;
  //   });
  // }

  //bottom sheet //

  _profileSelectionBottomSheet() {
    // Future future =
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        alignment: Alignment.center,
        height: 400,
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
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          // child: Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                //     child:
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  // child: Row(
                  //   children: [
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Dog Profiles',
                      style: kTitleStyleBlackLight,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // ],
                  // ),
                ),
              ),
              // SizedBox(height: 12.0),
              // ),
              // Spacer(),
              Expanded(
                flex: 8,
                child: Container(
                  // height: 180,
                  margin: EdgeInsets.only(top: 8.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _allPetsObject.length, //_pets.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          // width: 120,
                          // height: 120,
                          // child: Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Expanded(
                              //   flex: 5,
                              //   child:
                              Expanded(
                                flex: 1,
                                child:  _allPetsObject[index].image.thumb.url != null ? Container(
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xFF03B898),
                                    radius: 38.0,
                                    child: Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(60.0),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _allPetsObject[index].image.thumb.url), //_pets[index].image.thumb.url),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : Container(
                          child: CircleAvatar(
                          backgroundColor: Color(0xFF03B898),
                          radius: 38.0,
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(60.0),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/logo_small.png',
                                ),//_pets[index].image.thumb.url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        )
                        ),
                              // ),
                              // SizedBox(width: 16.0),
                              // Spacer(),
                              // Expanded(
                              //   flex: 1,
                              //   child:
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Container(
                                      //   alignment: Alignment.center,
                                      Text(
                                        _allPetsObject[index].name.toUpperCase(),
                                        style: kMainHeadingStyleBlack,
                                        textAlign: TextAlign.start,
                                      ),
                                      // ),
                                      // Container(
                                      //   alignment: Alignment.center,
                                      Text(
                                        _allPetsObject[index].age.toString() + ' years',
                                        //_pets[index].petAge + ' years',
                                        style: kSubContentStyleBlack,
                                        textAlign: TextAlign.start,
                                      ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(width: 16.0),
                              Expanded(
                                flex: 2,
                                child: _allPetsObject[index].id.toString() != _petId ? Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFF03B898),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async{
                                      selectedIndex = _allPetsObject[index].id;
                                      // await fetchPet(_allPetsObject[index].id);
                                      Navigator.pop(context);
                                      // Navigator.of(context).pop();
                                      // _loadSelectedPetProfile(_allPetsObject[index].id);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Change Profile",
                                        style: TextStyle(
                                          color: Color(0xFF03B898),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(12),
                                ) :
                                Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,//Color(0xFF03B898),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: ()async{
                                      // await fetchPet(int.parse(_petId));
                                      selectedIndex = int.parse(_petId);
                                      Navigator.pop(context);
                                      // Navigator.of(context).pop();
                                      // _loadCurrentPetsProfile(_petId);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Current Profile",
                                        style: TextStyle(
                                          color: Colors.black87,//Color(0xFF03B898),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(12),
                                ),
                              ),
                              Divider(
                                color: Color(0xFF03B898),
                                height: 12,
                                thickness: 4,
                                indent: 0,
                                endIndent: 0,
                              ),
                            ],
                          ),
                          // ),
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 2,
                // padding: EdgeInsets.symmetric(horizontal: 16.0),
//                    child: Container(
//                      width: 150.0,
//                      color: Color(0xFF01816B),
                child: Container(
                  padding: EdgeInsets.only(top: 4.0),
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: new FlatButton(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    height: 60.0,
                    color: Color(0xFF01816B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        width: 2.0,
                        color: Color(0xFF01816B),
                      ),
                    ),
                    onPressed: () async{
                      // await fetchPet(1);
                      selectedIndex = int.parse(_petId);
                      Navigator.pop(context);
                      // Navigator.of(context).pop();
                      // _setProfileToDefaultPet(1);
                    },
                    child: new Text(
                      'CANCEL',
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
                ),
//                    ),
              ),
            ],
          ),
          // ),
        ),
      ),
    ).whenComplete(() {
      print('calling after hide bottomSheet');
      print(selectedIndex);
      fetchPet(selectedIndex);
    });
    // future.then((value) => _closeModal(value));
  }
  // _closeModal(value) {
  //   print('modal closed');
  //   fetchPet(value);
  // }

  @override
  Widget build(BuildContext context) {
    final _getEditIcon = new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFF03B898),
        radius: 16.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 24.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
        _navigateToPetProfileEditScreen();
      },
    );

    final _getAddIcon = new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFF03B898),
        radius: 16.0,
        child: new Icon(
          Icons.add,
          color: Colors.white,
          size: 28.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
        _navigateToPetProfileEditScreen();
      },
    );

    final _getProfileIcon = new
    Container(
      width: 32.0,
      height: 32.0,
      alignment: Alignment.bottomRight,
      child:  GestureDetector(
          child: new CircleAvatar(
            backgroundColor: Color(0xFF03B898),
            radius: 16.0,
            child: new Icon(
              Icons.pets,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          onTap: () {
            setState(() {
              _status = false;
              // _navigateToPetProfileEditScreen();
            });
              _profileSelectionBottomSheet();
          },
        ),
    );


    // final petName = Container(
    //   height: 48.0,
    //   alignment: Alignment.centerLeft,
    //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Colors.white,
    //     ),
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(12),
    //     ),
    //   ),
    //   child: Text(
    //     petData != null ? '${petData['name']}' : '',
    //     textAlign: TextAlign.left,
    //     style: TextStyle(
    //       fontSize: 24.0,
    //       fontWeight: FontWeight.w500,
    //       color: Colors.white,
    //     ),
    //   ),
    // );

    final petAge = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petAge != '' ? _petAge: '0', // != null ? '${_petData.petAge}' : '',
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );

    final petAgeTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Dog\'s Age',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petBreed = Container(
      // height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _petBreed, //_petData != null ? '${_petData.petBreed}' : '',
          textAlign: TextAlign.left,
          maxLines: null,
          style: kMainHeadingStyleBlack,
        ),
      ),
    );

    final petBreedTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Breed',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petWeight = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petWeight + ' ' + _inputUnit, //_petData != null ? '${_petData.weight} $weightUnit' : '',
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );

    final petWeightTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Weight',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petIdealWeight = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petIdealWeight + ' ' + _inputUnit,
        // _petData != null ? '${_petData.idealWeight} $weightUnit' : '',
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );
//          SizedBox(height: 4.0),
    final petIdealWeightTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Ideal Weight',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

//     final petLifeStage = Container(
//       height: 48.0,
//       alignment: Alignment.centerLeft,
//       padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.white,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Life Stage:',
//                 textAlign: TextAlign.left,
//                 style: TextStyle(
//                   fontSize: 10.0,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
// //          SizedBox(height: 4.0),
//           Expanded(
//             flex: 2,
//             child: Container(
//               alignment: Alignment.center,
//               child: Text(
//                 petData != null ? '${petData['life stage']}' : '',
//                 textAlign: TextAlign.right,
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

    final petActivityLevel = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petActivityLevel,
        maxLines: null,
        softWrap: true,
        //_petData != null ? '${_petData.petActivityLevel}' : '',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStylesBlack,
      ),
    );

    final petActivityLevelTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Activity Level',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petBirthDate = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petBirthDate, //_petData != null ? '${_petData.petBirthDate}' : '',
        textAlign: TextAlign.left,
        style: kSubContentStyleBlack2,
      ),
    );

    final petBDateTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Birth/Gotcha Date',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petSex = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petSex, //_petData != null ? '${_petData.petSex}' : '',
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );

    final petSexTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Dog\'s Sex',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petEatBones = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Text(
        _petEatBones ? 'Yes' : 'No',
        //_petData != null ? '${_petData.eatbone}' : '',
        textAlign: TextAlign.left,
        maxLines: null,
        style: kMainHeadingStyleBlack,
      ),
      // ),
    );

    final petEatBonesTitle = Container(
      margin: EdgeInsets.only(left: 4.0, bottom: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Does your dog eat bones?',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final petName = Container(
      height: 48.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _petName != ''?_petName:'name',
        //_petData != null ? '${_petData.name}'.toUpperCase() : 'Name',
        // '${userData['user_email']}' : '',//
        textAlign: TextAlign.left,
        maxLines: null,
        style: kMainHeadingStyleBlack,
      ),
    );

    final petNameTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Name',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final title = Container(
      width: MediaQuery.of(context).size.width*0.40,
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

    final userSaveBtn = Container(
      // margin: EdgeInsets.only(bottom: 96.0),
      // width: MediaQuery.of(context).size.width,
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
                // _profileSelectionBottomSheet(context),
                // Navigator.of(context).pop(
                //   PageTransition(
                //     child: PetProfileViewScreen(),
                //     type: PageTransitionType.leftToRight,
                //   ),
                // ),
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
              onPressed: () => {
                // _handleSave(context),
                Navigator.of(context).push(
                  PageTransition(
                    child: PetProfileEditScreen(),
                    type: PageTransitionType.leftToRight,
                  ),
                ),
              },
              child: new Text(
                'EDIT',
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

    final petImageHolder = Container(
      margin: EdgeInsets.only(top: 16.0),
      alignment: Alignment.center,
      child: Center(
        child: CircleAvatar(
          backgroundColor: Color(0xFF03B898),
//                      backgroundImage:
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
          child: Img.Image.asset(
            // null == imageFromPrefs
            //     ?
            'assets/images/logo_large.png',
            // : imageFromPrefs.toString(),
            // petImage,
            fit: BoxFit.contain,
          ),
          // ),
          radius: 70.0,
        ),
      ),
    );

    //// pet logo ////
    final logo = Container(
      margin: EdgeInsets.only(top: 8.0),
      alignment: Alignment.center,
      child: Center(
        child: Img.Image.asset(
          'assets/images/logo_large.png',
          // height: 200.0,
          // width: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
//    final continueBtn = Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: FlatButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(5),
//        ),
//        onPressed: () {
////          _subscriptionBtmSheet(context);
////          Navigator.of(context).pushNamed(HomeScreen.tag);
//        },
//        padding: EdgeInsets.all(12),
//        color: Colors.white,
//        child: Container(
//          width: 220.0,
////          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
//          child: Text(
//            'Add New Pet',
//            style: TextStyle(
//              color: Color(0xFF03B898),
//              fontWeight: FontWeight.bold,
//              fontSize: 16,
//            ),
//            textAlign: TextAlign.center,
//          ),
//        ),
//      ),
//    );

    Widget petProfileView() {
      return new Container(
        // alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          // child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child:
                  title,
                      // ),
                      // Expanded(
                      //   flex: 1,
                      //   child:
                      //   _getProfileIcon,
                      // ),
                    ],
                  ),
                SizedBox(height: 12.0),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       flex: 5,
                //       child: petTitle,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: _getProfileIcon,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: _getAddIcon,
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: _getEditIcon,
                //     ),
                //   ],
                // ),
                Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            petNameTitle,
                            petName,
                          ],
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            petAgeTitle,
                            petAge,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0),
                Column(
                  children: [
                    petBreedTitle,
                    petBreed,
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   flex: 3,
                    //   child: petSex,
                    // ),
                    // Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petWeightTitle,
                          petWeight,
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petIdealWeightTitle,
                          petIdealWeight,
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petSexTitle,
                          petSex,
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petEatBonesTitle,
                          petEatBones,
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petBDateTitle,
                          petBirthDate,
                        ],
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          petActivityLevelTitle,
                          petActivityLevel,
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                userSaveBtn,
//              userAddress,
//              SizedBox(height: 16.0),
//              userCountry,
//              SizedBox(height: 16.0),
//              userPhone,
//              SizedBox(height: 16.0),
//              continueBtn,
              ],
//            ),
            ),
          ),
          // ),
        ),
      );
    }

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
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: logo,
              ),
              Expanded(
                flex: 3,
                child: Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                // alignment: Alignment.topCenter,
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
                child: _isData
                    ? petProfileView()
                    : new Center(
                        widthFactor: 120.0,
                        heightFactor: 120.0,
                        child: CircularProgressIndicator(),
                      ),
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
                          // padding: EdgeInsets.only(top: 8.0),
                          alignment: Alignment.center,
                          child: Center(
                            child: Img.Image.asset(
                              'assets/images/logo_large.png',
                              height: 100.0,
                              width: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
// //                    margin: EdgeInsets.only(top: 4.0, bottom: 4.0,),
//                                 child: IconButton(
//                                   icon: Icon(Icons.camera_alt),
//                                   color: Colors.white,
//                                   iconSize: 32.0,
//                                   onPressed: () {
// //                        _showImageSelectionBtmSheet(context);
//                                     _imageSelectionBtmSheet(context);
//                                   },
//                                 ),
//                               ),
//                               Text(
//                                 'Upload\n Image',
//                                 style:
//                                     kSubContentStyleWhiteDark, //TextStyle(fontSize: 12, color: Colors.white),
//                               ),
//                             ],
//                           ),
                        )

                      : new Container(
                          width: 120.0,
                          height: 120.0,
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
        // child: SingleChildScrollView(
            child: body),
      // ),
    );
  }
}

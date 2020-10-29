import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pawfect/models/pets/pet_model.dart' as PET;
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/navigation/general_home_screen.dart';
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/screens/navigation/premium_home_screen.dart';
import 'package:pawfect/screens/onboard/disclaimer_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/local/pawfect_shared_prefs.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  bool _isLoggedIn = false;

  // Pet _petData;

  SharedPreferences petPrefs;
  PET.Pet _petData;
  SharedPreferences userPrefs;
  SharedPreferences appPrefs;
  User _userData;

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      prefs.setBool('first_time', false);
      return Future<bool>.value(false);
    } else {
      prefs.setBool('first_time', false);
      return Future<bool>.value(true);
    }
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    // _checkIfLoggedIn();
//    setValue();
//     getPetData().then(updateViewPet);
//     getUserData().then(updateViewUser);
    _setNavigation();
//    _getConnect(); // calls getconnect method to check which type if connection it
//    _mockCheckForSession().then((status) {
//      if (status) {
//        _navigateToHome();
//      } else {
//        print('login selected');
////            _navigateToLogin();
//      }
//    });
  }

  _SplashScreenState()
  {
    PawfectSharedPrefs.instance
        .getBooleanValue("isFirstRun")
        .then((value) => setState(() {
      _isLoggedIn = value;
    }));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle ?? 'Not set',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<PET.Pet> getPetData() async {
    petPrefs = await SharedPreferences.getInstance();
    String petData = petPrefs.getString('pet_data');
    Map jsonString = json.decode(petData);
    PET.Pet pet = PET.Pet.fromJson(jsonString);
    return pet;
  }

  Future<User> getUserData() async {
    userPrefs = await SharedPreferences.getInstance();
    String userData = userPrefs.getString('user_data');
    Map jsonString = json.decode(userData);
    User user = User.fromJson(jsonString);
    return user;
  }

  // get  pet info from prefs //
  void updateViewPet(PET.Pet pet) {
    setState(() {
      this._petData = pet;
    });
  }

  // get  user info from prefs //
  void updateViewUser(User user) {
    setState(() {
      this._userData = user;
    });
  }

  void _getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isFirstTime().then((value) => value ? _navigateToDisclaimer() : _navigateToLogin());
      // _checkIfLoggedIn();
      // if(_isLoggedIn){
      // _navigateToLogin(); _navigateToDisclaimer();
      // } else{
      //
      // }

      // _checkIfLoggedIn();
      // _navigateChooser();
//      iswificonnected = false;
//       isFirstTime().then((isFirstTime) {
//         isFirstTime
//             ?
// //        print("First time")
//             _navigateToDisclaimer()
//             :
// //        print("Not first time")
//             _navigateChooser();
//       });
    }
//    else if (connectivityResult == ConnectivityResult.wifi) {
//      iswificonnected = true;
//      setState(() async {
//        wifiBSSID = await (Connectivity().getWifiBSSID());
//        wifiIP = await (Connectivity().getWifiIP());
//        wifiName = await (Connectivity().getWifiName());
//      });
//    }
  }

  void _setNavigation() {
    Timer(Duration(seconds: 3), () {
      _getConnect();
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 6000), () {});
    return true;
  }

  void _navigateToDisclaimer() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: DisclaimerScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: LoginScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: GeneralHomeScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
  }

  void _checkIfLoggedIn() async {
    //check if token is there
    //validate the token
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    var userToken = userPrefs.getString('user_token');
    var userIsSubscribed = userPrefs.getString('user_subscribed');
    //todo: check from showUserInfo API whether the user is subscribed or not after having a token
    print(userToken);
    if (userToken != null) {
      setState(() {
        _isLoggedIn = true;
      });
      (userIsSubscribed == 'true')
          ? Navigator.of(context).popAndPushNamed(PremiumHomeScreen.tag)
          : Navigator.of(context).popAndPushNamed(GeneralHomeScreen.tag);
    } else {
      Navigator.of(context).popAndPushNamed(LoginScreen.tag);
    }
  }

  Future<void> _navigateChooser() async {
    //
    // SharedPreferences userPrefs = await SharedPreferences.getInstance();
    // String userData = userPrefs.getString('userData');
    // var userToken = userPrefs.getString('token');
    // Map jsonStringUser = json.decode(userData);
    // _userData = User.fromJson(jsonStringUser);
    // //
    // SharedPreferences dogPrefs = await SharedPreferences.getInstance();
    // String dogData = dogPrefs.getString('petData');
    // Map jsonStringDog = json.decode(dogData);
    // _dogData = Pet.fromJson(jsonStringDog);

    // prefs = await SharedPreferences.getInstance();
    // var email = prefs.getString('email');
    // //
    // var username = prefs.getString('user-name');
    // var useremail = prefs.getString('user-email');
    // //
    // var petname = prefs.getString('pet-name');
    //
    if (_userData != null && _petData != null) {
      // var uEmail = _userData.userEmail;
      // var uName  = _userData.userName;
// var uPass = _userData.userPassword,
//       _navigateToLogin();
      _checkIfLoggedIn();
      // print(email);
      // if((uName == null && uEmail == null) || uName.isEmpty && uEmail.isEmpty){
      // if(uEmail == null || uEmail.isEmpty){
      // }else{
      // }
      // } else if (userToken != null) {
      //   setState(() {
      //     _isLoggedIn = true;
      //   });
      //   //
      //   Navigator.of(context).popAndPushNamed(GeneralHomeScreen.tag);
    } else {
      _navigateToDisclaimer();
    }
//        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isInternetOn
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Opacity(
                            opacity: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 240.0),
                              child: Image.asset(
                                'assets/images/logo_front.png',
                                height: 300,
                                width: 320,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Shimmer.fromColors(
                            period: Duration(milliseconds: 1500),
                            baseColor: Color(0xffD9FFE3),
                            highlightColor: Color(0xffffffff),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 140.0),
                                  child: Image.asset(
                                    'assets/images/logo_name.png',
                                    height: 200,
                                    width: 320,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomCenter,
                          //   child:
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        widthFactor: MediaQuery.of(context).size.width*0.80,
                        child: _infoTile('version ', _packageInfo.version),
                      ),
                    ),
                  ],
                ),
              )
            : buildAlertDialog(),
      ),
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "You are not Connected to Internet",
              style: kMinTitleStyleBlack,
              textAlign: TextAlign.center,
            ),
            Text(
              "Please turn on your mobile data or connect to a wifi network, in-order to continue.",
              style: kMainContentStyleDarkBlack,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

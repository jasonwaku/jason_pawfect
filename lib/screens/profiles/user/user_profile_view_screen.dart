import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:pawfect/models/users/user_fetch_model.dart';
import 'package:pawfect/models/users/user_model.dart' as USER;
import 'package:http/http.dart' as http;
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_edit_screen.dart';
import 'package:pawfect/utils/local/constants.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/cosmetic/custom_icons_icons.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';

// import 'package:pawfect/utils/ri_keys.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileViewScreen extends StatefulWidget {
  UserProfileViewScreen({Key key}) : super(key: key);
  static String tag = 'user-profile-page';

  @override
  _UserProfileViewScreenState createState() => _UserProfileViewScreenState();
}

class _UserProfileViewScreenState extends State<UserProfileViewScreen> {
  bool _status = true;
  bool _invisiblePass = false;

  //
  SharedPreferences userViewPrefs;
  USER.User _userData;
  String userCountryVal;

  bool _isLoading = false;
  USER.UserCreate _user;
  String apiUrl;
  ProgressDialog pr;
  String _userName = '';
  String _userEmail = '';
  String _userPassword = '';
  String _userAddress = '';
  String _userMobile = '';
  String _userCountry = '';
  bool _isData = false;
  bool goLogOut = false;

  String _countryApiUrl = 'countries/fetch_all';

  final GlobalKey<FormState> _logoutKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];
  // final GlobalKey<FormState> _logoutKey = //GlobalKey<FormState>();

  // var userData;
  // Future<USER.UserCreate> fetchUser;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    fetchUser();
    //.then(updateView);
    // _getUserInfo(); //.then(updateView);
  }

  // get  user info from prefs //
  void updateView(USER.User user) {
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

  List<CountryModel> _countryList = new List<CountryModel>();

  Future<List<CountryModel>> _fetchCountries() async {
    final response = await CallApi().getData(_countryApiUrl);
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<dynamic> values = new List<dynamic>();
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            _countryList.add(CountryModel.fromJson(map));
            debugPrint('Id-------${map['id']}');
            debugPrint('code-------${map['code']}');
            debugPrint('countryId-------${map['country_id']}');
            debugPrint('dialCode-------${map['dial_code']}');
            debugPrint('name-------${map['name']}');
          }
        }
      }
      return _countryList;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data');
    }
  }

  fetchUser() async {
    userViewPrefs = await SharedPreferences.getInstance();
    var userEmail = userViewPrefs.getString('user_email');
    var userToken = userViewPrefs.getString('user_token');
    var userCountry = userViewPrefs.getString('user_country');
    print(userEmail);
    //users/fetch?user_email=brett%40mindvision.com.au&user_token=o8_bCttJ9Mr1EkjcJpic
    apiUrl = 'users/fetch?user_email=$userEmail&user_token=$userToken';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;
    // print(_baseUrl+apiUrl);
//     Map jsonString = json.decode(userData);
//     User user = User.fromJson(jsonString);
//     return user;
    var response = await http.get(_fullUrl); //CallApi().getData(apiUrl); //, headers:{"accept": "*/*"},
    print('--------------------------');
    print(response);

    if (response.statusCode == 200) {
      String res = response.body;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      print(resJson.toString());
      // if(resJson['success']){
      //   print("user create response------------ "+ res);
          UserFetch _user = UserFetch.fromJson(resJson);//userCreateFromJson(res);
        //
        _userName = _user.user.username;
        _userEmail = _user.user.email;
        _userAddress = _user.user.address.toString();
        _userPassword = '';
        _userCountry = _user.user.countryName;
        _userMobile = _user.user.mobile.toString();
        setState(() {
          _isData = true;
        });
        // return
        _userProfileBtmSheet();
        // return _user;
      // }else{
      //   print("user failed response------------ "+ res);
      //   ErrorModel _error =  errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }

    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      // buildAlertDialog(
      //     "Failed to Load User Profile. \nResponse Code : ${response.statusCode}");
      _showSnackbar('A Network Error Occurred.!', errorNet);
      throw Exception('Failed to load User');
    }
  }

  // _setHeaders() => {
  //       'Content-type': 'application/json',
  //       'Accept': '*/*',
  //     };

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

  Future<void> _getUserInfo() async {
    //
    userViewPrefs = await SharedPreferences.getInstance();
    var userJson = userViewPrefs.getString('user_data');
    userCountryVal = userViewPrefs.getString('user_country');
    var userEmail = userViewPrefs.getString('user_email');
    var userToken = userViewPrefs.getString('user_token');
    // var user = json.decode(userJson);
// var apiUrl = ;

    // setState(() {
    //   _isLoading = true;
    // });
    // UserCreate user = await CallApi().retrieveTheUser(
    apiUrl = 'users/fetch?user_email=$userEmail&user_token=$userToken';

    // await getUserDetails();
    // _fetchUserData();
    // );
    // setState(() {
    //   _user = user;
    // });
    // .then((response) {
    // setState(() {
    //   _isLoading = false;
    // });

//     if (_user.success) {
//       //errorMessage = response.errorMessage ?? 'An error occurred';
// // return UserCreate.fromJson(json.decode(user.user));
//       return user;
//     } else {
//       throw Exception('Failed to load post');
//       // buildAlertDialog();
//     }
    // _user = response.user;
    // user = response.user;
    // _titleController.text = note.noteTitle;
    // _contentController.text = note.noteContent;
    // }
    // );

    // setState(() {
    //   userData = user;
    // });
    // return user;
  }

  //
  //   //
  //   // Map jsonString = jsonDecode(userViewPrefs.getString('userData'));
  //   // var user = User.fromJson(jsonString);
  //
  //   // var userJson = userViewPrefs.getString('user');
  //   // var userStringDecode = json.decode(userJson);
  //   // print(userJson);
  //   // print(userStringDecode['id']);
  //   //
  //   // setState(() {
  //   //   userData = user;//userStringDecode;
  //   // });
  // }

  void _navigateToUserProfileEditScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileEditScreen(),
        ));
  }

  Future<void> _handleLogout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context);//, _logoutKey);
    // pr.show();
    await logoutUser(context);
    // pr.hide();//.whenComplete(() => logoutUser());
    // await logoutUser();
    // pr.hide();
//  print(body);
    setState(() {
      _isLoading = false;
    });
  }

  logoutUser(BuildContext context) async {
    // logout from the server ...
    // var res = await CallApi().getData('logout');
    // var body = json.decode(res.body);
    // if (body['success']) {
    userViewPrefs = await SharedPreferences.getInstance();
    //remove user data
    userViewPrefs.remove('user_id');
    userViewPrefs.remove('user_email');
    userViewPrefs.remove('user_token');
    userViewPrefs.remove('user_subscribed');
    userViewPrefs.remove('user_imperial');
    //remove pet data
    userViewPrefs.remove('pet_id');
    userViewPrefs.remove('pet_image');
    userViewPrefs.remove('pet_name');
    userViewPrefs.remove('pet_age');
    //
    // Navigator.of(context).pop();
    // Navigator.of(context).pushNamedAndRemoveUntil(LoginScreenRoute,
    //             (Route<dynamic> route) => false,);
    // Navigator.of(context).pushReplacementNamed(LoginScreenRoute);
    // Navigator.of(context).pop();
    // Navigator.of(context).popUntil(ModalRoute.withName('/login-screen'));
    //
    // Navigator.of(context, rootNavigator: true);
    // Navigator.of(context)
    //     .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
    //   return new LoginScreen();
    // }));
    //
    // Navigator.of(context).pushReplacement(PageTransition(
    //   child: LoginScreen(),
    //   type: PageTransitionType.leftToRight,
    // ));

    // Navigator.of(context).popUntil(
    //     // PageTransition(
    //   // child:
    //     ModalRoute.withName(LoginScreenRoute),
    //   // type: PageTransitionType.leftToRight,
    // // )
    // );

    // Navigator.of(context).pushReplacement(PageTransition(
    //   child: LoginScreen(),
    //   type: PageTransitionType.leftToRight,
    // ));
    //
    // Navigator.of(context).pushReplacement(PageTransition(
    //   child: LoginScreen(),
    //   type: PageTransitionType.leftToRight,
    // ));


    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     LoginScreenRoute,
    //         (Route<dynamic> route) => false,
    // );

    // Navigator.pushNamedAndRemoveUntil(context, LoginScreenRoute, (r) => false);
    // Navigator.popUntil(context, ModalRoute.withName(LoginScreenRoute));
    // Navigator.of(context).pushNamedAndRemoveUntil(LoginScreenRoute, (Route<dynamic> route) => false);
    // Navigator.popUntil(
    //   context,
    //   ModalRoute.withName(LoginScreenRoute),
    // );
    // Navigator.popUntil(
    //   context,
    //   ModalRoute.withName(Navigator.defaultRouteName),
    // );

    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => LoginScreen()));

    // Navigator.pop(
    //     context, new MaterialPageRoute(builder: (context) => LoginScreen()));
    // }
  }

  void _showPassword() {
    setState(() {
      _invisiblePass = !_invisiblePass;
    });
  }

  // Subscription bottom Sheet //
  _userProfileBtmSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            alignment: Alignment.center,
            height: 260,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
            child: Container(
//                  child: new RaisedButton(onPressed: () => Navigator.pop(context), child: new Text('Close'),)
              margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Profile',
                    style: TextStyle(
                      color: Colors.black87, //Color(0xFF03B898),
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 32.0,
                    ),
                  ),
//              SizedBox(height: 12.0),
                  Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24.0,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Padding(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0),
                            minWidth: 150.0,
                            height: 40.0,
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
                              'VIEW PROFILE',
                              style: TextStyle(
                                color: Color(0xFF01816B),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
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
                            height: 40.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(
                                width: 2.0,
                                color: Color(0xFF01816B),
                              ),
                            ),
                            onPressed: () {
                              goLogOut = true;
                              Navigator.of(context).pop();
                              // _isLoading ? null : _handleLogout(context);
                            },
                            child: new Text(
                              'LOGOUT',
                              style: TextStyle(
                                color: Color(0xFF01816B),
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
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
                  SizedBox(height: 16.0,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.75,
                      height: 60.0,
                      child: new FlatButton(
                        color: Color(0xFF01816B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: new Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Colors.white, //
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
    ).whenComplete(() {
      if(goLogOut){
        _isLoading ? null : _handleLogout(context);
      }
    });
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

    final _getEditIcon = new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFF03B898),
        radius: 16.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
        _navigateToUserProfileEditScreen();
      },
    );

    final _getLogOutIcon = new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xFF03B898),
        radius: 16.0,
        child: new Icon(
          CustomIcons.logout,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
        //logoutUser();
      },
    );

    final userTitle = Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.black87,
            fontFamily: 'poppins',
            fontWeight: FontWeight.w500,
            fontSize: 32.0,
          ),
        ),
      ),
    );

    final userName = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        // _userData != null ?
        _userName, //: '',
        // '${userData['user_email']}' : '',//
        textAlign: TextAlign.left,
        maxLines: null,
        style: kMainHeadingStyleBlack,
      ),
    );

    final userNameTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Name',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final userEmail = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Text(
        _userEmail,
        // _userData != null ? '${_userData.email}' : '',
        // '${userData['user_email']}' : '',//
        textAlign: TextAlign.left,
        maxLines: null,
        style: kMainHeadingStyleBlack,
      ),
    );

    final userEmailTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Email',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final userPassword = Container(
      height: 48.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],

        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            !_invisiblePass
                // ? (_userData != null
                ? ('*' * _userPassword.length)
                // : '********')
                : _userPassword,
            // : 'null',
            // (_userData != null ? '${_userData.password}' : '* * * *'),
            ////'${userData['password']}' : '',//
            textAlign: TextAlign.left,
            // maxLines: null,
            style: kMainHeadingStyleBlack,
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(
              _invisiblePass ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF03B898),
            ),
            onPressed: _showPassword,
          ),
        ],
      ),
    );

    final userPasswordTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Password',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final userAddress = Container(
      // height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _userAddress, //_userData != null ? '${_userData.address}' : '',
          //'${userData['address']}' : '', //_userData != null ?
          textAlign: TextAlign.left,
          maxLines: null,
          style: kMainHeadingStyleBlack,
        ),
      ),
    );

    final userAddressTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Address',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final userCountry = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(
        _userCountry,
        // == null ? userCountryVal : 'Australia', //_userData != null ? '${_userData.country_id}' : '',
        //'${userData['country']}' : '', //_userData != null ?
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );

    final userCountryTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Country',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

    final userPhone = Container(
      height: 48.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(
        //   color: Color(0xFF03B898),
        // ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Text(
        _userMobile, //_userData != null ? '${_userData.mobile}' : '',
        //'${userData['phone']}' : '', // _userData != null ?
        textAlign: TextAlign.left,
        style: kMainHeadingStyleBlack,
      ),
    );

    final userPhoneTitle = Container(
      margin: EdgeInsets.only(left: 4.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Phone',
        textAlign: TextAlign.left,
        style: kSmallHeadlineStyleBlack,
      ),
    );

//     final userTitle = Container(
//       width: MediaQuery.of(context).size.width,
//       alignment: Alignment.centerLeft,
//       child: Text(
//         _userData != null
//             ? '${_userData.userName}'.toUpperCase() //'${userData['username']}'.toUpperCase()// _userData != null
//             //     ? '${_userData.userName}'.toUpperCase()
//             : 'Your Profile',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           fontSize: 32.0,
//           fontWeight: FontWeight.w600,
//           color: Colors.black87,
//         ),
// //          ),
//       ),
//     );

    final userLogoutBtn = Container(
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
                // _isLoading ? null : _handleLogout(context),
                // Navigator.of(context).pop(
                // PageTransition(
                //   child: UserProfileViewScreen(),
                //   type: PageTransitionType.leftToRightWithFade,
                // ),
                // ),
              },
              child: new Text(
                'CANCEL', //_isLoading ? 'Logging Out' : 'LOGOUT',
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
                    child: UserProfileEditScreen(),
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

    final logo = Container(
      padding: EdgeInsets.only(top: 8.0),
      alignment: Alignment.center,
      child: Center(
        child: Image.asset(
          'assets/images/logo_large.png',
          // height: 150.0,
          // width: 150.0,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget userProfileView() {
      // new Container(
      //   child:
      // _isData ?
      // FutureBuilder<UserFetch>(
      //     future: CallApi().fetchUser(apiUrl), //getUserDetails(),
      //     //sets the getQuote method as the expected Future
      //     builder: (BuildContext context, AsyncSnapshot<UserFetch> snapshot) {
      //       if (!snapshot.hasData) { //.toString() == "Failed to load User"
      //         //(!snapshot.hasData)
      //         return
      //           Center(
      //           widthFactor: 120.0,
      //           heightFactor: 120.0,
      //           child: CircularProgressIndicator(),
      //         ):
      //       } else {
      //         // final userD = snapshot.data;
      //         setState(() {
      //           _userName = snapshot.data.user.username.toString();
      //           _userEmail = snapshot.data.user.email;
      //           _userAddress = snapshot.data.user.address.toString();
      //           _userPassword = 'password';
      //           _userCountry = 'country';
      //           _userMobile = snapshot.data.user.mobile.toString();
      //         });
      //         //checks if the response returns valid data
      //         return
      return new Container(
//      alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
//                SizedBox(height: 12.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     flex: 6,
//                     child: userTitle,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: _getLogOutIcon,
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: _getEditIcon,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 24.0),
                userTitle,
                SizedBox(height: 12.0),
                userNameTitle,
                userName,
                SizedBox(height: 12.0),
                userEmailTitle,
                userEmail,
                SizedBox(height: 12.0),
                userPasswordTitle,
                userPassword,
                SizedBox(height: 12.0),
                userAddressTitle,
                userAddress,
                SizedBox(height: 12.0),
                userCountryTitle,
                userCountry,
                SizedBox(height: 12.0),
                userPhoneTitle,
                userPhone,
                SizedBox(height: 24.0),
                userLogoutBtn,
              ],
            ),
          ),
        ),
      );
      // }
      // } else if (snapshot.hasError) {
      //   //checks if the response throws an error
      //   return Text("${snapshot.error}");
      // }
      // }),
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
      child: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: logo,
            ),
            Expanded(
              flex: 3,
              child: Container(
                // margin: EdgeInsets.only(top: 4.0),
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
                    ? userProfileView()
                    : new Center(
                        widthFactor: 120.0,
                        heightFactor: 120.0,
                        child: CircularProgressIndicator(),
                      ), //Text('this text here'),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: body,
      ),
    );
  }
}

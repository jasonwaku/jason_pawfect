import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/models/error_model.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:pawfect/models/users/user_fetch_model.dart';
import 'package:pawfect/models/users/user_model.dart' as USER;
import 'package:http/http.dart' as http;
import 'package:pawfect/screens/profiles/pet/pet_registration_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_view_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';

// import 'package:pawfect/utils/ri_keys.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileEditScreen extends StatefulWidget {
  static String tag = 'user-edit-page';

  @override
  _UserProfileEditScreenState createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
//
  List<String> _countries = [
    'Australia',
    'United States',
    'United Kingdom',
    'Canada',
    'New Zealand',
  ];
  CountryModel _selectedUserCountry;
  String _userName;
  String _userEmail;
  String _userPassword = 'pass';
  String _userAddress;
  String _userPhoneNo;
  String _userCountry;
  String _userCountryCode;
  String _userMobile;
  String userCountryVal;
  String userCountryID;
  String userCountryDialCode;
  String userCountryCode;
  String _userCountryT = '';
  String _userCountryId = '';
  bool _invisiblePass = false;
  bool _isLoading = false;
  bool _isSubscribed = false;
  bool _isImperial = false;
  String _role = 'user';
  User userData;
  bool _isData = false;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String countryCodeTxt = '+61';

  //
  final GlobalKey<FormState> _userFormEditKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _countryFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  SharedPreferences userViewPrefs;
  USER.UserCreate _user;
  User _userData;
  String apiUrl;
  String userToken;
  String userID;
  String _countryApiUrl = 'countries/fetch_all';

  bool _autoValidate = false;

  ProgressDialog pr;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

  var re = RegExp(r'\d(?!\d{0,9}$)'); // keep last 3 digits
  // print('123456789'.replaceAll(re, '-')); // ------789

  @override
  void initState() {
    super.initState();
    // _fetchCountries().then((_) =>
    _getLocalData().then(fetchUser());
    //
    // _getUserInfo().then(updateView);
    // setInitialDropDownValues();
  }

  _getLocalData() async {
    //
    _countryList =  await _fetchCountries();
  }

  void updateView(User user) {
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

  void setInitialDropDownValues() {
    // _countries.map(('${_userData.country}') {
    //   String idx = _countries.indexOf(val);
    // }
    // _countries[0] = 'red';
  }

  List<CountryModel> _countryList = new List<CountryModel>();

  Future<List<CountryModel>> _fetchCountries() async {
    //
    setState(() {
      _isLoading = true;
    });

    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/country.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      _countryList = countryModelFromJson(response.body);
      // pr.hide();
      return _countryList;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        _isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    // final response = await CallApi().getData(_countryApiUrl);
    // if (response.statusCode == 200) {
    //   List<dynamic> values = new List<dynamic>();
    //   values = json.decode(response.body);
    //   if (values.length > 0) {
    //     for (int i = 0; i < values.length; i++) {
    //       if (values[i] != null) {
    //         Map<String, dynamic> map = values[i];
    //         _countryList.add(CountryModel.fromJson(map));
    //         debugPrint('Id-------${map['id']}');
    //         debugPrint('code-------${map['code']}');
    //         debugPrint('countryId-------${map['country_id']}');
    //         debugPrint('dialCode-------${map['dial_code']}');
    //         debugPrint('name-------${map['name']}');
    //       }
    //     }
    //   }
    //   // _countryList.where((element) => element['name']== _userCountry);
    //   // myList.where((item) => item > 5)
    //   return _countryList;
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('Failed to load data');
    // }
  }

  fetchUser() async {
    userViewPrefs = await SharedPreferences.getInstance();
    // var userJson = userViewPrefs.getString('user_data');
    userCountryVal = userViewPrefs.getString('user_country');
    userCountryID = userViewPrefs.getString('user_country_id');
    userCountryDialCode = userViewPrefs.getString('user_country_dial');
    userCountryCode = userViewPrefs.getString('user_country_code');
    var userEmail = userViewPrefs.getString('user_email');
    userToken = userViewPrefs.getString('user_token');
    userID = userViewPrefs.getString('user_id');
    _userCountryT = userViewPrefs.getString('user_country');

    apiUrl = 'users/fetch?user_email=$userEmail&user_token=$userToken';
    final String _baseUrl = 'https://api.pawfect-balance.oz.to/';
    final String _fullUrl = _baseUrl + apiUrl;
    // return user;
    var response = await http.get(_fullUrl);
    if (response.statusCode == 200) {
      String res = response.body;
      // If the call to the server was successful (returns OK), parse the JSON.
      var resJson = json.decode(res);
      // if (resJson['success']) {
      //   print("user create response------------ " + res);
        UserFetch _user = UserFetch.fromJson(resJson);
        _userName = _user.user.username;
        _userEmail = _user.user.email;
        _userAddress = _user.user.address.toString();
        _userPassword = '';
        _userCountry = _user.user.countryName;
        _userMobile = _user.user.mobile.replaceRange(0, 2, '0');
        //  _selectedUserCountry = CountryModel(
        //   id: int.parse(userCountryID),
        //   code: userCountryCode,
        //   dial_code: userCountryDialCode,
        //   name: userCountryVal,
        // );
        CountryModel country;
        for (var i = 0; i < _countryList.length; i++) {
          if (_countryList[i].name == _userCountry) {
            country = _countryList[i];
          }
        }
        // for loop with item index
        // _countryList.where((element) => )
        setState(() {
          usernameController.text = _userName;
          emailController.text = _userEmail;
          addressController.text = _userAddress;
          phoneController.text = _userMobile;
          // passwordController.text = !_invisiblePass ? ('*' * _userPassword.length) : _userPassword;
          _selectedUserCountry = country;
          _isData = true;
        });
      // } else {
      //   print("user failed response------------ " + res);
      //   ErrorModel _error = errorModelFromJson(res);
      //   String msg = _error.message;
      //   _showSnackbar(msg, errorAPI);
      // }
      // return
    } else {
      // If that call was not successful (response was unexpected), it throw an error.
      // buildAlertDialog(
      //     "Failed to Load User Profile. \nResponse Code : ${response.statusCode}");
      _showSnackbar('A Network Error Occurred.!', errorNet);
      throw Exception('Failed to load User');
    }
  }

  setCountry(String item) {
    // CountryModel country;
    // for (var i = 0; i < _countryList.length; i++) {
    //   if(_countryList[i].name == item){
    //     country = _countryList[i];
    //   }
    //   // print(_countryList[i]);
    // print(country);
    // return country;
    // }
    _countryList.forEach((country) {
      if (country.name == item) {
        //     country = _countryList[i];
        print(country);
        return country;
      }
    });
  }

  onChangeDropdownItem(CountryModel selectedCountry) {
    setState(() {
      _selectedUserCountry = selectedCountry;
      _userCountry = _selectedUserCountry.name;
      _userCountryCode = _selectedUserCountry.code;
      countryCodeTxt = _selectedUserCountry.dial_code;
      _userCountryId = _selectedUserCountry.id.toString();
    });
  }

  void countryDialCode(String country) {
    switch (country) {
      case 'United States':
        {
          countryCodeTxt = '+1';
        }
        break;
      case 'Unites Kingdom':
        {
          countryCodeTxt = '+44';
        }
        break;
      case 'Australia':
        {
          countryCodeTxt = '+64';
        }
        break;
        break;
      case 'New ZeaLand':
        {
          countryCodeTxt = '+64';
        }
        break;
        break;
      case 'Canada':
        {
          countryCodeTxt = '+1';
        }
        break;
      default:
        {
          countryCodeTxt = '00';
        }
        break;
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    this.countryCodeTxt = countryCode.toString();
    print("New Country selected: " + countryCode.toString());
  }

  //to check on onPressed in the btn
  void check() {
    print("Full Number Text: " + this.countryCodeTxt + phoneController.text);
  }

  void _showPassword() {
    setState(() {
      _invisiblePass = !_invisiblePass;
    });
  }

  void _navigateToPetProfileScreen() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: PetRegistrationScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
//        MaterialPageRoute(builder: (BuildContext context) => PetProfileScreen()));
  }

//   Future<void> _handleSubmit(BuildContext context) async {
//     try {
//
//       setState(() {
//         _isLoading = true;
//
//       });
//
//       var userData = {
//         'username' : _userName,
//         'email' : _userName,
//         'password' : _userName,
//         'country_id' : _userName,
//         'mobile' : _userName,
//         'address' : _userName,
//         'subscribed' : _userName,
//         'role': 'enum',
//       };
//
//
//       userPrefs = await SharedPreferences.getInstance();
//       userPrefs.setString('user-email', _userEmail);
//       userPrefs.setString('user-name', _userName);
//       LoadingDialog.showLoadingDialog(context, _userFormKey); //invoking login
// //    await service.login(user.uid);
//       _setNavigation();
//       //
//     } catch (error) {
//       print(error);
//     }
//   }

  void _setNavigation() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      // Navigator.of(_userFormEditKey.currentContext, rootNavigator: true)
      //     .pop(); //close the dialoge
      // //Navigator.pushReplacementNamed(context, "/home");
      // _navigateToPetProfileScreen();
//      Navigator.of(context).pushNamed(HomeScreen.tag);
    });
  }

  Future<void> _handleSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context);//, _userFormEditKey);
    // saveUserData();
    pr.show();
    String phoneVal = phoneController.text.toString();
    final String mobile =
        countryCodeTxt + (phoneVal).replaceFirst(new RegExp(r'0'), '');
    //
    String emailVal = emailController.text.toString();
    String nameVal = usernameController.text.toString();
    String passVal = passwordController.text.toString();
    String addressVal = addressController.text.toString();
    String countryIdVal = _userCountryId == ''
        ? _selectedUserCountry.id.toString()
        : _userCountryId;
    // String emailVal = emailController.text;
    //
    var userData = {
      'user_email': emailVal,
      'user_token': userToken,
      'user': {
        'address': addressVal,
        // 'imperial': _isImperial.toString(),
        'mobile': mobile,
        'password': passVal,
        // 'role': _role,
        // 'subscribed': _isSubscribed.toString(),
        'username': nameVal,
        'country_id': countryIdVal,
      }
    };

    var userDataWithoutPass = {
      'user_email': emailVal,
      'user_token': userToken,
      'user': {
        'address': addressVal,
        // 'imperial': _isImperial.toString(),
        'mobile': mobile,
        // 'password': passwordController.text,
        // 'role': _role,
        // 'subscribed': _isSubscribed.toString(),
        'username': nameVal,
        'country_id': countryIdVal,
      }
    };

    // final USER.UserCreate
    final user = (passVal != '')
        ? await CallApi().updateTheUser(userData, 'users/update')
        : await CallApi().updateTheUser(userDataWithoutPass, 'users/update');
    if (user != null) {
      if (user.success) {
        setState(() {
          _user = user;
        });
        // if (_user.success) {
        //for local reference
        userViewPrefs = await SharedPreferences.getInstance();
        userViewPrefs.remove('user_email');
        //
        userViewPrefs.remove('user_country');
        userViewPrefs.remove('user_country_id');
        userViewPrefs.remove('user_country/_dial');
        userViewPrefs.remove(
          'user_country_code',
        );
        userViewPrefs.setString('user_country_code', _userCountryCode);
        userViewPrefs.setString('user_country_id', _userCountryId);
        userViewPrefs.setString('user_country_dial', countryCodeTxt);
        userViewPrefs.setString('user_country', _userCountry);
        //
        userViewPrefs.setString(
            'user_email', _user.user.email); //_user.user.email);
        // userViewPrefs.setString('user_imperial', _user.user.imperial.toString());
        // print('user json: ' + json.encode(_user.user));
        pr.hide().whenComplete(() {
          // buildConfirmDialog();
          _showSnackbar('Successfully Updated.!', successAPI);
          _setNavigation();
        });
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

  // void _handleSubmit() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   //save user data in userPrefs
  //   saveUserData();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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

  void saveUserData() async {
    // final String mobile = countryCodeTxt + phoneController.text;
    // var userData = {
    //   'user_email': emailController.text,
    //   'user_token': emailController.text,
    //   'user': {
    //     'address': addressController.text,
    //     // 'imperial': _isImperial.toString(),
    //     'mobile': mobile,
    //     'password': passwordController.text,
    //     // 'role': _role,
    //     // 'subscribed': _isSubscribed.toString(),
    //     'username': usernameController.text,
    //     'country_id': _userCountryId,
    //   }
    // };
    //
    // // final USER.UserCreate
    // final user =
    //     await CallApi().updateTheUser(userData, '/users/update');
    // if(user != null){
    //   if(user.success){
    // setState(() {
    //   _user = user;
    // });
    // // if (_user.success) {
    //   //for local reference
    //   userViewPrefs = await SharedPreferences.getInstance();
    //   userViewPrefs.remove('user_email');
    //   userViewPrefs.setString(
    //       'user_email', emailController.text); //_user.user.email);
    //   // userViewPrefs.setString('user_imperial', _user.user.imperial.toString());
    //   // print('user json: ' + json.encode(_user.user));
    // Navigator.pop(context);
    // buildConfirmDialog();
    //   _setNavigation();
    // } else {
    //     Navigator.of(context).pop();
    //     String msg = user.message;
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
    //   // _showScaffold('nnnnnn');
    // } else {
    //   Navigator.pop(context);
    //   // _showScaffold('ooooooo');
    //   // buildAlertDialog('A Network Error Occurred.' );
    // }
    // // }catch(e){
    // //   String errorMessage = e.toString();
    // //   // TODO: Do something with the error message,
    // //   buildAlertDialog('An Error Occurred! \n$errorMessage' );
    // // }
    // Navigator.pop(context);
  }

  // var res = await CallApi().putData(userData, '/users/update');
  // var body = json.decode(res.body);
  // if(body['success']){
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   //remove existing data
  //   localStorage.remove('userToken');
  //   localStorage.remove('userData');
  //   localStorage.remove('userCountry');
  //   //add the new data values
  //   localStorage.setString('userToken', body['token']);
  //   localStorage.setString('userData', json.encode(body['user']));
  //   localStorage.setString('userCountry', _userCountry);
  //
  //   print(body);
  //   print(body['token']);
  //   print(_userCountry);
  //
  //   _setNavigation();
  // }else{
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   //
  //   buildAlertDialog();
  // }
  // }

  // void saveUserData() {
  //   userData = new User(
  //     userName: _userName,
  //     userEmail: _userEmail,
  //     userPassword: _userPassword,
  //     userAddress: _userAddress,
  //     userCountry: _userCountry,
  //     userPhoneNo: _userPhoneNo,
  //     isSubscribed: _isSubscribed,
  //     role: _role,
  //   );
  //   saveUserPreferences(userData).then((bool committed) {
  //     _setNavigation();
  //     // Navigator.of(context).popAndPushNamed(PetProfileScreen.tag);
  //   });
  // }

  Future<bool> saveUserPreferences(User user) async {
    userViewPrefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson()); //userPrefs.getString('user');
    // Map decodeOptions = jsonDecode(userJson);
    // String user = jsonEncode(User.fromJson(decodeOptions));
    userViewPrefs.setString('userData', userJson);
    print(userJson);
    return userViewPrefs.commit();
  }

  @override
  Widget build(BuildContext context) {
    //
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
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
    //// user email ////
    final userEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
//      initialValue: 'alucard@gmail.com',
      controller: emailController,
      //..text = _userEmail,
      onChanged: (text) => {},
      //(_userData != null ? '${_userData.email}' : ''),
      validator: validateEmail,
      onSaved: (String value) {
        this._userEmail = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        filled: true,
        fillColor: Color(0xFFF0F0F0),
        hintText: 'your e-mail',
        hintStyle: TextStyle(color: Colors.black45),
        labelText: 'E-Mail',
//        helperText: 'enter your e-mail userAddress',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user name ////
    final userName = TextFormField(
      focusNode: _usernameFocusNode,
      autofocus: true,
      keyboardType: TextInputType.name,
      controller: usernameController,
      //TextEditingController()..text = _userName,
      onChanged: (text) => {},
      //(_userData != null ? '${_userData.username}' : ''),
//      initialValue: 'alucard@gmail.com',
      validator: validateName,
      onSaved: (String value) {
        this._userName = value;
      },
      // onFieldSubmitted: (_) {
      //   fieldFocusChange(context, _usernameFocusNode, _emailFocusNode);
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
        hintText: 'username',
        labelText: 'Username',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user password ////
    final userPassword = TextFormField(
      autofocus: true,
      // initialValue: 'some userPassword',
      obscureText: !_invisiblePass,
      validator: validatePassword,
      controller: passwordController,
      // ..text = !_invisiblePass ? ('*' * _userPassword.length) : _userPassword,
      onChanged: (text) => {
        !_invisiblePass ? ('*' * _userPassword.length) : _userPassword,
      },
      // (_userData != null ? '${_userData.password}' : ''),
      onSaved: (String value) {
        this._userPassword = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _passwordFocusNode, _addressFocusNode);
      },
      style: kMainContentStyleLightBlack,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            _showPassword();
          },
          child: Icon(
            _invisiblePass ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF03B898),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF03B898), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        filled: true,
        fillColor: Color(0xFFF0F0F0),
        hintText: 'password',
        labelText: 'Password',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );

    //// user address ////
    final userAddress = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      maxLines: null,
      textAlign: TextAlign.start,
      controller: addressController,
      //..text = _userAddress,
      onChanged: (text) => {},
      // (_userData != null ? '${_userData.address}' : ''),
//      initialValue: 'alucard@gmail.com',
      validator: validateAddress,
      onSaved: (String value) {
        this._userAddress = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _addressFocusNode, _phoneFocusNode);
      },
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
        hintText: 'your address',
        labelText: 'Address',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user country ////
    final userCountryDropdown = Container(
      padding: EdgeInsets.symmetric(vertical:2.0, horizontal: 4.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
            10.0,
          )),
          color: Color(0xFFF0F0F0),
          shape: BoxShape.rectangle),
      child: DropdownButton<CountryModel>(
        isExpanded: true,
        hint: Text(
          'Select Country',
          style: kMainContentStyleLightBlack,
        ),
        autofocus: true,
        value: _selectedUserCountry,
        //_selectedUserCountry,
        isDense: false,
        onChanged: onChangeDropdownItem,
        //(_) => onChangeDropdownItem(_selectedUserCountry),//onChangeDropdownItem,
        //     (CountryModel value) {
        //   setState(() {
        //     _selectedUserCountry = value;
        //     _userCountry = value.name;
        //     countryCodeTxt = value.dial_code;
        //     _userCountryId = value.id.toString();
        //   });
        // },
        items: _countryList.map((country) {
          return DropdownMenuItem<CountryModel>(
            child: new Text(country.name),
            value: country,
          );
        }).toList(),
        style: kMainContentStyleLightBlack,
      ),
    );

    final phoneCountryCode = Container(
      alignment: Alignment.center,
      child: Text(
        countryCodeTxt,
        style: kMainContentStyleLightBlack,
      ),
    );

    //// user phone ////
    final userPhoneNumber = TextFormField(
      inputFormatters: [
        new LengthLimitingTextInputFormatter(10),
      ],
      keyboardType: TextInputType.phone,
      autofocus: true,
      focusNode: _phoneFocusNode,
//      initialValue: 'alucard@gmail.com',
      controller: phoneController,
      //..text = _userMobile,
      //(_userData != null ? '${_userData.mobile}'.replaceAll(re, '') : ''),
      onChanged: (text) => {},
      validator: validatePhone,
      onSaved: (String value) {
        this._userPhoneNo = countryCodeTxt + value;
      },
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
        hintText: 'mobile number',
        labelText: 'Mobile Number',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user title ////
    final userTitle = Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
          child: Text(
            'Your Profile',
            style: TextStyle(
              color: Colors.black87,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
              fontSize: 32.0,
            ),
          ),
        ));

    //// continue button ////
    final userContinueBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          if (!_userFormEditKey.currentState.validate()) {
            return;
          } else {
            _userFormEditKey.currentState.save();
//            _navigateToPetProfileScreen();
            _isLoading ? null : _handleSubmit(context);
          }
        },
        padding: EdgeInsets.all(12),
        color: Color(0xFF03B898),
        child: Container(
          width: 220.0,
//          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
          child: Text(
            _isLoading ? 'Creating...' : 'Create',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    final userSaveBtn = Container(
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
                    child: UserProfileViewScreen(),
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
                //
                if (!_userFormEditKey.currentState.validate()) {
                  return;
                } else {
                  _userFormEditKey.currentState.save();

                  setState(() => _autoValidate = true);
                  print(_userName);
                  print(_userEmail);
                  print(_userPassword);
                  print(_userAddress);
                  print(_userPhoneNo);
//            _navigateToPetProfileScreen();
                  _isLoading ? null : _handleSubmit(context);
                }
                // _handleSave(context),
                // Navigator.of(context).pop(
                //   PageTransition(
                //     child: UserProfileViewScreen(),
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
    //// user input form ////
    Widget userForm() {
      return new Container(
        // height: MediaQuery.of(context).size.height * 0.9,
        // margin: EdgeInsets.only(bottom: 180.0),
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _userFormEditKey,
              autovalidate: _autoValidate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  userTitle,
                  SizedBox(height: 20.0),
                  userName,
                  SizedBox(height: 20.0),
                  userEmail,
                  SizedBox(height: 20.0),
                  userPassword,
                  SizedBox(height: 20.0),
                  userAddress,
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: userCountryDropdown,
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: phoneCountryCode,
                      ),
                      Expanded(
                        flex: 8,
                        child: userPhoneNumber,
                      ),
                    ],
                  ),
                  SizedBox(height: 32.0),
                  userSaveBtn,
                ],
              ),
            ),
          ),
        ),
      );
    }

    //// main body ////
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
          // mainAxisAlignment: MainAxisAlignment.start,
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
                    ? userForm()
                    : new Center(
                        widthFactor: 120.0,
                        heightFactor: 120.0,
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
//               ),
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

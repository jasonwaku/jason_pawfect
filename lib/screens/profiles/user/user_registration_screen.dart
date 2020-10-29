import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/models/users/country_model.dart';
import 'package:pawfect/models/response_api.dart';
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_registration_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/provider/api_provider.dart';
import 'package:pawfect/utils/provider/db_provider.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserRegistrationScreen extends StatefulWidget {
  static String tag = 'user-registration-page';

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  bool isFirst = false;

  Future<CountryModel> _futureCountryList;

  // Future<CountryModel> getCountries() async {
  //
  // }
//
  List<String> _countries = [
    'Australia',
    'United States',
    'United Kingdom',
    'Canada',
    'New Zealand',
  ];

  String _userCountry;

  // String _countryApiUrl = 'countries/fetch_all';
  List<CountryModel> countryData = List<CountryModel>();
  CountryModel _selectedUserCountry;

  String _userName;
  String _userEmail;
  String _userPassword;
  String _userAddress;
  String _userPhoneNo;

  // String _userCountryId;
  String _userCountryId = '';
  bool _invisiblePass = false;
  bool _isLoading = false;
  bool _isSubscribed = false;
  bool _isImperial = false;
  String _role = 'user';
  User userData;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String countryCodeTxt = '00';
  String countryCode = '00';

  //
  final GlobalKey<FormState> _userRegisterFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _countryFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();

  SharedPreferences userPrefs;

  UserCreate _user;

  bool _autoValidate = false;

  ProgressDialog pr;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];
  Color successAPI = Colors.green[400];

  bool isLoading = false;

  @override
  void initState() {
    //
    super.initState();
    _getLocalData();
    //
  }

  _getLocalData() async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirst = prefs.getBool('first_time');
    //
    _countryList =  await _fetchCountries();
  }

  // Future<
  List<CountryModel> _countryList = new List<CountryModel>();

  Future<List<CountryModel>> _fetchCountries() async {
    //
    setState(() {
      isLoading = true;
    });

    // pr.show();

    String jsonString = await DefaultAssetBundle.of(context).loadString("assets/json/country.json");

    http.Response response = http.Response(jsonString, 200, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    });
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      _countryList = countryModelFromJson(response.body);
      // pr.hide();
      return _countryList;
      // return countryModelFromJson(response.body);
    } else {
      setState(() {
        isLoading = false;
      });
      // pr.hide();
      // _showSnackbar(, clr)
      throw Exception();
    }
    // String url = 'countries/fetch_all';
    // var apiProvider = ApiProvider();
    // await apiProvider.getAllCountries(url);
    // //
    // _countryList = await DBProvider.db.getAllCountries();

    // setState(() {
    //   isLoading = false;
    // });
    //
    // pr.hide().whenComplete(
    //       () => _countryList,
    //     );
    //
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // isFirst = prefs.getBool('first_time');
    //
    // final response = await CallApi().getData(_countryApiUrl);
    // if (response.statusCode == 200) {
    //   // final items = json.decode(response.body).cast<Map<String, dynamic>>();
    //   // List<CountryModel> _countryList = items.map<CountryModel>((json) {
    //   //   return CountryModel.fromJson(json);
    //   // }).toList();
    //
    //   // return listOfUsers;
    //   // If the call to the server was successful, parse the JSON
    //   List<dynamic> values = new List<dynamic>();
    //   values = json.decode(response.body);
    //   if (values.length > 0) {
    //     for (int i = 0; i < values.length; i++) {
    //       if (values[i] != null) {
    //         Map<String, dynamic> map = values[i];
    //         _countryList.add(CountryModel.fromJson(map));
    //         debugPrint('Id-------${map['id']}');
    //         debugPrint('code-------${map['code']}');
    //         // debugPrint('countryId-------${map['country_id']}');
    //         debugPrint('dialCode-------${map['dial_code']}');
    //         debugPrint('name-------${map['name']}');
    //       }
    //     }
    //   }
    //   return _countryList;
    // } else {
    //   // If that call was not successful, throw an error.
    //   throw Exception('Failed to load data');
    // }
  }

  onChangeDropdownItem(CountryModel selectedCountry) {
    setState(() {
      // fieldFocusChange(context, _countryFocusNode, _phoneFocusNode);
      _selectedUserCountry = selectedCountry;
      _userCountry = _selectedUserCountry.name;
      countryCodeTxt = _selectedUserCountry.dial_code;
      countryCode = _selectedUserCountry.code;
      _userCountryId = _selectedUserCountry.id.toString();
      // _userCountry = _countryList[selectedCountry].toString();
      // print(_selectedUserCountry);
      // countryCodeTxt = selectedCountry;
      // countryDialCode(_selectedUserCountry);
      // print(countryCodeTxt);
      // print('---------');
      // _userCountry = _selectedUserCountry;
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

  void countryDialCode(String country) {
// ignore: unrelated_type_equality_checks
    countryCodeTxt = _countryList.where((item) => item == country).toString();
    // switch (country) {
    //   case 'United States':
    //     {
    //       countryCodeTxt = '+1';
    //     }
    //     break;
    //   case 'Unites Kingdom':
    //     {
    //       countryCodeTxt = '+44';
    //     }
    //     break;
    //   case 'Australia':
    //     {
    //       countryCodeTxt = '+61';
    //     }
    //     break;
    //     break;
    //   case 'New Zealand':
    //     {
    //       countryCodeTxt = '+64';
    //     }
    //     break;
    //     break;
    //   case 'Canada':
    //     {
    //       countryCodeTxt = '+1';
    //     }
    //     break;
    //   default:
    //     {
    //       countryCodeTxt = '00';
    //     }
    //     break;
    // }
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
    Navigator.of(context).push(PageTransition(
      child: PetRegistrationScreen(),
      type: PageTransitionType.rightToLeft,
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
    Timer(Duration(seconds: 2), () {
      Navigator.of(_userRegisterFormKey.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      //Navigator.pushReplacementNamed(context, "/home");
      _navigateToPetProfileScreen();
//      Navigator.of(context).pushNamed(HomeScreen.tag);
    });
  }

  Future<void> _handleSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context); //, _userRegisterFormKey);
    saveUserData();
    // }catch(e){
    //   String errorMessage = e.toString();
    //   // TODO: Do something with the error message,
    //   buildAlertDialog('An Error Occurred! \n$errorMessage' );
    // }
    // Navigator.of(context).pop();
    // LoadingDialog.hideLoadingDialog(context);
    // print(body);
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

//   saveUserData() async {
//     String _mobile = countryCodeTxt +
//         (phoneController.text).replaceFirst(new RegExp(r'0'), '');
//
//     USER.User userData = USER.User(
//         user: USER.UserClass(
//       email: emailController.text,
//       address: addressController.text,
//       imperial: _isImperial.toString(),
//       mobile: _mobile,
//       password: passwordController.text,
//       role: _role,
//       subscribed: _isSubscribed.toString(),
//       username: usernameController.text,
//       countryId: '1',
//     ));
// //
//     final result = await CallApi().createUser(userData);
//     print('result from post : ' + result.toString());
//       //
//       // return APIResponse<bool>(data: true);
//     // }
//     //     .then((isSuccess){
//       setState(() {
//         _isLoading = false;
//       });
//
//     //for local reference
//     SharedPreferences localStorageUser =
//     await SharedPreferences.getInstance();
//     // localStorageUser.setString('userToken', parsedData['token']);
//     // localStorageUser.setString('userData', json.encode(parsedData['user']));
//     localStorageUser.setString('userCountry', _userCountry);
//     //
//     // print('token : ' + parsedData['token']);
//     // print('user : ' + json.encode(parsedData['user']));
//     print('country : ' + _userCountry);
//     //
//     final title = 'User Registration';
//     final text = result.error ? (result.errorMessage ?? 'An error occurred') : 'Registered Successfully! ';
//
//     showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text(title),
//           content: Text(text),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             )
//           ],
//         )
//     ).then((data) {
//       if (result.data) {
//         Navigator.of(context).pop();
//       }
//     });
//
//     _setNavigation();
//
//     //   if (isSuccess != null){
//     //
//     //   }
//     // });
//     // var res =  CallApi().postData(userData, 'users/create');
//     // var res = CallApi().createUser(userData, 'users/create');
//     // print('//////// ' + res.toString() + ' //////////');
//     // final String response = res.body;
//     // final int statusCode = res.statusCode;
//     //
//     // if (statusCode < 200 || statusCode > 400 || json == null) {
//     //   return APIResponse<bool>(
//     //       error: true, errorMessage: "Error while fetching data");
//     // } else {
//       //Parsing json response to particular Object.
//       // print(json.decode(res));
//       // var parsedData = json.decode(response);
//       // print('parsed data : ' + parsedData);
//       // final userD = userCreateFromJson(parsedData);
//       // print('object from json : ' + userD.toString());
//
//       // if (parsedData['success']) {
//
//       //   return APIResponse<bool>(data: true);
//       // }
//
//       //     .then((response){
//       //   if(res.success >= 200){
//       //     print(response.body);
//       //   }
//       //   else{
//       //     print(response.statusCode);
//       // }).catchError((error){
//       //   print('error : $error');
//       // });
//       // print('Response status: ${res.statusCode}');
//       // if (res == null) {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   buildAlertDialog();
//       //   debugPrint("error " + res);
//       // } else {
//       // print('Response body: ${res.body}');
//       // var body = json.decode(res);
//       // if (body['success']) {
//       //   //for local reference
//       //   SharedPreferences localStorageUser =
//       //       await SharedPreferences.getInstance();
//       //   localStorageUser.setString('userToken', body['token']);
//       //   localStorageUser.setString('userData', json.encode(body['user']));
//       //   localStorageUser.setString('userCountry', _userCountry);
//       //
//       //   print(body);
//       //   print(body['token']);
//       //   print(_userCountry);
//       //   //
//       //   _setNavigation();
//       //   //
//       // }
//     }
  // }
  //

  saveUserData() async {
    pr.show();
    String _mobile = countryCodeTxt +
        (phoneController.text).replaceFirst(new RegExp(r'0'), '');

    var userData = {
      'user': {
        "email": emailController.text,
        "address": addressController.text,
        "imperial": _isImperial.toString(),
        "mobile": _mobile,
        "password": passwordController.text,
        "role": _role,
        "subscribed": _isSubscribed.toString(),
        "username": usernameController.text,
        "country_id": _userCountryId,
      }
    };
    // LoadingDialog.showLoadingDialog(context, _userRegisterFormKey);
    final user = await CallApi().createTheUser(userData, 'users/create');
    if (user != null) {
      if (user.success) {
        setState(() {
          _user = user;
        });
        userPrefs = await SharedPreferences.getInstance();
        userPrefs.remove('user_token');
        userPrefs.remove('user_email');
        userPrefs.remove('user_id');
        userPrefs.remove('user_subscribed');
        userPrefs.remove('user_imperial');
        //
        userPrefs.setString('user_token', _user.token);
        // userPrefs.setString('user_data', json.encode(_user.user));
        userPrefs.setString('user_email', _user.user.email);
        userPrefs.setString('user_id', _user.user.id.toString());
        userPrefs.setBool('user_subscribed', _user.user.subscribed);
        userPrefs.setBool('user_imperial', _user.user.imperial);
        //
        userPrefs.setString('user_country', _userCountry);
        userPrefs.setString('user_country_id', _userCountryId);
        userPrefs.setString('user_country_dial', countryCodeTxt);
        userPrefs.setString('user_country_code', countryCode);
        // userPrefs.setString('user_country_model', _selectedUserCountry.toString());
        // print(_selectedUserCountry.toString());
        // userPrefs.setString('user_password', passwordController.text);
        userPrefs.setString('user_name', usernameController.text);

        //
        print('token : ' + _user.token);
        print('user : ' + _user.user.toString());
        print('user json: ' + json.encode(user.user));
        print('user email : ' + _user.user.email);
        print('user id : ' + _user.user.id.toString());
        print('user password : ' + passwordController.text);
        //
        // Navigator.pop(context);
        pr.hide();
            // .whenComplete(() {
          // Navigator.of(_userRegisterFormKey.currentContext, rootNavigator: true)
          //     .pop(); //close the dialoge
          //Navigator.pushReplacementNamed(context, "/home");
          _navigateToPetProfileScreen();
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
        // Navigator.of(context).pop();
        // var snackbar = new SnackBar(
        //   content: new Text("Cars enabled"),
        //   backgroundColor: Colors.white,
        //   duration: new Duration(seconds: 2),
        // );
        // Scaffold.of(context).showSnackBar(SnackBar(
        //   content: new Text("Cars enabled"),
        //   backgroundColor: Colors.red,
        //   duration: new Duration(seconds: 2),
        // ));
        // _showScaffold('jjjjjjj \n$msg');
        // buildAlertDialog('An Error Occurred. \n$msg' ); //\n$msg'
      }
      // setState(() {
      //   _isLoading = false;
      // });
      // // Navigator.pop(context);
      // _showSnackbar('ooooooo');
    } else {
      setState(() {
        _isLoading = false;
      });
      pr.hide().whenComplete(() {
        _showSnackbar('A Network Error Occurred.!', errorNet);
      });
      // buildAlertDialog('A Network Error Occurred.' );
    }
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

  Future<bool> saveUserPreferences(User user) async {
    userPrefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson()); //userPrefs.getString('user');
    // Map decodeOptions = jsonDecode(userJson);
    // String user = jsonEncode(User.fromJson(decodeOptions));
    userPrefs.setString('userData', userJson);
    print(userJson);
    return userPrefs.commit();
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
    //// user email ////
    final userEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      controller: emailController,
//      initialValue: 'alucard@gmail.com',
      validator: validateEmail,
      onSaved: (String value) {
        this._userEmail = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
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
        hintText: 'enter your e-mail',
        hintStyle: TextStyle(color: Colors.black45),
        labelText: 'Email',
//        helperText: 'enter your e-mail userAddress',
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user name ////
    final userName = TextFormField(
      focusNode: _usernameFocusNode,
      autofocus: true,
      keyboardType: TextInputType.name,
      controller: usernameController,
//      initialValue: 'alucard@gmail.com',
      validator: validateName,
      onSaved: (String value) {
        this._userName = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _usernameFocusNode, _emailFocusNode);
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
        hintText: 'enter username',
        labelText: 'Username',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user password ////
    final userPassword = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: true,
      controller: passwordController,
//      initialValue: 'some userPassword',
      obscureText: !_invisiblePass,
      validator: validatePassword,
      // onChanged: (val) {
      //   // setState(() {
      //     _userPassword = val;
      //   // });
      // },
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
        hintText: 'enter a password',
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
      keyboardType: TextInputType.streetAddress,
      autofocus: false,
      maxLines: null,
      textAlign: TextAlign.start,
      controller: addressController,
//      initialValue: 'alucard@gmail.com',
      validator: validateAddress,
      onSaved: (String value) {
        _userAddress = value;
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
        hintText: 'enter your address',
        labelText: 'Address',
        hintStyle: TextStyle(color: Colors.black45),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    //// user country ////
    final userCountryDropdown = Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
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
        isDense: false,
        onChanged: onChangeDropdownItem,
        //     (value) {
        //   setState(() {
        //     _selectedUserCountry = value;
        //     _userCountry = value.name;
        //     countryCodeTxt = value.dialCode;
        //     _userCountryId = value.countryId;
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
      controller: phoneController,
//      initialValue: 'alucard@gmail.com',
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
        hintText: 'enter phone number',
        labelText: 'Phone Number',
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
      ),
    );

    //// continue button ////
    final userContinueBtn =
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 76.0),
        //   child:
        FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        if (!_userRegisterFormKey.currentState.validate()) {
          return;
        } else {
          _userRegisterFormKey.currentState.save();
          setState(() => _autoValidate = true);
          // print(_userName);
          // print(_userEmail);
          // print(_userPassword);
          // print(_userAddress);
          // print(_userPhoneNo);
//            _navigateToPetProfileScreen();
          _isLoading ? null : _handleSubmit(context);
        }
      },
      padding: EdgeInsets.all(12),
      color: Color(0xFF03B898),
      child: Container(
        width: MediaQuery.of(context).size.width,
//          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
        child: Text(
          _isLoading ? 'CREATING...' : 'CONTINUE',
          style: kMainHeadingStyleWhite,
          textAlign: TextAlign.center,
        ),
      ),
      // ),
    );

    final backToLoginBtn =
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 76.0),
        //   child:
        // !isFirst
        //     ? Container(
        //         child: Text(''),
        //       )
        //     :
        FlatButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Color(0xFF03B898), width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(PageTransition(
          child: LoginScreen(),
          type: PageTransitionType.rightToLeft,
        ));
        // (PageTransition(
        //   child: PetRegistrationScreen(),
        //   type: PageTransitionType.rightToLeft,
        // ));
//         if (!_userRegisterFormKey.currentState.validate()) {
//           return;
//         } else {
//           _userRegisterFormKey.currentState.save();
//           setState(() => _autoValidate = true);
//           // print(_userName);
//           // print(_userEmail);
//           // print(_userPassword);
//           // print(_userAddress);
//           // print(_userPhoneNo);
// //            _navigateToPetProfileScreen();
//           _isLoading ? null : _handleSubmit(context);
//         }
      },
      padding: EdgeInsets.all(12),
      color: Colors.transparent,
      //Color(0xFF03B898),
      child: Container(
        width: MediaQuery.of(context).size.width,
//          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
        child: Text(
          'Back to Login', //_isLoading ? 'CREATING...' : 'CONTINUE',
          style: TextStyle(
            color: Color(0xFF03B898),
            fontFamily: 'poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      // ),
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
    final userForm = Container(
      // color: Colors.transparent,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _userRegisterFormKey, //_userFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // SizedBox(height: 2.0),
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
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                        10.0,
                      )),
                      color: Color(0xFFF0F0F0),
                      shape: BoxShape.rectangle),
                  child: Row(
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
                ),
                SizedBox(height: 24.0),
                userContinueBtn,
                SizedBox(height: 12.0),
                backToLoginBtn,
              ],
            ),
          ),
        ),
      ),
    );

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
            Expanded(flex: 2, child: logo),
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     alignment: Alignment.center,
            //     margin: EdgeInsets.only(top:12.0),
            //     child: Center(
            //       child: Image.asset(
            //         'assets/images/logo_small.png',
            //         height: 150.0,
            //         width: 150.0,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //   ),
            // ),
            // Expanded(
            //   flex: 4,
            //   child:
            Expanded(
              flex: 5,
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
                child: userForm, //Text('this text here'),
              ),
            ),
//                    ),
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
      // SingleChildScrollView(
      //   child:
      // ),
    );
  }
}

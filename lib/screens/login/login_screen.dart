import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/navigation/general_home_screen.dart';
import 'package:pawfect/screens/login/forgot_password_screen.dart';
import 'package:pawfect/screens/navigation/premium_home_screen.dart';
import 'package:pawfect/screens/navigation/pro_home_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_registration_screen.dart';
import 'package:pawfect/screens/profiles/user/user_registration_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/loader.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/local/pawfect_shared_prefs.dart';

// import 'package:pawfect/utils/ri_keys.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:pawfect/utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>(); //GlobalKey<FormState>
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController(text: "email");
  TextEditingController passwordController =
      TextEditingController(text: "password");

  String _userEmail;
  String _userPassword;

  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _invisiblePass = false;
  String userIsSubscribed;
  SharedPreferences userPrefs;
  User _userData;

  ProgressDialog pr;

  Color errorAPI = Colors.red[400];
  Color errorNet = Colors.amber[400];

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    // _getUserInfo();
    // getUserData().then(updateView);
    // _checkIfLoggedIn();
  }

  // get  user info from prefs //
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

  void _checkIfLoggedIn() async {
    //check if token is there
    //validate the token
    userPrefs = await SharedPreferences.getInstance();
    var userToken = userPrefs.getString('token');
    print(userToken);
    if (userToken != null) {
      setState(() {
        _isLoggedIn = true;
      });
      //
      Navigator.of(context).popAndPushNamed(GeneralHomeScreen.tag);
    }
  }

  Future<User> getUserData() async {
    userPrefs = await SharedPreferences.getInstance();
    String userData = userPrefs.getString('userData');
    Map jsonString = json.decode(userData);
    User user = User.fromJson(jsonString);
    return user;
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Login Error...",
          style: kMainContentStyleDarkBlack,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _setNavigation() {
    Timer(Duration(seconds: 3), () {
      // Navigator.of(_loginkey.currentContext, rootNavigator: true)
      //     .pop(); //close the dialoge
      //Navigator.pushReplacementNamed(context, "/home");
      userIsSubscribed == 'false'
          ? Navigator.of(context).push(PageTransition(
              child: GeneralHomeScreen(),
              type: PageTransitionType.rightToLeft,
            ))
          : Navigator.of(context).push(PageTransition(
              child: ProHomeScreen(),
              type: PageTransitionType.rightToLeft,
            ));
      // Navigator.of(context).pushReplacement(PageTransition(
      //   child: GeneralHomeScreen(),
      //   type: PageTransitionType.rightToLeft,
      // ));
//      Navigator.of(context).pushNamed(HomeScreen.tag);
    });
  }

  Future<void> _loginSubmit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    // LoadingDialog.showLoadingDialog(context);//,_loginKey);
    // _login();
    pr.show();
    String emailVal = emailController.text;
    String passVal = passwordController.text;
    var data = {
      "user": {
        "email": emailVal,
        "password": passVal,
      }
    };

    // final UserCreate
    final res = await CallApi().loginUser(data, 'login');
    // var body = json.decode(res.body);
    if (res != null) {
      if (res.success) {
        UserCreate _user;
        setState(() {
          _user = res;
        });
        userPrefs = await SharedPreferences.getInstance();
        userPrefs.remove('user_token');
        userPrefs.remove('user_email');
        userPrefs.remove('user_id');
        userPrefs.remove('user_subscribed');
        userPrefs.remove('user_imperial');
        // userPrefs.remove('pet_id');
        var userToken = userPrefs.setString('user_token', _user.token);
        var userEmail = userPrefs.setString('user_email', _user.user.email);
        var userId = userPrefs.setString('user_id', _user.user.id.toString());
        var userSubscribed =
            userPrefs.setBool('user_subscribed', _user.user.subscribed);
        var userInput = userPrefs.setBool('user_imperial', _user.user.imperial);
        print(userToken);
        print(userEmail);
        print(userId);
        print(userSubscribed);
        print(userInput);
        //
        //
        // var userSubscribed =
        //     userPrefs.setString('subscribed', res.user.subscribed.toString());
        // var petID = userPrefs.getString('pet_id');
        // var userSubscribed = userPrefs.getString('user_subscribed');
        // userPrefs.setString('user_data', json.encode(body['user']));
        // ignore: unrelated_type_equality_checks
        userIsSubscribed = userSubscribed.toString();
        PawfectSharedPrefs.instance.setBooleanValue("isLoggedIn", true);

        pr.hide().whenComplete(() {
          String petId = userPrefs.getString('pet_id');
          if (petId != null) {
            userIsSubscribed == 'false'
                ? Navigator.of(context).push(PageTransition(
                    child: GeneralHomeScreen(),
                    type: PageTransitionType.rightToLeft,
                  ))
                : Navigator.of(context).push(PageTransition(
                    child: ProHomeScreen(),
                    type: PageTransitionType.rightToLeft,
                  ));
          } else {
            if (_user.user.petsInfo != null) {
              userPrefs.remove('pet_id');
              userPrefs.remove('pet_name');
              userPrefs.remove('pet_age');
              String pet_id = _user.user.petsInfo[0].id.toString();
              String pet_name = _user.user.petsInfo[0].name.toString();
              // String pet_age = _user.user.petsInfo[0].id.toString();
              userPrefs.setString('pet_id', pet_id);
              userPrefs.setString('pet_name', pet_id);
              userIsSubscribed == 'false'
                  ? Navigator.of(context).push(PageTransition(
                      child: GeneralHomeScreen(),
                      type: PageTransitionType.rightToLeft,
                    ))
                  : Navigator.of(context).push(PageTransition(
                      child: ProHomeScreen(),
                      type: PageTransitionType.rightToLeft,
                    ));
              //_setNavigation();
            } else {
              Navigator.of(context).push(PageTransition(
                child: PetRegistrationScreen(),
                type: PageTransitionType.rightToLeft,
              ));
            }
          }
        });
        //update user userToken
        // var tokenData = {
        //   'user_email': emailController.text,
        //   'user_token': userToken,
        // };
        // var resToken = await CallApi().postData(tokenData, 'update_user_token');
        // var updateToken = json.decode(resToken.body);
        // if (updateToken['success']) {
        //   !userIsSubscribed
        //       ? Navigator.of(context).popAndPushNamed(GeneralHomeScreen.tag)
        //       : Navigator.of(context).popAndPushNamed(PremiumHomeScreen.tag);
        // }
        // }
        //
        // if (emailController.text != (_userData.user_email) &&
        //     passwordController.text != _userData.password) {
        //   //toast here
        //   Scaffold.of(context).showSnackBar(SnackBar(
        //     content: Text("Incorrect Email or Password"),
        //   ));
        // } else {
        //   // _setNavigation;
        // }
      } else {
        String msg = res.message;
        print(msg);
        setState(() {
          _isLoading = false;
        });
        pr.hide().whenComplete(() {
          // buildAlertDialog();
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
      // buildAlertDialog('A Network Error Occurred.' );
    }
//  print(body);
    pr.hide().whenComplete(() {
      _showSnackbar('Please try again', errorAPI);
    });
    setState(() {
      _isLoading = false;
    });
  }

  _login() async {
    // var data = {
    //   "user": {
    //     "email": emailController.text,
    //     "password": passwordController.text
    //   }
    // };
    //
    // final UserCreate res = await CallApi().loginUser(data, 'login');
    // // var body = json.decode(res.body);
    // if (res.success) {
    //   userPrefs = await SharedPreferences.getInstance();
    //   userPrefs.remove('user_token');
    //   userPrefs.remove('user_email');
    //   var userToken = userPrefs.setString('user_token', res.token);
    //   var userEmail = userPrefs.setString('user_email', res.user.email);
    //   // var userSubscribed =
    //   //     userPrefs.setString('subscribed', res.user.subscribed.toString());
    //
    //   var petID = userPrefs.getString('pet_id');
    //   var userSubscribed = userPrefs.getString('user_subscribed');
    //   // userPrefs.setString('user_data', json.encode(body['user']));
    //   // ignore: unrelated_type_equality_checks
    //   userIsSubscribed = userSubscribed.toString();
    //   PawfectSharedPrefs.instance.setBooleanValue("isLoggedIn", true);
    //
    //   if(petID != null){
    //     _setNavigation();
    //   }else{
    //     Navigator.of(context).pushReplacement(PageTransition(
    //       child: PetRegistrationScreen(),
    //       type: PageTransitionType.rightToLeft,
    //     ));
    //   }
    //   //update user userToken
    //   // var tokenData = {
    //   //   'user_email': emailController.text,
    //   //   'user_token': userToken,
    //   // };
    //   // var resToken = await CallApi().postData(tokenData, 'update_user_token');
    //   // var updateToken = json.decode(resToken.body);
    //   // if (updateToken['success']) {
    //   //   !userIsSubscribed
    //   //       ? Navigator.of(context).popAndPushNamed(GeneralHomeScreen.tag)
    //   //       : Navigator.of(context).popAndPushNamed(PremiumHomeScreen.tag);
    //   // }
    //   // }
    //   //
    //   // if (emailController.text != (_userData.user_email) &&
    //   //     passwordController.text != _userData.password) {
    //   //   //toast here
    //   //   Scaffold.of(context).showSnackBar(SnackBar(
    //   //     content: Text("Incorrect Email or Password"),
    //   //   ));
    //   // } else {
    //   //   // _setNavigation;
    //   // }
    // } else {
    //   // _showMsg(body['message']);
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   buildAlertDialog();
    // }
  }

//   Future<void> _handleLogin(BuildContext context) async {
//     try {
//       // prefs = await SharedPreferences.getInstance();
//       // prefs.setString('userEmail',_userEmail);
//       //
//       if (_userData.userEmail == _userEmail &&
//           _userData.userPassword == _userPassword) {
//         LoadingDialog.showLoadingDialog(context, _loginkey); //invoking login
// //    await service.login(user.uid);
//         _setNavigation();
//       } else {
//         LoadingDialog.showLoadingDialog(context, _loginkey); //invoking login
//         showAlert(context);
//       }
//       //clear on log out
// //      SharedPreferences prefs = await SharedPreferences.getInstance();
// //      prefs.remove('email');
// //
//
//       //
//     } catch (error) {
//       print(error);
//     }
//   }

  void _navigateToForgotPassword() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: ForgotPasswordScreen(),
      type: PageTransitionType.rightToLeft,
    ));
  }

  void _navigateToUserRegistration() {
    Navigator.of(context).push(PageTransition(
      child: UserRegistrationScreen(),
      type: PageTransitionType.rightToLeft,
    ));
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  showAlert(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Retry"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Authentication Failed"),
      content: Text("Incorrect UserName or Password."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showPassword() {
    setState(() {
      _invisiblePass = !_invisiblePass;
    });
  }

//  void _navigateToPetProfileScreen() {
//    Navigator.of(context).pushReplacement(PageTransition(
//      child: PetProfileScreen(),
//      type: PageTransitionType.rightToLeft,
//    ));
////        MaterialPageRoute(builder: (BuildContext context) => PetProfileScreen()));
//  }

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
    final logo = Container(
      padding: EdgeInsets.only(top: 12.0),
      child: Center(
        child: Image.asset(
          'assets/images/logo_large.png',
          fit: BoxFit.cover,
        ),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      controller: emailController,
      validator: validateEmail,
      onSaved: (String value) {
        this._userEmail = value;
      },
      onFieldSubmitted: (_) {
        fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);
      },
      style: kMainHeadingStyleWhite,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        filled: true,
        fillColor: Color(0xFF3ebfa9),
        hintText: 'Enter your e-mail',
        hintStyle: kMainContentStyleWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.visiblePassword,
      autofocus: true,
      controller: passwordController,
      obscureText: !_invisiblePass,
      validator: validatePassword,
      onSaved: (String value) {
        this._userPassword = value;
      },
      focusNode: _passwordFocusNode,
      style: kMainHeadingStyleWhite,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            _showPassword();
          },
          child: Icon(
            _invisiblePass ? Icons.visibility : Icons.visibility_off,
            color: Colors.black45,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        ),
        filled: true,
        fillColor: Color(0xFF3ebfa9),
        hintText: 'Enter password',
        hintStyle: kMainContentStyleWhite,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          if (!_loginKey.currentState.validate()) {
            return;
          } else {
            _loginKey.currentState.save();
            print(_userEmail);
            print(_userPassword);
            _isLoading ? null : _loginSubmit(context); //_handleLogin(context);
          }
//          Navigator.of(context).pushNamed(HomeScreen.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            _isLoading ? 'LOGIN IN...' : 'LOG IN',
            style: TextStyle(
              color: Color(0xFF01816B),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    final forgotLabel = Container(
      alignment: Alignment.topRight,
      child: FlatButton(
        child: Text(
          'Forgot password?',
          style: kSubContentStyleBlack,
          textAlign: TextAlign.end,
        ),
        onPressed: () {
          _navigateToForgotPassword();
//          Navigator.of(context).pushNamed(ForgotPasswordScreen.tag);
        },
      ),
    );

    final registerUser = Container(
      alignment: Alignment.center,
      child: FlatButton(
        child: Text(
          'Sign up for an Account',
          style: kMainContentStyleWhite,
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          _navigateToUserRegistration();
//          Navigator.of(context).pushNamed(ForgotPasswordScreen.tag);
        },
      ),
    );

    final loginForm = Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              // padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                SizedBox(height: 12.0),
                email,
                SizedBox(height: 12.0),
                password,
                forgotLabel,
                registerUser,
                SizedBox(height: 32.0),
                loginButton,
              ],
            ),
          ),
        ),
      ),
    );

    final body = Container(
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
              flex: 1,
              child: loginForm, //Text('this text here'),
            ),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: body,
      ),
    );
  }
}

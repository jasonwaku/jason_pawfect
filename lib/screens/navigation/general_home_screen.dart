import 'dart:async';

import 'package:pawfect/models/users/user_model.dart';
import 'package:pawfect/screens/blank_screen.dart';
import 'package:pawfect/screens/daily_guide/daily_guide_screen.dart';
import 'package:pawfect/screens/navigation/premium_home_screen.dart';
import 'package:pawfect/screens/navigation/pro_home_screen.dart';
import 'package:pawfect/utils/network/call_api.dart';
import 'package:pawfect/utils/cosmetic/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_view_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_view_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralHomeScreen extends StatefulWidget {
  static String tag = 'general-home-page';

  @override
  _GeneralHomeScreenState createState() => _GeneralHomeScreenState();
}

class _GeneralHomeScreenState extends State<GeneralHomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isSubscribed = false;

  final List<Widget> _children = [
    DailyGuideScreen(),
    UserProfileViewScreen(),
  ];
  Color darkGreen = Color(0xFF01816B);
  Color lightGreen = Color(0xFF03B898);

  void navigateToUserProfileViewScreen() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: UserProfileViewScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
    // Timer(Duration(seconds: 3), () {
    //  // Navigator.of(context).pushNamed(HomeScreen.HomeScreen.tag);
    // });
  }

  void navigateToPetProfileViewScreen() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: PetProfileViewScreen(),
      type: PageTransitionType.rightToLeftWithFade,
    ));
    // Timer(Duration(seconds: 3), () {
    //   // Navigator.of(context).pushNamed(HomeScreen.HomeScreen.tag);
    // });
  }

  // showDialog(BuildContext context) {
  //   return Dialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(16.0),
  //     ),
  //     elevation: 1.0,
  //     backgroundColor: Colors.transparent,
  //     child: dialogContent(context),
  //   );
  // }

  @override
  void initState() {
    //
    super.initState();
    _getUserInfo();
  }

  _getUserInfo() async {
    SharedPreferences userViewPrefs = await SharedPreferences.getInstance();

    _isSubscribed = userViewPrefs.getBool('user_subscribed');
    // updateView();
  }

  _setUserInfo() async{
    SharedPreferences userViewPrefs = await SharedPreferences.getInstance();
    userViewPrefs.remove('user_subscribed');
    userViewPrefs.setBool('user_subscribed', _isSubscribed);
  }

  @override
  Widget build(BuildContext context) {
    return
//      SafeArea(
//      child:
        Scaffold(
      backgroundColor: const Color(0xff03B898),
      body: DefaultTabController(
        length: 4,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Scaffold(
              bottomNavigationBar:
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 2.0),
              //   child:
                TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      icon: Icon(Icons.arrow_right),
                    ),
                    Tab(
                      icon: Icon(Icons.arrow_right),
                    ),
                  ],
                  labelColor: lightGreen,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: lightGreen, width: 5.0),
                    insets: EdgeInsets.only(bottom: 44.0),
                  ),
                  unselectedLabelColor: darkGreen,
                // ),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  DailyGuideScreen(),
                  UserProfileViewScreen(),
                  BlankScreen(),
                  BlankScreen(),
                ],
              ),
            ),
            Positioned(
              right: 10.0,
              bottom: 4.0,
              child: Container(
                  // color: Colors.transparent,
                alignment: Alignment.center,
                  height: 40.0,
                  width: MediaQuery.of(context).size.width / 2.2, //150.0,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: new FlatButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog();
                        },
                      );
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: new Text(
                        "Go Premium",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

navigateToPremium(context) async{
  //
  String userToken = '';
  String userEmail = '';

  UserCreate _userData;
  UserCreate _user;
  //
  bool _isSubscribed;

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

  SharedPreferences userViewPrefs = await SharedPreferences.getInstance();
  userToken = userViewPrefs.getString('user_token');
  userEmail = userViewPrefs.getString('user_email');
  //
  userViewPrefs.remove('user_subscribed');
  userViewPrefs.setBool('user_subscribed', _isSubscribed);
  String  _petSubscribed = _isSubscribed.toString();

  var userData = {
    'user_email': userEmail,
    'user_token': userToken,
    'user': {
      'subscribed': _petSubscribed,
    }
  };

  final UserCreate user =
  await CallApi().updateTheUser(userData, 'users/update');
  // setState(() {
  //   _user = user;
  // });

  if (user.success) {
    Navigator.of(context)
        .pushReplacement(PageTransition(
      child: ProHomeScreen(),
      type: PageTransitionType.rightToLeft,
    ));

  } else {
    Navigator.of(context).pop();
    buildAlertDialog("An Error Occurred...");
  }

}

class CustomDialog extends StatelessWidget {
  bool _isLoading = false;
  bool _isSubscribed = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 66.0, bottom: 16.0, left: 16.0, right: 16.0),
          margin: EdgeInsets.only(top: 64.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  blurRadius: 10.0,
                  offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   'Subscribe to',
              //   style: TextStyle(
              //     color: Color(0xFF03B898),
              //     fontFamily: 'poppins',
              //     fontWeight: FontWeight.w500,
              //     fontSize: 28.0,
              //   ),
              // ),
//              SizedBox(height: 12.0),
              Text(
                'Premium',
                style: TextStyle(
                  color: Color(0xFF03B898),
                  fontSize: 60.0,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
//              SizedBox(height: 12.0),
              Text(
                'Try Premium for only \$4.49/month for \n 12 months OR \$6.49/month for 3 months.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF03B898),
                  fontSize: 16.0,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                    child: Container(
// //                      width: 150.0,
// //                      color: Colors.white, //Color(0xFF01816B),
// //                    width: MediaQuery.of(context).size.width,
//                       child: new
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
                              color: Color(0xFF01816B),
                            ),
                          ),
                          onPressed: () {
                            _isSubscribed = false;
                            _isLoading ? null : Navigator.of(context).pop();
                          },
                          child: new Text(
                            'Later',
                            style: TextStyle(
                              color: Color(0xFF01816B),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
//                          ),
                          padding: EdgeInsets.all(12),
                        ),
                      ),
                      SizedBox(width: 12.0),
//                    ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                    child: Container(
// //                      width: 150.0,
// //                      color: Color(0xFF01816B),
//                       child: new
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          // minWidth: 120.0,
                          color: Color(0xFF01816B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {
                            _isSubscribed = true;
                            _isLoading
                                ? null
                                : navigateToPremium(context);
                            // _isLoading ? null : _handleSubmit(context);
                          },
                          child: new Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                              // fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
//                        ),
                          padding: EdgeInsets.all(12),
                        ),
                      ),
//                    ),
//                     ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          child: CircleAvatar(
            backgroundColor: Color(0xFF03B898),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Icon(
                CustomIcons.crown_1,
                color: Colors.white,
                size: 84,
              ),
            ),
            radius: 64.0,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/screens/profiles/user/user_registration_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/local/pawfect_shared_prefs.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';

class OnboardingScreen extends StatefulWidget {
  static String tag = 'onboarding-page';

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _finalPage = 3;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF04AA8E),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _navigateToUserRegister() {
    Navigator.of(context).pushReplacement(PageTransition(
      child: LoginScreen(),//UserRegistrationScreen(),
      type: PageTransitionType.rightToLeft,
    ));
//        MaterialPageRoute(builder: (BuildContext context) => UserProfileScreen()));
//    Navigator.push(context,
//        PageTransition(type:
//        PageTransitionType.rightToLeft, child: ScreenTwo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
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
          // child:
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 10.0),
          // child: Padding(
          child: SafeArea(
            minimum: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Expanded(
                //   flex: 10,
                //   child:
                Container(
                  height: 600.0,
                  // alignment: Alignment.centerRight,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      //first screen
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/logo_large.png',
                                  ),
                                  // height: 300.0,
                                  // width: 320.0,
                                ),
                              ),
                            ),
                            // SizedBox(height: 10.0),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '',
                                textAlign: TextAlign.center,
                                style: kTitleStyleWhite,
                              ),
                            ),
                            // SizedBox(height: 10.0),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Keep track of your dog’s calories, macronutrients and micronutrient intake to ensure they are getting the nutrition they need for optimal health and conditioning, day by day, or over time.',
                                style: kSubContentStyleWhiteDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // ),
                          ],
                        ),
                      ),
                      //second screen
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/logo_large.png',
                                  ),
                                  // height: 300.0,
                                  // width: 320.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/premium.png',
                                  ),
                                  height: 50.0,
                                  width: 200.0,
                                ),
                              ),
                            ),
                            // SizedBox(height: 10.0),
//                            Text(
//                              'Go Premium!',
//                              textAlign: TextAlign.center,
//                              style: kTitleStyle,
//                            ),
//                               SizedBox(height: 10.0),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Create your own balanced meal plan or view suggestions based on your pet’s individual nutritional needs and current food intake. Your mind can be at rest knowing that you are providing your dog with everything they need for a longer, healthier life.',
                                style: kSubContentStyleWhiteDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.all(40.0),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Center(
                      //         child: Image(
                      //           image: AssetImage(
                      //             'assets/images/logo_small.png',
                      //           ),
                      //           height: 220.0,
                      //           width: 300.0,
                      //         ),
                      //       ),
                      //       SizedBox(height: 30.0),
                      //       Text(
                      //         'Your Pet!',
                      //         style: kTitleStyle,
                      //         textAlign: TextAlign.center,
                      //       ),
                      //       SizedBox(height: 15.0),
                      //       Text(
                      //         'Maintain a profile of your pet and view a daily food guide that includes a calorie chart, macro-nutrients and micro-nutrients charts to keep your pet healthy.',
                      //         style: kSubtitleStyle,
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ],
                      //   ),
                      // ),
//                         Padding(
//                           padding: EdgeInsets.all(40.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Center(
//                                 child: Image(
//                                   image: AssetImage(
//                                     'assets/images/logo_small.png',
//                                   ),
//                                   height: 220.0,
//                                   width: 300.0,
//                                 ),
//                               ),
//                               Center(
//                                 child: Image(
//                                   image: AssetImage(
//                                     'assets/images/premium.png',
//                                   ),
//                                   height: 100.0,
//                                   width: 200.0,
//                                 ),
//                               ),
//                               SizedBox(height: 10.0),
// //                            Text(
// //                              'Go Premium!',
// //                              textAlign: TextAlign.center,
// //                              style: kTitleStyle,
// //                            ),
//                               SizedBox(height: 10.0),
//                               Text(
//                                 'Create your own feeding plans or view suggestions based on your pets’ profile and current food intake that gives the perfect balance to your loved ones.',
//                                 style: kSubtitleStyle,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
                      //third screen
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/logo_large.png',
                                  ),
                                  // height: 300.0,
                                  // width: 320.0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/premium.png',
                                  ),
                                  height: 100.0,
                                  width: 200.0,
                                ),
                              ),
                            ),
                            // SizedBox(height: 10.0),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Create multiple profiles of your pets with pictures, navigate their profiles to view daily feeding plans to take care of their well-being.',
                                style: kSubContentStyleWhiteDark,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                //
                //
                // Expanded(
                //   flex: 1,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: _buildPageIndicator(),
                //   ),
                // ),
                //
                //
                _currentPage != _numPages - 1
                    ? Expanded(
                        // flex: 1,
                        child: Align(
                          // alignment: FractionalOffset.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    _pageController.jumpToPage(_finalPage);
//                              ,
//                                  duration: Duration(microseconds: 300),
//                                  curve: Curves.easeIn);
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Text(
                                      'SKIP',
                                      style: TextStyle(
                                          color: Color(0xFF03B898),
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24.0),
                                    ),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                        duration: Duration(microseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                  child: Text(
                                    'NEXT',
                                    style: TextStyle(
                                        color: Color(0xFF03B898),
                                        fontFamily: 'poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
          // ),
        ),
      ),
      // ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 64.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  PawfectSharedPrefs.instance
                      .setBooleanValue("isFirstRun", true);

                  Navigator.of(context).pushReplacement(PageTransition(
                    child: UserRegistrationScreen(),
                    type: PageTransitionType.rightToLeft,
                  ));
                }, //print('Get started'),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'LET\'S GET STARTED',
                      style: TextStyle(
                        color: Color(0xFF01816B),
                        fontSize: 24.0,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}

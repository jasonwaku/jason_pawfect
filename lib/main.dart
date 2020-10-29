import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/screens/meal_plan/meal_plan_screen.dart';
import 'package:pawfect/screens/navigation/general_home_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_view_screen.dart';
import 'package:pawfect/utils/local/constants.dart';
import 'utils/local/router.dart' as router;

Widget currentScreen = null;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // currentScreen = MealPlanScreen();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF03B898),
    ));
    return MaterialApp(
      title: 'PawFect',
      onGenerateRoute: router.generateRoute,
      theme: ThemeData(
        //application color theme
        primarySwatch: Colors.green,
        primaryColor:   Color(0xff03b898),
        accentColor:    Color(0xff00c68e),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //application text styles
        fontFamily: 'poppins',
        textTheme: ThemeData.light().textTheme.copyWith(
          // ignore: deprecated_member_use
          title: TextStyle(
            fontFamily: 'poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            // ignore: deprecated_member_use
            title: TextStyle(
              fontFamily: 'poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenRoute,// UserRegistrationScreenRoute, //PetRegistrationScreenRoute,////PremiumHomeScreenRoute,//GeneralHomeScreenRoute,////,////PetProfileViewScreenRoute, //UserProfileViewScreenRoute, ////LoginScreenRoute,////,  //SplashScreenRoute, //PetProfileViewScreenRoute, ////, // //,//, //, //  //, // ,//////,////SplashScreenRoute,//////HomeScreenRoute,//,//SplashScreenRoute,
//        home: SplashScreen()
    );
  }
}

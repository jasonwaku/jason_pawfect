import 'package:flutter/material.dart';
import 'package:pawfect/screens/daily_guide/daily_guide_screen.dart';
import 'package:pawfect/screens/meal_plan/meal_plan_screen.dart';
import 'package:pawfect/screens/navigation/general_home_screen.dart';
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/screens/navigation/premium_home_screen.dart';
import 'package:pawfect/screens/navigation/pro_home_screen.dart';
import 'package:pawfect/screens/onboard/splash_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_add_new_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_view_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_registration_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_view_screen.dart';
import 'package:pawfect/screens/profiles/user/user_registration_screen.dart';
import 'package:pawfect/utils/local/constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // Here we'll handle all the routing
  switch (settings.name) {
    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case HomeScreenRoute:
      return MaterialPageRoute(builder: (context) => GeneralHomeScreen());
    case LoginScreenRoute:
      return MaterialPageRoute(builder: (context) => LoginScreen());
      case UserRegistrationScreenRoute:
      return MaterialPageRoute(builder: (context) => UserRegistrationScreen());
    case UserProfileViewScreenRoute:
      return MaterialPageRoute(builder: (context) => UserProfileViewScreen());
    case PetRegistrationScreenRoute:
      return MaterialPageRoute(builder: (context) => PetRegistrationScreen());
      case PetAddNewScreenRoute:
      return MaterialPageRoute(builder: (context) => PetAddNewScreen());
    case PetProfileViewScreenRoute:
      return MaterialPageRoute(builder: (context) => PetProfileViewScreen());
    case GeneralHomeScreenRoute:
      return MaterialPageRoute(builder: (context) => GeneralHomeScreen());
    case PremiumHomeScreenRoute:
      return MaterialPageRoute(builder: (context) => PremiumHomeScreen());
    case ProHomeScreenRoute:
      return MaterialPageRoute(builder: (context) => ProHomeScreen());
    case DailyGuideScreenRoute:
      return MaterialPageRoute(builder: (context) => DailyGuideScreen());
    case MealPlanScreenRoute:
      return MaterialPageRoute(builder: (context) => MealPlanScreen());
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
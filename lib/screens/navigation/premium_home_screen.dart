import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pawfect/screens/daily_guide/daily_guide_screen.dart';
import 'package:pawfect/screens/main_screen.dart';
import 'package:pawfect/screens/meal_plan/meal_plan_screen.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_view_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_view_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class PremiumHomeScreen extends StatefulWidget {
  const PremiumHomeScreen({Key key}) : super(key: key);
  static String tag = 'premium-home-page';

  @override
  _PremiumHomeScreenState createState() => _PremiumHomeScreenState();
}

class _PremiumHomeScreenState extends State<PremiumHomeScreen>
    with SingleTickerProviderStateMixin {
  static final _myTabbedPageKey = new GlobalKey<_PremiumHomeScreenState>();

  final List<Widget> _children = [
    DailyGuideScreen(),
    UserProfileViewScreen(),
    PetProfileViewScreen(),
    MealPlanScreen(),
  ];
  Color darkGreen = Color(0xFF01816B);
  Color lightGreen = Color(0xFF03B898);

  TabController tabController;

  int currentTab = 0;
  int prevTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   tabController = new TabController(length: _children.length , vsync: this);
  // }
  //
  // @override
  // void dispose() {
  //   tabController.dispose();
  //   super.dispose();
  // }
  // void navigateToUserProfileViewScreen() {
  //   Navigator.of(context).pushReplacement(PageTransition(
  //     child: UserProfileViewScreen(),
  //     type: PageTransitionType.rightToLeftWithFade,
  //   ));
  //   // Timer(Duration(seconds: 3), () {
  //   //  // Navigator.of(context).pushNamed(HomeScreen.HomeScreen.tag);
  //   // });
  // }

  // void navigateToPetProfileViewScreen() {
  //   Navigator.of(context).pushReplacement(PageTransition(
  //     child: PetProfileViewScreen(),
  //     type: PageTransitionType.rightToLeftWithFade,
  //   ));
  //   // Timer(Duration(seconds: 3), () {
  //   //   // Navigator.of(context).pushNamed(HomeScreen.HomeScreen.tag);
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('currentTab: $currentTab');
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
              body: PageStorage(
                child: //currentScreen,
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DailyGuideScreen(),
                    UserProfileViewScreen(),
                    PetProfileViewScreen(),
                    MealPlanScreen(),
                  ],
                ),
                bucket: bucket,
              ),
              bottomNavigationBar: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.home),
                  ),
                  Tab(
                    icon: Icon(Icons.person),
                  ),
                  Tab(
                    icon: Icon(Icons.pets),
                  ),
                  Tab(
                    icon: Icon(Icons.fastfood),
                  ),
                ],
                labelColor: lightGreen,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: lightGreen, width: 5.0),
                  insets: EdgeInsets.only(bottom: 44.0),
                ),
                unselectedLabelColor: darkGreen,
                onTap: _onItemTapped,
                // controller: tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    bool isMealPlanTab = false;
    index != 3 ? isMealPlanTab = false : isMealPlanTab = true;
    setState(() async {
      // _selectedIndex = index;
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('on_mealPlan');
      // //
      // prefs.setBool('on_mealPlan', isMealPlanTab);
      //
      currentTab = index;
      // currentScreen = getWidget(context, index);
      currentScreen =   getWidget(context, index);
        //   TabBarView(
        //   physics: NeverScrollableScrollPhysics(),
        //   children: [
        //     DailyGuideScreen(),
        //     UserProfileViewScreen(),
        //     PetProfileViewScreen(),
        //     MealPlanScreen(),
        //   ],
        // );
      if (prevTab != currentTab) {
        if(index==0){
          DailyGuideScreen map = currentScreen as DailyGuideScreen;
          map.createState().initState();
        }else if(index==1){
          UserProfileViewScreen map = currentScreen as UserProfileViewScreen;
          map.createState().initState();
        }else if(index==2) {
          PetProfileViewScreen map = currentScreen as PetProfileViewScreen;
          map.createState().initState();
        }else if(index == 3){
          MealPlanScreen map = currentScreen as MealPlanScreen;
          map.createState().initState();
      }
      }
      prevTab = currentTab;
    });
  }

  Widget getWidget(BuildContext context, int i) {
    if (i == 3) {
      return MealPlanScreen();
    }else if(i==2){
      return PetProfileViewScreen();
    }else if(i==1){
      return UserProfileViewScreen();
    }else if(i==0){
      return DailyGuideScreen();
    }
  }
}

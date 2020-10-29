import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/screens/daily_guide/daily_guide_screen.dart';
import 'package:pawfect/screens/meal_plan/meal_plan_screen.dart';
import 'package:pawfect/screens/navigation/home_page.dart';
import 'package:pawfect/screens/navigation/navbar_utils.dart';
import 'package:pawfect/screens/profiles/pet/pet_profile_view_screen.dart';
import 'package:pawfect/screens/profiles/user/user_profile_view_screen.dart';

class ProHomeScreen extends StatefulWidget {
  const ProHomeScreen({Key key}) : super(key: key);
  static String tag = 'pro-home-page';

  @override
  _ProHomeScreenState createState() => _ProHomeScreenState();
}

class _ProHomeScreenState extends State<ProHomeScreen>with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<int> _history = [0];
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  TabController _tabController;
  List<Widget> mainTabs;
  List<BuildContext> navStack = [null, null, null, null];
  //
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    mainTabs = <Widget>[
      Navigator(
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) { // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[0] = context;
              return DailyGuideScreen();
            });
          }),
      Navigator(
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {  // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[1] = context;
              return UserProfileViewScreen();
            });
          }),
      Navigator(
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {  // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[2] = context;
              return PetProfileViewScreen();
            });
          }),
      Navigator(
          onGenerateRoute: (RouteSettings settings){
            return PageRouteBuilder(pageBuilder: (context, animiX, animiY) {  // use page PageRouteBuilder instead of 'PageRouteBuilder' to avoid material route animation
              navStack[3] = context;
              return AllMealPlanPage();
            });
          }),
    ];
    super.initState();
  }
  //
  final List<BottomNavigationBarRootItem> bottomNavigationBarRootItems = [
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(''),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.person),
        title: Text(''),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.pets),
        title: Text(''),
      ),
    ),
    BottomNavigationBarRootItem(
      bottomNavigationBarItem: BottomNavigationBarItem(
        icon: Icon(Icons.fastfood),
        title: Text(''),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: mainTabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationBarRootItems.map((e) => e.bottomNavigationBarItem).toList(),
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF03B898),
          unselectedItemColor: Color(0xFF01816B),
          onTap: _onItemTapped,
          // indicator: UnderlineTabIndicator(
          //   borderSide: BorderSide(color: lightGreen, width: 5.0),
          //   insets: EdgeInsets.only(bottom: 44.0),
          // ),
        ),
      ),
      onWillPop: () async{
        if (Navigator.of(navStack[_tabController.index]).canPop()) {
          Navigator.of(navStack[_tabController.index]).pop();
          setState((){ _selectedIndex = _tabController.index; });
          return false;
        }else{
          if(_tabController.index == 0){
            setState((){ _selectedIndex = _tabController.index; });
            SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // close the app
            return true;
          }else{
            _tabController.index = 0; // back to first tap if current tab history stack is empty
            setState((){ _selectedIndex = _tabController.index; });
            return false;
          }
        }
      },
    );
  }

  void _onItemTapped(int index) {
    _tabController.index = index;
    setState(() => _selectedIndex = index);
}
}

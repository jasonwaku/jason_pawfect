import 'package:flutter/material.dart';
import 'package:pawfect/screens/navigation/home_page.dart';
import 'package:pawfect/screens/navigation/home_sub_page.dart';

class BottomNavigationBarRootItem {
  final String routeName;
  final NestedNavigator nestedNavigator;
  final BottomNavigationBarItem bottomNavigationBarItem;

  BottomNavigationBarRootItem({
    @required this.routeName,
    @required this.nestedNavigator,
    @required this.bottomNavigationBarItem,
  });
}

abstract class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  NestedNavigator({Key key, @required this.navigatorKey}) : super(key: key);
}

class HomeNavigator extends NestedNavigator {
  HomeNavigator({Key key, @required GlobalKey<NavigatorState> navigatorKey})
      : super(
    key: key,
    navigatorKey: navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext context) => AllMealPlanPage();
            break;
          case '/home/1':
            builder = (BuildContext context) => MealPlanDetailsScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      },
    );
  }
}
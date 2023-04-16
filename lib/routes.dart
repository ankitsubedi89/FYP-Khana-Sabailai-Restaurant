import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/loc/loc_screen.dart';
import 'package:khana_sabailai_restaurant/screens/auth/login_screen.dart';
import 'package:khana_sabailai_restaurant/screens/home/bottom_tab.dart';
import 'package:khana_sabailai_restaurant/screens/home/category_screen.dart';
import 'package:khana_sabailai_restaurant/screens/home/report_screen.dart';
import 'package:khana_sabailai_restaurant/screens/home/single_food_screen.dart';
import 'package:khana_sabailai_restaurant/splash.dart';

class GetRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String bottomTab = '/bottomTab';
  static const String categoryScreen = '/categoryScreen';
  static const String singleFood = '/singleFood';
  static const String reportScreen = '/report-screen';
  static const String loc_screen = '/loc_screen';

  static List<GetPage> routes = [
    GetPage(
      name: GetRoutes.splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: GetRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: GetRoutes.bottomTab,
      page: () => BottomTab(),
    ),
    GetPage(
      name: GetRoutes.categoryScreen,
      page: () => CategoryScreen(),
    ),
    GetPage(
      name: GetRoutes.singleFood,
      page: () => SingleFoodScreen(),
    ),
    GetPage(
      name: GetRoutes.reportScreen,
      page: () => const ReportScreen(),
    ),
    GetPage(
      name: GetRoutes.loc_screen,
      page: () => const LocScreen(),
    ),
  ];
}

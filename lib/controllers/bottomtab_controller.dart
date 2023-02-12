import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/screens/home/account_screen.dart';
import 'package:khana_sabailai_restaurant/screens/home/home_screen.dart';
import 'package:khana_sabailai_restaurant/screens/home/orders_screen.dart';

class BottomTabController extends GetxController {
  int currentIndex = 0;
  final List children = [
    const HomeScreen(),
    const OrdersScreen(),
    const AccountScreen()
  ];

  void onTabTapped(int index) {
    currentIndex = index;
    update();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}

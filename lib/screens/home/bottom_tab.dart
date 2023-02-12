import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/controllers/bottomtab_controller.dart';
import 'package:khana_sabailai_restaurant/controllers/menu_controller.dart';
import 'package:khana_sabailai_restaurant/controllers/order_controller.dart';
import 'package:khana_sabailai_restaurant/controllers/user_controller.dart';
import 'package:khana_sabailai_restaurant/widgets/icon_with_badge.dart';

class BottomTab extends StatelessWidget {
  BottomTab({Key? key}) : super(key: key);

  final bottomTabController = Get.put(BottomTabController());
  final menuController = Get.put(MenuController());
  final orderController = Get.put(OrderController());
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomTabController>(builder: (controller) {
      return Scaffold(
        body: controller.children[controller.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: controller.onTabTapped,
          currentIndex: controller.currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          selectedLabelStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.house,
                size: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: IconWithBadge(
                icon: FaIcon(
                  FontAwesomeIcons.firstOrder,
                  size: 20,
                ),
              ),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: IconWithBadge(
                icon: FaIcon(
                  FontAwesomeIcons.person,
                  size: 20,
                ),
              ),
              label: 'Account',
            ),
          ],
        ),
      );
    });
  }
}

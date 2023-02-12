import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/controllers/menu_controller.dart';
import 'package:khana_sabailai_restaurant/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<MenuController>(builder: (controller) {
                  return Wrap(
                    children: controller.categories
                        .map((e) => InkWell(
                              onTap: () {
                                Get.toNamed(GetRoutes.categoryScreen,
                                    arguments: [e]);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    right: 10, bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 50),
                                width: MediaQuery.of(context).size.width / 2.3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  e.name!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                })
              ],
            ),
          ),
        ));
  }
}

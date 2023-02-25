import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/controllers/menu_controller.dart';
import 'package:khana_sabailai_restaurant/models/category.dart';
import 'package:khana_sabailai_restaurant/widgets/add_edit_food.dart';
import 'package:khana_sabailai_restaurant/widgets/add_food.dart';
import 'package:khana_sabailai_restaurant/widgets/circular_btn.dart';
import 'package:khana_sabailai_restaurant/widgets/custom_button.dart';
import 'package:khana_sabailai_restaurant/widgets/food_card.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  // final Restaurant restaurant = Get.arguments.restaurant;
  // final Category category = Get.arguments.category;
  final Category category = Get.arguments[0];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(category.name!),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return AddFoodDialog(
                          pickBtn: CustomButton(
                            onPressed: () {
                              controller.pickImage();
                            },
                            label: 'Pick Image',
                          ),
                          button: CustomButton(
                            onPressed: () {
                              controller.addDish(context, category.id);
                            },
                            label: 'Add Dish',
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: controller.getFilteredMenu(category.id).isNotEmpty
                ? GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: controller
                        .getFilteredMenu(category.id)
                        .map((menu) => Stack(
                              children: [
                                FoodCard(
                                  menu: menu,
                                ),
                                Positioned(
                                  left: 5,
                                  top: 5,
                                  child: GetBuilder<MenuController>(
                                    builder: (controller) {
                                      return Row(
                                        children: [
                                          CircularBtn(
                                              onTap: () {
                                                controller.foodNameController
                                                    .text = menu.food!;
                                                controller.foodPriceController
                                                    .text = menu.price!;
                                                controller
                                                    .foodQuantityController
                                                    .text = menu.quantity!;
                                                controller
                                                    .foodDescriptionController
                                                    .text = menu.description!;
                                                controller.imageFile = null;
                                                controller.update();
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) {
                                                      return EditFoodDialog(
                                                        type: 'Edit',
                                                        pickBtn: CustomButton(
                                                          onPressed: () {
                                                            controller
                                                                .pickImage();
                                                          },
                                                          label: 'Pick Image',
                                                        ),
                                                        button: CustomButton(
                                                          onPressed: () {
                                                            controller.editDish(
                                                                context,
                                                                menu.id!);
                                                          },
                                                          label: 'Edit Dish',
                                                        ),
                                                      );
                                                    });
                                              },
                                              icon: Icons.edit),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          CircularBtn(
                                              onTap: () {
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              '${menu.isDeleted == '1' ? 'Restore ' : 'Delete'} Dish'),
                                                          content: Text(
                                                              'Are you sure you want to ${menu.isDeleted == '1' ? 'restore ' : 'delete'} this dish?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  controller.deleteDish(
                                                                      context,
                                                                      menu.id!,
                                                                      menu.isDeleted ==
                                                                              '1'
                                                                          ? true
                                                                          : false);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes')),
                                                          ],
                                                        ));
                                              },
                                              icon: menu.isDeleted == '1'
                                                  ? Icons.restore_from_trash
                                                  : Icons.delete),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  )
                : const Center(
                    child: Text('No menu found'),
                  )),
      );
    });
  }
}

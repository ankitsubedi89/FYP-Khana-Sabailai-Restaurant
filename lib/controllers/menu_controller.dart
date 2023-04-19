import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khana_sabailai_restaurant/models/category.dart';
import 'package:khana_sabailai_restaurant/models/menu.dart';
import 'package:khana_sabailai_restaurant/baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:khana_sabailai_restaurant/models/user.dart';
import 'package:khana_sabailai_restaurant/utils/shared_prefs.dart';
import 'package:khana_sabailai_restaurant/utils/utils.dart';

class MenueController extends GetxController {
  List<Category> categories = [];
  List<Menu> menu = [];

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  TextEditingController foodNameController = TextEditingController();
  TextEditingController foodPriceController = TextEditingController();
  TextEditingController foodDescriptionController = TextEditingController();
  TextEditingController foodQuantityController = TextEditingController();
  TextEditingController foodNameControllerAdd = TextEditingController();
  TextEditingController foodPriceControllerAdd = TextEditingController();
  TextEditingController foodDescriptionControllerAdd = TextEditingController();
  TextEditingController foodQuantityControllerAdd = TextEditingController();

  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllCategories();
    fetchAllMenu();
  }

  pickImage() async {
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    imageFile = file;
    update();
  }

  fetchAllCategories() async {
    var url = Uri.parse('${baseurl}categories/getAllCategories.php');
    var res = await http.get(url);

    var response = await jsonDecode(res.body);

    if (response['success']) {
      categories = AllCategories.fromJson(response).category!;
    }

    update();
  }

  fetchAllMenu() async {
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));

    var url = Uri.parse('${baseurl}menu/getAllMenu.php');
    var res = await http.post(url, body: {
      'restaurant_id': user.userId,
    });

    var response = await jsonDecode(res.body);

    if (response['success']) {
      menu = AllMenus.fromJson(response).menu!;
    }

    update();
  }

  List<Menu> getFilteredMenu(catId) {
    return menu.where((element) => element.categoryId == catId).toList();
  }

  resetFields() {
    foodNameController.clear();
    foodPriceController.clear();
    foodDescriptionController.clear();
    foodQuantityController.clear();
    foodNameControllerAdd.clear();
    foodPriceControllerAdd.clear();
    foodDescriptionControllerAdd.clear();
    foodQuantityControllerAdd.clear();
    imageFile = null;
    update();
  }

  addDish(context, category) async {
    String foodName = foodNameControllerAdd.text;
    String foodPrice = foodPriceControllerAdd.text;
    String foodDescription = foodDescriptionControllerAdd.text;
    String foodQuantity = foodQuantityControllerAdd.text;

    if (foodName.isEmpty) {
      customGetSnackbar('Error', 'Dish name is empty', 'error');
      return;
    }

    if (foodPrice.isEmpty) {
      customGetSnackbar('Error', 'Dish price is empty', 'error');
      return;
    }

    if (foodDescription.isEmpty) {
      customGetSnackbar('Error', 'Dish description is empty', 'error');
      return;
    }

    if (foodQuantity.isEmpty) {
      customGetSnackbar('Error', 'Dish quantity is empty', 'error');
      return;
    }

    if (imageFile == null) {
      customGetSnackbar('Error', 'Dish image is empty', 'error');
      return;
    }

    isLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));

    var url = Uri.parse('${baseurl}menu/addFood.php');
    var request = http.MultipartRequest("POST", url);
    List<int> imageBytes = await imageFile!.readAsBytes();
    String baseimage = base64Encode(imageBytes);
    request.fields['name'] = foodName;
    request.fields['price'] = foodPrice;
    request.fields['description'] = foodDescription;
    request.fields['category'] = category;
    request.fields['image'] = baseimage;
    request.fields['quantity'] = foodQuantity;
    request.fields['restaurant_id'] = user.userId!;

    var response = await request.send();

    var resp = await response.stream.transform(utf8.decoder).join();
    var res = json.decode(resp);
    if (res["success"]) {
      Navigator.of(context).pop();
      resetFields();
      customGetSnackbar('Success', res["message"], 'success');
      fetchAllCategories();
      fetchAllMenu();
    } else {
      customGetSnackbar('Failed', res["message"], 'error');
    }
    isLoading = false;
    update();
  }

  editDish(context, menuId) async {
    String foodName = foodNameController.text;
    String foodPrice = foodPriceController.text;
    String foodDescription = foodDescriptionController.text;
    String foodQuantity = foodQuantityController.text;

    if (foodName.isEmpty) {
      customGetSnackbar('Error', 'Dish name is empty', 'error');
      return;
    }

    if (foodPrice.isEmpty) {
      customGetSnackbar('Error', 'Dish price is empty', 'error');
      return;
    }

    if (foodQuantity.isEmpty) {
      customGetSnackbar('Error', 'Dish quantity is empty', 'error');
      return;
    }

    if (foodDescription.isEmpty) {
      customGetSnackbar('Error', 'Dish description is empty', 'error');
      return;
    }

    isLoading = true;
    update();

    var url = Uri.parse('${baseurl}menu/editFood.php');
    var request = http.MultipartRequest("POST", url);
    request.fields['name'] = foodName;
    request.fields['quantity'] = foodQuantity;
    request.fields['price'] = foodPrice;
    request.fields['description'] = foodDescription;
    request.fields['id'] = menuId;

    if (imageFile != null) {
      List<int> imageBytes = await imageFile!.readAsBytes();
      String baseimage = base64Encode(imageBytes);
      request.fields['image'] = baseimage;
    }

    var response = await request.send();

    var resp = await response.stream.transform(utf8.decoder).join();
    var res = json.decode(resp);
    if (res["success"]) {
      Navigator.of(context).pop();
      resetFields();
      customGetSnackbar('Success', res["message"], 'success');
      fetchAllCategories();
      fetchAllMenu();
    } else {
      customGetSnackbar('Failed', res["message"], 'error');
    }
    isLoading = false;
    update();
  }

  deleteDish(context, id, restore) async {
    isLoading = true;
    update();
    try {
      var url = Uri.parse('${baseurl}menu/deleteFood.php');
      var response =
          await http.post(url, body: {'id': id, 'status': restore ? '0' : '1'});
      var res = await jsonDecode(response.body);

      if (res['success']) {
        Navigator.of(context).pop();
        customGetSnackbar('Success', res['message'], 'success');
        fetchAllCategories();
        fetchAllMenu();
      } else {
        customGetSnackbar('Error', res['message'], 'error');
      }
    } catch (e) {
      customGetSnackbar('Error', 'Something went wrong', 'error');
    }
    isLoading = false;
    update();
  }
}

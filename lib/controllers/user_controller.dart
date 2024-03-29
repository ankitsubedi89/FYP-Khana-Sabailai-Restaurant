import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/baseurl.dart';
import 'package:khana_sabailai_restaurant/models/user.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:khana_sabailai_restaurant/utils/shared_prefs.dart';
import 'package:khana_sabailai_restaurant/utils/utils.dart';

class UserController extends GetxController {
  User user = User.fromJson({
    'user_id': '',
    'name': '',
    'email': '',
    'contact': '',
    'address': '',
    'image': '',
    'lat': '',
    'lon': ''
  });

  File? imageFile;
  File? cvFile;

  late TextEditingController nameController,
      contactController,
      addressController,
      latController,
      lonController,
      oldPasswordController,
      newPasswordController,
      confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    contactController = TextEditingController();
    addressController = TextEditingController();
    latController = TextEditingController();
    lonController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    getUser();
  }

  @override
  void onClose() {
    super.onClose();
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    latController.dispose();
    lonController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  getUser() async {
    var usr = await SharedPrefs().getUser();

    user = User.fromJson(json.decode(usr));
    nameController.text = user.name!;
    contactController.text = user.contact!;
    addressController.text = user.address!;
    latController.text = user.lat!;
    lonController.text = user.lon!;

    update();
  }

  pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      uploadProfilePic();
    }
  }

  uploadProfilePic() async {
    var url =
        Uri.parse('${baseurl}restaurants/edit_restaurant_profile_pic.php');
    var request = http.MultipartRequest("POST", url);
    request.fields["userId"] = user.userId!;
    if (imageFile != null) {
      var pic = await http.MultipartFile.fromPath("image", imageFile!.path);
      //add multipart to request
      request.files.add(pic);
    }
    var response = await request.send();

    var resp = await response.stream.transform(utf8.decoder).join();
    var res = json.decode(resp);
    if (res["success"]) {
      user.image = res["data"];
      await SharedPrefs().storeUser(json.encode(user));
      customGetSnackbar('Success', res["message"][0], 'success');
    } else {
      customGetSnackbar('Failed', res["message"][0], 'error');
    }

    update();
  }

  editUser(context) async {
    if (nameController.text.isEmpty ||
        addressController.text.isEmpty ||
        contactController.text.isEmpty) {
      customGetSnackbar('Error', 'Please fill all the fields', 'error');

      nameController.text = user.name!;
      contactController.text = user.contact!;
      addressController.text = user.address!;
      latController.text = user.lat!;
      lonController.text = user.lon!;
      update();
      return;
    }

    var response = await http
        .post(Uri.parse('${baseurl}restaurants/editprofile.php'), body: {
      'user_id': user.userId!,
      'name': nameController.text,
      'contact': contactController.text,
      'address': addressController.text,
      'lat': latController.text,
      'lon': lonController.text,
    });

    var res = await json.decode(response.body);
    if (res['success']) {
      Navigator.pop(context);
      customGetSnackbar('Success', 'Profile updated successfully', 'success');

      user.name = nameController.text;
      user.contact = contactController.text;
      user.address = addressController.text;
      user.lat = latController.text;
      user.lon = lonController.text;

      await SharedPrefs().storeUser(json.encode(user));
      getUser();
    } else {
      customGetSnackbar('Error', 'Something went wrong', 'error');
    }
  }

  changePassword(context) async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      customGetSnackbar('Error', 'Please fill all the fields', 'error');
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      customGetSnackbar(
          'Error', 'New password and confirm password do not match', 'error');
      return;
    }

    var response =
        await http.post(Uri.parse('${baseurl}users/changePassword.php'), body: {
      'id': user.userId!,
      'old_password': oldPasswordController.text,
      'new_password': newPasswordController.text,
    });

    var res = await json.decode(response.body);
    if (res['success']) {
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Navigator.pop(context);
      customGetSnackbar('Success', 'Password changed successfully', 'success');
    } else {
      customGetSnackbar('Error', res['message'][0], 'error');
    }
  }
}

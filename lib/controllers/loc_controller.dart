import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khana_sabailai_restaurant/baseurl.dart';
import 'package:khana_sabailai_restaurant/models/loc.dart';

class LocController extends GetxController {
  List<Loc> loc = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    fetchAllLOC();
  }

  fetchAllLOC() async {
    var url = Uri.parse('${baseurl}loc/getLoc.php');
    var res = await http.get(url);

    var response = await jsonDecode(res.body);

    if (response['success']) {
      loc = AllLOC.fromJson(response).data!;
    }

    update();
  }
}

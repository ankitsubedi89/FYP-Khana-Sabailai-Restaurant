import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:khana_sabailai_restaurant/baseurl.dart';
import 'package:khana_sabailai_restaurant/models/order.dart';
import 'package:khana_sabailai_restaurant/models/report.dart';
import 'package:khana_sabailai_restaurant/models/user.dart';
import 'package:khana_sabailai_restaurant/utils/shared_prefs.dart';
import 'package:khana_sabailai_restaurant/utils/utils.dart';

class LabelValue {
  String label;
  String value;

  LabelValue(this.label, this.value);
}

class OrderController extends GetxController {
  List<Order> orders = [];
  bool isLoading = false;
  String orderStatus = 'All';

  List<LabelValue> getAllOrderStatus() {
    List<LabelValue> orderStatus = [
      LabelValue('All', 'All'),
      LabelValue('Pending', '0'),
      LabelValue('Preparing', '1'),
      LabelValue('Completed', '2'),
      LabelValue('Cancelled', '3'),
    ];
    return orderStatus;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchOrders();
    fetchReport('All');
  }

  String reportTime = 'All';

  List<LabelValue> reportTimeList = [
    LabelValue('All', 'All'),
    LabelValue('Last 7 days', 'last_7_days'),
    LabelValue('Last 30 days', 'last_30_days'),
    LabelValue('Last 3 months', 'last_90_days'),
    LabelValue('Last 6 months', 'last_180_days'),
    LabelValue('Last 1 year', 'last_365_days'),
  ];

  AllReport? allReport = AllReport();

  fetchReport(String time) async {
    isLoading = true;
    update();

    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));
    // try {
    var url = Uri.parse('${baseurl}orders/report.php');
    var response = await http
        .post(url, body: {'time': time, 'restaurantId': user.userId!});
    var res = await jsonDecode(response.body);
    if (res['success']) {
      allReport = AllReport.fromJson(res);
      print(allReport);
    } else {
      customGetSnackbar('Error', 'Something went wrong', 'error');
    }
    // } catch (e) {
    //   customGetSnackbar('Error', 'Something went wrong', 'error');
    // }
    isLoading = false;
    update();
  }

  fetchOrders() async {
    isLoading = true;
    update();
    var usr = await SharedPrefs().getUser();
    User user = User.fromJson(json.decode(usr));
    var url = Uri.parse('${baseurl}orders/getRestaurantOrders.php');
    var res = await http.post(url, body: {'user_id': user.userId!});

    var response = await jsonDecode(res.body);

    if (response['success']) {
      orders = AllOrders.fromJson(response).order!;
    }
    isLoading = false;
    update();
  }

  changeOrderStatus(status, orderId) async {
    var url = Uri.parse('${baseurl}orders/changeOrderStatus.php');
    var res =
        await http.post(url, body: {'status': status, 'order_id': orderId});

    var response = await jsonDecode(res.body);

    if (response['success']) {
      fetchOrders();

      customGetSnackbar('Success', response['message'], 'success');
    } else {
      customGetSnackbar('Error', response['message'], 'error');
    }
  }

  List<Order> getTodayOrders(bool isToday) {
    if (!isToday) {
      var orders = filteredAllOrders();
      return orders;
    }
    //convert orders date to dart format and compare to see if the order is from today
    return orders.where((element) {
      var date = DateTime.parse(element.date!);
      return date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;
    }).toList();
  }

  List<Order> filteredAllOrders() {
    List<Order> filteredOrders = [];
    if (orderStatus == 'All') {
      filteredOrders = orders;
    } else {
      for (var i = 0; i < orders.length; i++) {
        if (orders[i].status == orderStatus) {
          filteredOrders.add(orders[i]);
        }
      }
    }
    return filteredOrders;
  }
}

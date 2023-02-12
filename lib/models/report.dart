class AllReport {
  String? totalSales;
  String? totalOrders;
  List<Menu>? menu;
  AllReport({this.totalSales, this.totalOrders, this.menu});

  AllReport.fromJson(Map<String, dynamic> json) {
    totalSales = json['total_sales'];
    totalOrders = json['total_orders'];
    if (json['menu'] != null) {
      menu = <Menu>[];
      json['menu'].forEach((v) {
        menu!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_sales'] = totalSales;
    data['total_orders'] = totalOrders;
    if (menu != null) {
      data['menu'] = menu!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Menu {
  String? food;
  String? image;
  String? totalQuantity;
  String? totalSales;
  String? date;

  Menu({this.food, this.image, this.totalQuantity, this.totalSales, this.date});

  Menu.fromJson(Map<String, dynamic> json) {
    food = json['food'];
    image = json['image'];
    totalQuantity = json['total_quantity'];
    totalSales = json['total_sales'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food'] = food;
    data['image'] = image;
    data['total_quantity'] = totalQuantity;
    data['total_sales'] = totalSales;
    data['date'] = date;
    return data;
  }
}

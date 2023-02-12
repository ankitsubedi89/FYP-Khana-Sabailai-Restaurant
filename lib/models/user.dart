class User {
  String? userId;
  String? name;
  String? email;
  String? contact;
  String? address;
  String? image;
  String? lat;
  String? lon;

  User(
      {this.userId,
      this.name,
      this.email,
      this.contact,
      this.address,
      this.image,
      this.lat,
      this.lon});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    address = json['address'];
    image = json['image'];
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['address'] = address;
    data['image'] = image;
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class PersonalInfo {
  String name;
  String image;
  String phone;
  String email;
  int id;

  PersonalInfo({this.name, this.image, this.phone, this.email, this.id});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'] ?? "";
    phone = json['phone'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['id'] = this.id;
    return data;
  }
}

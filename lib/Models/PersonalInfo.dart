class PersonalInfo {
  String name;
  String image;
  String phone;
  String email;
  int id;
  int is_active;

  PersonalInfo({this.name, this.image, this.phone, this.email, this.id,this.is_active});

  PersonalInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'] ?? "";
    phone = json['phone'];
    email = json['email'];
    id = json['id'];
    is_active = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['id'] = this.id;
    data['is_active'] = this.is_active;
    return data;
  }
}

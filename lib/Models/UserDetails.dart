class UserDetails {
  int id;
  String name;
  String email;
  String phone;
  String image;
  String role;
  int status;

  UserDetails(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.image,
        this.role,
        this.status});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'] ?? "";
    role = json['role'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['role'] = this.role;
    data['status'] = this.status;
    return data;
  }
}
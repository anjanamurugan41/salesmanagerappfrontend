import 'Pagination.dart';

class AllSalesPersonResponse {
  String message;
  int status;
  bool success;
  Pagination pagination;
  List<SalesPersonInfo> itemList;

  AllSalesPersonResponse(
      {this.message,
      this.status,
      this.success,
      this.pagination,
      this.itemList});

  AllSalesPersonResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    success = json['success'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      itemList = [];
      json['data'].forEach((v) {
        itemList.add(new SalesPersonInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['success'] = this.success;
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    if (this.itemList != null) {
      data['data'] = this.itemList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class SalesPersonInfo {
  int id;
  String name;
  String email;
  String phone;
  int isActive;
  int createdBy;
  String role;
  Null image;

  SalesPersonInfo(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.isActive,
        this.createdBy,
        this.role,
        this.image});

  SalesPersonInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isActive = json['is_active'];
    createdBy = json['created_by'];
    role = json['role'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['is_active'] = this.isActive;
    data['created_by'] = this.createdBy;
    data['role'] = this.role;
    data['image'] = this.image;
    return data;
  }
}

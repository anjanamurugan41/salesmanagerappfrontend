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
class SalesPersonToPersonModel {
  int status;
  bool success;
  String message;
  List<Data> data;
  Pagination pagination;

  SalesPersonToPersonModel(
      {this.status, this.success, this.message, this.data, this.pagination});

  SalesPersonToPersonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  int createdBy;
  String role;
  String name;
  String email;
  String phone;
  Null emailVerifiedAt;
  String image;
  int isActive;

  Data(
      {this.id,
        this.createdBy,
        this.role,
        this.name,
        this.email,
        this.phone,
        this.emailVerifiedAt,
        this.image,
        this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    return data;
  }
}

class Pagination {
  int page;
  int perPage;
  int totalItem;
  bool hasNextPage;
  int totalPages;

  Pagination(
      {this.page,
        this.perPage,
        this.totalItem,
        this.hasNextPage,
        this.totalPages});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    totalItem = json['totalItem'];
    hasNextPage = json['hasNextPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['totalItem'] = this.totalItem;
    data['hasNextPage'] = this.hasNextPage;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
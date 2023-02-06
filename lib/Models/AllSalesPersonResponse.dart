import 'Pagination.dart';

class AllSalesPersonResponse {
  String message;
  bool success;
  int status;
  List<Data1> data;
  Pagination pagination;

  AllSalesPersonResponse(
      {this.message, this.success, this.status, this.data, this.pagination});

  AllSalesPersonResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data1>();
      json['data'].forEach((v) {
        data.add(new Data1.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Data1 {
  int id;
  String name;
  String email;
  String phone;
  int isActive;
  int createdBy;
  String role;
  String image;

  Data1(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.isActive,
        this.createdBy,
        this.role,
        this.image});

  Data1.fromJson(Map<String, dynamic> json) {
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

class Pagination1 {
  int page;
  int perPage;
  int totalItem;
  bool hasNextPage;
  int totalPages;

  Pagination1(
      {this.page,
        this.perPage,
        this.totalItem,
        this.hasNextPage,
        this.totalPages});

  Pagination1.fromJson(Map<String, dynamic> json) {
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
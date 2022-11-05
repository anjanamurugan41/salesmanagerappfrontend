import 'Pagination.dart';

class NotificationResponse {
  bool _success;
  List<NotificationItems> _items;
  Pagination _pagination;
  String _message;

  NotificationResponse(
      {bool success,
      List<NotificationItems> items,
      Pagination pagination,
      String message}) {
    this._success = success;
    this._items = items;
    this._pagination = pagination;
    this._message = message;
  }

  bool get success => _success;

  set success(bool success) => _success = success;

  List<NotificationItems> get items => _items;

  set items(List<NotificationItems> items) => _items = items;

  Pagination get pagination => _pagination;

  set pagination(Pagination pagination) => _pagination = pagination;

  String get message => _message;

  set message(String message) => _message = message;

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    if (json['items'] != null) {
      _items = new List<NotificationItems>();
      json['items'].forEach((v) {
        _items.add(new NotificationItems.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    if (this._items != null) {
      data['items'] = this._items.map((v) => v.toJson()).toList();
    }
    if (this._pagination != null) {
      data['pagination'] = this._pagination.toJson();
    }
    data['message'] = this._message;
    return data;
  }
}

class NotificationItems {
  String _id;
  String _title;
  String _message;
  String _type;
  String _referenceId;
  String _createdAt;

  NotificationItems(
      {String id,
      String title,
      String message,
      String type,
      String referenceId,
      String createdAt}) {
    this._id = id;
    this._title = title;
    this._message = message;
    this._type = type;
    this._referenceId = referenceId;
    this._createdAt = createdAt;
  }

  String get id => _id;

  set id(String id) => _id = id;

  String get title => _title;

  set title(String title) => _title = title;

  String get message => _message;

  set message(String message) => _message = message;

  String get type => _type;

  set type(String type) => _type = type;

  String get referenceId => _referenceId;

  set referenceId(String referenceId) => _referenceId = referenceId;

  String get createdAt => _createdAt;

  set createdAt(String createdAt) => _createdAt = createdAt;

  NotificationItems.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'] ?? "";
    _message = json['messageText'] ?? "";
    _type = json['type'] ?? "";
    _referenceId = json['referenceId'];
    _createdAt = json['sentAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['message'] = this._message;
    data['type'] = this._type;
    data['referenceId'] = this._referenceId;
    data['sentAt'] = this._createdAt;
    return data;
  }
}

class SearchResponse {
  bool success;
  int status;
  String message;
  List<SearchItem> searchList;

  SearchResponse({this.success, this.status, this.message, this.searchList});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      searchList = [];
      json['data'].forEach((v) {
        searchList.add(new SearchItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.searchList != null) {
      data['data'] = this.searchList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchItem {
  int id;
  String title;
  String type;

  SearchItem({this.id, this.title, this.type});

  SearchItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    return data;
  }
}


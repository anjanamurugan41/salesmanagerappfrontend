class Pagination {
  int page;
  int perPage;
  bool hasNextPage;
  int totalPages;
  int totalItemsCount;
  String task_creater;

  Pagination(
      {this.page,
      this.perPage,
      this.hasNextPage,
      this.totalPages,
      this.totalItemsCount,
      this.task_creater});

  Pagination.fromJson(Map<String, dynamic> json) {
    dynamic pagenumber = json['page'];
    print(pagenumber.runtimeType);
    if (pagenumber is int) {
      page = json['page'];
    } else {
      page = int.parse(json['page']);
    }

    dynamic perPg = json['perPage'];
    print(perPg.runtimeType);
    if (perPg is int) {
      perPage = json['perPage'];
    } else {
      perPage = int.parse(json['perPage']);
    }

    hasNextPage = json['hasNextPage'] ?? false;

    dynamic totItemCount = json['totalItem'];
    print(totItemCount.runtimeType);
    if (totItemCount is int) {
      totalItemsCount = json['totalItem'];
    } else {
      totalItemsCount = int.parse(json['totalItem']);
    }

    dynamic totPgsCount = json['totalPages'];
    print(totPgsCount.runtimeType);
    if (totPgsCount is int) {
      totalPages = json['totalPages'];
    } else {
      totalPages = int.parse(json['totalPages']);
    }
    dynamic taskcreater = json['task_creater'];
    print(taskcreater.runtimeType);
    if (taskcreater is String) {
      task_creater = json['task_creater'];
    } else {
      task_creater = json["task_creater"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['hasNextPage'] = this.hasNextPage;
    data['totalPages'] = this.totalPages;
    data['totalItem'] = this.totalItemsCount;
    data['task_creater'] = this.task_creater;
    return data;
  }
}

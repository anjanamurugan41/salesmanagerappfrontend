import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:sales_manager_app/Models/AllSalesPersonResponse.dart';
import 'package:sales_manager_app/Repositories/TaskRepository.dart';

import '../Constants/CommonMethods.dart';
import '../Interfaces/LoadMoreListener.dart';
import '../ServiceManager/ApiResponse.dart';

class SalesPersonsBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;
  List<SalesPersonInfo> memberItemsList = [];
  StreamController _memberListController;

  StreamSink<ApiResponse<AllSalesPersonResponse>> get _memberListSink =>
      _memberListController.sink;

  Stream<ApiResponse<AllSalesPersonResponse>> get memberListStream =>
      _memberListController.stream;

  LoadMoreListener _listener;

  TaskRepository _taskRepository;

  SalesPersonsBloc(this._listener) {
    _memberListController =
        StreamController<ApiResponse<AllSalesPersonResponse>>();
    _taskRepository = TaskRepository();
  }

  getSalesPersons(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      _memberListSink.add(ApiResponse.loading('Fetching Members'));
    }
    try {
      AllSalesPersonResponse response =
          await _taskRepository.getSalesPersons(pageNumber, perPage);
      if (response.pagination != null) {
        if (response.pagination.hasNextPage != null) {
          hasNextPage = response.pagination.hasNextPage;
        }
        if (response.pagination.page != null) {
          pageNumber = response.pagination.page;
        }
      }
      if (isPagination) {
        if (memberItemsList.length == 0) {
          memberItemsList = response.itemList;
        } else {
          memberItemsList.addAll(response.itemList);
        }
      } else {
        memberItemsList = response.itemList;
      }
      _memberListSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        _memberListSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    _memberListController?.close();
    _memberListSink?.close();
  }


}
class SalesPersonsToPersonBloc {
  bool hasNextPage = false;
  int pageNumber = 0;
  int perPage = 20;
  List<Data> memberItemsList = [];
  StreamController _memberListController;

  StreamSink<ApiResponse<SalesPersonToPersonModel>> get _memberListSink =>
      _memberListController.sink;

  Stream<ApiResponse<SalesPersonToPersonModel>> get memberListStream =>
      _memberListController.stream;

  LoadMoreListener _listener;

  TaskRepository _taskRepository;

  SalesPersonsToPersonBloc(this._listener) {
    _memberListController =
        StreamController<ApiResponse<SalesPersonToPersonModel>>();
    _taskRepository = TaskRepository();
  }

  getSalesPersonstoPersons(bool isPagination) async {
    if (isPagination) {
      _listener.refresh(true);
    } else {
      pageNumber = 0;
      _memberListSink.add(ApiResponse.loading('Fetching Members'));
    }
    try {
      SalesPersonToPersonModel response =
      await _taskRepository.getSalesPersonsToPersons(pageNumber, perPage);
      if (response.pagination != null) {
        if (response.pagination.hasNextPage != null) {
          hasNextPage = response.pagination.hasNextPage;
        }
        if (response.pagination.page != null) {
          pageNumber = response.pagination.page;
        }
      }
      if (isPagination) {
        if (memberItemsList.length == 0) {
          memberItemsList = response.data;
        } else {
          memberItemsList.addAll(response.data);
        }
      } else {
        memberItemsList = response.data;
      }
      _memberListSink.add(ApiResponse.completed(response));
      if (isPagination) {
        _listener.refresh(false);
      }
    } catch (error) {
      if (isPagination) {
        _listener.refresh(false);
      } else {
        _memberListSink
            .add(ApiResponse.error(CommonMethods().getNetworkError(error)));
      }
    }
  }

  dispose() {
    _memberListController?.close();
    _memberListSink?.close();
  }


}

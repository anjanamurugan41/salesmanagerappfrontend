import 'dart:async';

import 'package:sales_manager_app/Models/SearchResponse.dart';
import 'package:sales_manager_app/Repositories/CommonInfoRepository.dart';

import '../Constants/CommonMethods.dart';
import '../ServiceManager/ApiResponse.dart';

class SearchBloc {
  CommonInfoRepository _commonRepository;

  StreamController _searchController;

  StreamSink<ApiResponse<SearchResponse>> get searchSink =>
      _searchController.sink;

  Stream<ApiResponse<SearchResponse>> get searchStream =>
      _searchController.stream;

  SearchBloc() {
    _commonRepository = CommonInfoRepository();
    _searchController = StreamController<ApiResponse<SearchResponse>>();
  }

  getSearchItems(String keyword) async {
    searchSink.add(ApiResponse.loading('Fetching Home info'));

    try {
      SearchResponse searchResponse =
          await _commonRepository.getSearchResults(keyword);
      if (searchResponse.success) {
        searchSink.add(ApiResponse.completed(searchResponse));
      } else {
        searchSink.add(ApiResponse.error("Something went wrong"));
      }
    } catch (error) {
      print("***");
      print(error.toString());
      print("***");
      searchSink.add(ApiResponse.error(CommonMethods().getNetworkError(error)));
    }
  }

  dispose() {
    searchSink?.close();
    _searchController?.close();
  }
}

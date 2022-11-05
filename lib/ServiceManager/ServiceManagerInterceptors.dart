import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/CommonMethods.dart';
import '../Constants/CommonWidgets.dart';
import '../Constants/StringConstants.dart';
import '../Utilities/PreferenceUtils.dart';

class ServiceMangerInterceptors extends Interceptor {
  int maxCharactersPerLine = 500;
  String tokenToSend;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options?.method == "GET") {
      CommonMethods().checkNetworkConnection();
      print("Get method");
    } else {
      print("Post method");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var header = prefs.get(PreferenceUtils.prefAuthToken);
    if (header != null) {
      options.headers.addAll({"Authorization": "Bearer $header"});
    }

    tokenToSend = header;
    print("!!!!!!!!!!!!!! Request Begin !!!!!!!!!!!!!!!!!!!!!");
    print(
        "REQUEST[${options?.method}] => PATH: ${options?.baseUrl}${options?.path}");
    print("Headers:");
    options?.headers?.forEach((k, v) => print('$k: $v'));
    if (options.queryParameters != null) {
      print("QueryParameters:");
      options.queryParameters.forEach((k, v) => print('$k: $v'));
    }
    if (options.data != null) {
      print("Body: ${options.data}");
    }
    print("!!!!!!!!!!!!!!!!!!!! Request End !!!!!!!!!!!!!!!!!!!!!");
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print("************** Response Begin ************************");
    print("ResMethodType : [${response?.requestOptions?.method}]");
    print(
        "RESPONSE[${response?.statusCode}] => PATH: ${response?.requestOptions?.baseUrl}${response?.requestOptions?.path}");
    if (tokenToSend != null && response != null) {
      if (response.statusCode != null) {
        if (response.statusCode == 401) {
          String msg = StringConstants.sessionError;
          CommonWidgets().showCommonDialog(
              msg,
              AssetImage('assets/images/ic_notification_message.png'),
              CommonMethods().alertLoginOkClickFunction(),
              false,
              false);
        }
      }
    }

    String responseAsString = response?.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response?.data);
    }
    print("************** Response End ************************");
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError error, ErrorInterceptorHandler handler) async {
    print("#################### Error Begin #########################");
    print(
        "ERROR[${error?.response?.statusCode}] => PATH: ${error?.requestOptions?.baseUrl}${error?.requestOptions?.path}");
    String errorDescription = CommonMethods().getNetworkError(error);
    print("ERRORDesc [$errorDescription]");
    if (tokenToSend != null && error != null) {
      if (error?.response?.statusCode != null) {
        if (error.response.statusCode == 401) {
          String msg = StringConstants.sessionError;
          CommonWidgets().showCommonDialog(
              msg,
              AssetImage('assets/images/ic_notification_message.png'),
              CommonMethods().alertLoginOkClickFunction(),
              false,
              false);
        }
      }
    }
    print("#################### Error End #########################");
    return super.onError(error, handler);
  }
}

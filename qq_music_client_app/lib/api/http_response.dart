import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qq_music_client_app/api/api_config.dart';

class HttpResponse<T> {
  int code = 200;
  String message = "";
  bool success = true;
  T data;

  HttpResponse({
    required this.data,
    this.code = 200,
    this.message = "",
    this.success = true,
  });

  HttpResponse.fromJson(Map<String, dynamic> json, this.data) {
    code = json['code'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['success'] = success;
    data['data'] = jsonEncode(this.data);
    return data;
  }
}

class HttpService {
  HttpService._privateConstructor();

  static final HttpService instance = HttpService._privateConstructor();

  final _baseUrl = ApiConfig.target;

  final Dio dio = Dio();

  Map<String, dynamic>? serviceHeader() {
    Map<String, dynamic> header = <String, dynamic>{};
    // header["token"] = "";
    return header;
  }

  Map<String, dynamic>? serviceQuery() {
    return null;
  }

  Map<String, dynamic>? serviceBody() {
    return null;
  }

  void initDio() {
    // 请求标头也可以在这里设置
    dio.options.headers = {
      "Access-Control-Allow-Origin": "*",
    };
    dio.options.baseUrl = _baseUrl;

    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 8);
    // dio.options.contentType = "application/json";
    // 这里可以添加其他插件
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Map<String, dynamic> responseFactory(Map<String, dynamic> dataMap) {
    return dataMap;
  }

  String createMessage(List<dynamic> errorVar, String message) {
    String string = message;
    for (var error in errorVar) {
      string = string.replaceFirst("%s", error);
    }
    return string;
  }

  String errorFactory(DioException error) {
    // 请求处理错误
    String? errorMessage = error.message;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "网络链接超时，请检查网路设定";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "网络链接超时，请检查网路设定";
        break;
      case DioExceptionType.badResponse:
        errorMessage = "服务器异常，请稍后重试！";
        break;
      case DioExceptionType.cancel:
        errorMessage = "请求已被取消，请重新请求";
        break;
      default:
        errorMessage = "网络异常，请稍后重试！";
        break;
    }
    return errorMessage;
  }
}

enum RequestMethod { get, post, put, delete, patch, copy }

abstract class BaseApi<T> {
  RequestMethod get method;

  String get path;

  T fromJson(Map<String, dynamic> json);

  Map<String, String>? get header {
    switch (method) {
      case RequestMethod.post:
        return <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        };
      default:
        return null;
    }
  }

  Map<String, dynamic>? get query => null;

  Map<String, dynamic>? get body => null;

  void request({
    required void Function(T response) successCallBack,
    required Function errorCallBack,
  }) async {
    HttpService service = HttpService.instance;
    Dio dio = service.dio;

    Response? response;

    Map<String, String>? h = header;
    Map<String, dynamic>? q = query;
    Map<String, dynamic>? b = body;

    Map<String, dynamic>? queryParams = {};
    var globalQueryParams = service.serviceQuery();
    if (globalQueryParams != null) {
      queryParams.addAll(globalQueryParams);
    }
    if (q != null) {
      queryParams.addAll(q);
    }

    Map<String, dynamic>? headerParams = {};
    var globalHeaderParams = service.serviceHeader();
    if (globalHeaderParams != null) {
      headerParams.addAll(globalHeaderParams);
    }
    if (h != null) {
      headerParams.addAll(h);
    }

    Map<String, dynamic>? bodyParams = {};
    var globalBodyParams = service.serviceBody();
    if (globalBodyParams != null) {
      bodyParams.addAll(globalBodyParams);
    }
    if (b != null) {
      bodyParams.addAll(b);
    }

    String url = path;

    Options options = Options(headers: headerParams);

    try {
      switch (method) {
        case RequestMethod.get:
          response = await dio.get(url,
              queryParameters: queryParams, options: options);
          break;
        case RequestMethod.post:
          response = await dio.post(url, data: bodyParams, options: options);
          break;
        default:
          break;
      }
    } on DioException catch (error) {
      errorCallBack(service.errorFactory(error));
    }
    if (response != null && response.data != null) {
      String dataStr = json.encode(response.data);
      Map<String, dynamic> dataMap = json.decode(dataStr);
      dataMap = service.responseFactory(dataMap);
      successCallBack(fromJson(dataMap));
    }
  }
}


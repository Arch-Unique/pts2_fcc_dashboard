import 'dart:io';
import 'dart:math';

import 'package:dio/io.dart';
import 'package:pts2_fcc/src/global/interfaces/api_service.dart';
import 'package:pts2_fcc/src/global/model/barrel.dart';
import 'package:pts2_fcc/src/global/services/barrel.dart';
import 'package:pts2_fcc/src/src_barrel.dart';
import 'package:pts2_fcc/src/utils/constants/prefs/prefs.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class DioApiService extends GetxService implements ApiService {
  final Dio _dio;
  RequestOptions? _lastRequestOptions;
  CancelToken _cancelToken = CancelToken();
  final prefService = Get.find<MyPrefService>();
  Rx<ErrorTypes> currentErrorType = ErrorTypes.noInternet.obs;

  DioApiService()
      : _dio = Dio(
          BaseOptions(baseUrl: AppUrls.baseURL),
        ) {
          (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
      HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
            _dio.options.connectTimeout = Duration(seconds: 20);
    _dio.interceptors.add(AppDioInterceptor());
  }

  @override
  Future<Response> delete(String url, {data, bool hasToken = true}) async {
    _dio.options.baseUrl = prefService.get(MyPrefs.mpURL) ?? AppUrls.baseURL;
    final response = await _dio.delete(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> get(String url, {data, bool hasToken = true}) async {
    _dio.options.baseUrl = prefService.get(MyPrefs.mpURL) ?? AppUrls.baseURL;
    final response = await _dio.get(url,
        cancelToken: _cancelToken,
        data: data,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> patch(String url, {data, bool hasToken = true}) async {
    _dio.options.baseUrl = prefService.get(MyPrefs.mpURL) ?? AppUrls.baseURL;
    final response = await _dio.patch(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> post(String url, {data, bool hasToken = true}) async {
    _dio.options.baseUrl = prefService.get(MyPrefs.mpURL) ?? AppUrls.baseURL;
    final response = await _dio.post(url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(headers: _getHeader(hasToken)));
    _lastRequestOptions = response.requestOptions;

    return response;
  }

  @override
  Future<Response> retryLastRequest() async {
    if (_lastRequestOptions != null) {
      _dio.options.baseUrl = prefService.get(MyPrefs.mpURL) ?? AppUrls.baseURL;
      final response = await _dio.request(
        _lastRequestOptions!.path,
        data: _lastRequestOptions!.data,
        options: Options(
          method: _lastRequestOptions!.method,
          headers: _lastRequestOptions!.headers,
          // Add any other options if needed
        ),
        cancelToken: _cancelToken,
      );

      return response;
    }
    return Response(
        requestOptions: RequestOptions(),
        statusCode: 404,
        statusMessage: "No Last Request");
  }

  @override
  void cancelLastRequest() {
    _cancelToken.cancel('Request cancelled');
    _cancelToken = CancelToken();
  }

  isSuccess(int? statusCode) {
    return UtilFunctions.isSuccess(statusCode);
  }

  Map<String, dynamic>? _getHeader([bool hasToken = true]) {
    return hasToken
        ? {
            "Authorization":
                generateDigestHeader()
          }
        : {};
  }

  String generateDigestHeader() {
    String username=prefService.get(MyPrefs.mpUserName) ?? "";
    String password=prefService.get(MyPrefs.mpUserPass) ?? "";
    String method = "POST";
    int nonceCount = 1;
    String? cnonce;
    String uri = "/jsonPTS";
    String realm = "Pts2WebServer";
    String nonce = DateFormat("yyMMddhhmmaa").format(DateTime.now());
    String? qop = "auth";
    // Generate cnonce if not provided
    cnonce ??= base64
        .encode(List<int>.generate(16, (_) => Random().nextInt(256)))
        .substring(0, 16)
        .replaceAll('=', '');

    // Format nonce count
    final nc = nonceCount.toRadixString(16).padLeft(8, '0');

    // Calculate HA1 (Hash of username:realm:password)
    final ha1 =
        md5.convert(utf8.encode('$username:$realm:$password')).toString();

    // Calculate HA2 (Hash of method:uri)
    final ha2 = md5.convert(utf8.encode('$method:$uri')).toString();

    // Calculate final response based on qop
    String response;
    if (qop == 'auth' || qop == 'auth-int') {
      response = md5
          .convert(utf8.encode('$ha1:$nonce:$nc:$cnonce:$qop:$ha2'))
          .toString();
    } else {
      response = md5.convert(utf8.encode('$ha1:$nonce:$ha2')).toString();
    }

    // Build the Authorization header
    final headerParts = [
      'Digest username="$username"',
      'realm="$realm"',
      'nonce="$nonce"',
      'uri="$uri"',
      'response="$response"',
    ];

    headerParts.add('qop=$qop');
      headerParts.add('nc=$nc');
      headerParts.add('cnonce="$cnonce"');

    return headerParts.join(', ');
  }


}

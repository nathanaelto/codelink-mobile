import 'dart:convert';
import 'package:codelink_mobile/core/services/http/http_request_builder.dart';
import 'package:codelink_mobile/core/services/http/http_request_method_enum.dart';
import 'package:http/http.dart' as http;

class HttpRequest {

  static Future<Map<String, String>> _defaultHeaders(Map<String, String>? headers) async {
    Map<String, String> defaultHeaders = {
      'Content-Type' : 'application/json'
    };

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  static Future<http.Response> post(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestHeaders = await HttpRequest._defaultHeaders(headers);
    var httpRequestBuilder = HttpRequestBuilder().setUri(url).setHeaders(requestHeaders).setMethod(HttpRequestMethod.post).setBody(body).setEncoding(encoding);
    return httpRequestBuilder.build();
  }

  static Future<http.Response> get(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestHeaders = await HttpRequest._defaultHeaders(headers);
    var httpRequestBuilder = HttpRequestBuilder().setUri(url).setHeaders(requestHeaders).setMethod(HttpRequestMethod.get).setBody(body).setEncoding(encoding);
    return httpRequestBuilder.build();
  }

  static Future<http.Response> put(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestHeaders = await HttpRequest._defaultHeaders(headers);
    var httpRequestBuilder = HttpRequestBuilder().setUri(url).setHeaders(requestHeaders).setMethod(HttpRequestMethod.put).setBody(body).setEncoding(encoding);
    return httpRequestBuilder.build();
  }

  static Future<http.Response> delete(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestHeaders = await HttpRequest._defaultHeaders(headers);
    var httpRequestBuilder = HttpRequestBuilder().setUri(url).setHeaders(requestHeaders).setMethod(HttpRequestMethod.delete).setBody(body).setEncoding(encoding);
    return httpRequestBuilder.build();
  }

  static Future<http.Response> patch(String url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    var requestHeaders = await HttpRequest._defaultHeaders(headers);
    var httpRequestBuilder = HttpRequestBuilder().setUri(url).setHeaders(requestHeaders).setMethod(HttpRequestMethod.patch).setBody(body).setEncoding(encoding);
    return httpRequestBuilder.build();
  }

}
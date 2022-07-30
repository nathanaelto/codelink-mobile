import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'http_request_method_enum.dart';

class HttpRequestBuilder {
  final Map<String, String> _headers = {};

  Uri? _uri;
  HttpRequestMethod? _method;

  Object? _body;
  Encoding? _encoding;

  HttpRequestBuilder setHeaders(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  HttpRequestBuilder setUri(String url) {
    _uri = Uri.parse(url);
    return this;
  }

  HttpRequestBuilder setMethod(HttpRequestMethod method) {
    _method = method;
    return this;
  }

  HttpRequestBuilder setBody(Object? body) {
    _body = body;
    return this;
  }

  HttpRequestBuilder setEncoding(Encoding? encoding) {
    _encoding = encoding;
    return this;
  }

  Map<String, String> getHeaders() {
    return _headers;
  }

  Future<http.Response> build() async {
    if (_uri == null || _method == null) {
      print(toString());
      throw const HttpException('HttpRequestBuilder => _uri or _mthod can\'t be null .');
    }

    switch (_method) {
      case HttpRequestMethod.get:
        return http.get(_uri!, headers: _headers);

      case HttpRequestMethod.post:
        return http.post(_uri!, headers: _headers, body: _body, encoding: _encoding);

      case HttpRequestMethod.put:
        return http.put(_uri!, headers: _headers, body: _body, encoding: _encoding);

      case HttpRequestMethod.delete:
        return http.delete(_uri!, headers: _headers, body: _body, encoding: _encoding);

      case HttpRequestMethod.patch:
        return http.patch(_uri!, headers: _headers, body: _body, encoding: _encoding);

      default:
        throw HttpException('HttpRequestBuilder => vcan\'t manage method : ${_method} .');
    }
  }

  @override
  String toString() {
    return 'HttpRequestBuilder{_headers: $_headers, _uri: $_uri, _method: $_method, _body: $_body, _encoding: $_encoding}';
  }
}
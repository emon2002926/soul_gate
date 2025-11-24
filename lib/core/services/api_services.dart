import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl;
  final http.Client _httpClient;

  ApiServices({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final Map<String, String> _defaultHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  /// GET request
  Future<dynamic> get(String endpoints, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final response = await _httpClient.get(url, headers: mergedHeaders);

    return _handleResponse(response, url);
  }

  /// POST request
  Future<dynamic> post(
      String endpoints, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;
    final response = await _httpClient.post(
      url,
      headers: mergedHeaders,
      body: encodedBody,
    );

    return _handleResponse(response, url);
  }

  /// DELETE request
  Future<dynamic> delete(
      String endpoints, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;
    final response = await _httpClient.delete(
      url,
      headers: mergedHeaders,
      body: encodedBody,
    );

    return _handleResponse(response, url);
  }

  /// PATCH request
  Future<dynamic> patch(
      String endpoints, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;
    final response = await _httpClient.patch(
      url,
      headers: mergedHeaders,
      body: encodedBody,
    );

    return _handleResponse(response, url);
  }

  /// Handle all HTTP responses
  dynamic _handleResponse(http.Response response, Uri url) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw HttpException(
      message: "Request failed",
      statusCode: response.statusCode,
      uri: url,
      body: response.body,
    );
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  final Uri uri;
  final String? body;

  HttpException({
    required this.message,
    required this.statusCode,
    required this.uri,
    this.body,
  });

  @override
  String toString() {
    return "HttpException(status code: $statusCode, uri: $uri, message: $message, body: $body)";
  }
}

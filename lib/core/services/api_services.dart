import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../util/app_log.dart';
import '../widgets/snakbar/custom_snackbar.dart';


class ApiServices {
  final String baseUrl;
  final http.Client _httpClient;

  ApiServices({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final Map<String, String> _defaultHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  List<String> _mimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg': return ['image', 'jpeg'];
      case 'png':  return ['image', 'png'];
      case 'webp': return ['image', 'webp'];
      case 'gif':  return ['image', 'gif'];
      case 'mp4':  return ['video', 'mp4'];
      case 'mpeg': return ['video', 'mpeg'];
      case 'mov':  return ['video', 'quicktime'];
      case 'webm': return ['video', 'webm'];
      default:     return ['application', 'octet-stream'];
    }
  }

  Future<dynamic> get(String endpoints, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'GET');
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.get(url, headers: {..._defaultHeader, ...?headers}),
    );
  }

  Future<dynamic> post(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'POST', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.post(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> delete(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'DELETE', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.delete(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> patch(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PATCH', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.patch(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> put(String endpoints, {Map<String, String>? headers, dynamic body}) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PUT', body: body);
    return _execute(
      endpoints: endpoints,
      request: () => _httpClient.put(
        url,
        headers: {..._defaultHeader, ...?headers},
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  Future<dynamic> postFormData(
      String endpoints, {
        Map<String, String>? headers,
        required Map<String, String> fields,
        File? imageFile,
        String imageFieldName = "image",
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'POST [form-data]', body: fields);
    return _execute(
      endpoints: endpoints,
      request: () async {
        final request = http.MultipartRequest('POST', url);
        request.headers.addAll({'Accept': 'application/json', ...?headers});
        request.fields.addAll(fields);
        if (imageFile != null) {
          final ext = imageFile.path.split('.').last;
          final mime = _mimeType(ext);
          request.files.add(await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: http.MediaType(mime[0], mime[1]),
          ));
        }
        final streamed = await _httpClient.send(request);
        return http.Response.fromStream(streamed);
      },
    );
  }

  Future<dynamic> putFormData(
      String endpoints, {
        Map<String, String>? headers,
        required Map<String, String> fields,
        File? imageFile,
        String imageFieldName = "image",
      }) async {
    final url = Uri.parse('$baseUrl$endpoints');
    AppLog.request(endpoints, method: 'PUT [form-data]', body: fields);
    return _execute(
      endpoints: endpoints,
      request: () async {
        final request = http.MultipartRequest('PUT', url);
        request.headers.addAll({'Accept': 'application/json', ...?headers});
        request.fields.addAll(fields);
        if (imageFile != null) {
          final ext = imageFile.path.split('.').last;
          final mime = _mimeType(ext);
          request.files.add(await http.MultipartFile.fromPath(
            imageFieldName,
            imageFile.path,
            contentType: http.MediaType(mime[0], mime[1]),
          ));
        }
        final streamed = await _httpClient.send(request);
        return http.Response.fromStream(streamed);
      },
    );
  }

  Future<dynamic> _execute({
    required String endpoints,
    required Future<http.Response> Function() request,
  }) async {
    try {
      final response = await request();
      return _handleResponse(response, Uri.parse('$baseUrl$endpoints'), endpoints);
    } on SocketException {
      AppLog.error(endpoints, 'No internet connection');
      CustomSnackBar.error('No internet connection. Please check your network.');
      rethrow;
    } on http.ClientException catch (e) {
      AppLog.error(endpoints, e.message);
      CustomSnackBar.error('Network error. Please try again.');
      rethrow;
    } on TimeoutException {
      AppLog.error(endpoints, 'Request timed out');
      CustomSnackBar.error('Request timed out. Please try again.');
      rethrow;
    }
  }

  dynamic _handleResponse(http.Response response, Uri url, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
      AppLog.response(endpoint, decoded);
      return decoded;
    }

    String errorMessage = 'Something went wrong. Please try again.';
    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['message'] != null) {
          errorMessage = decoded['message'].toString();
        }
      } catch (_) {}
    }

    AppLog.error(endpoint, response.body, statusCode: response.statusCode);
    CustomSnackBar.error(errorMessage);

    throw HttpException(
      message: errorMessage,
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
  String toString() =>
      'HttpException(statusCode: $statusCode, uri: $uri, message: $message, body: $body)';
}
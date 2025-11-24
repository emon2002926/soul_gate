
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constant.dart';
import '../../models/sign_in/sign_in_request_model.dart';
import '../../models/sign_in/sign_in_response_model.dart';

abstract class SignInDataSource {
  Future<LoginResponseModel?> login(LoginRequestModel loginRequest);
}

class LoginDataSourceImpl implements SignInDataSource {
  @override
  Future<LoginResponseModel?> login(LoginRequestModel loginRequest) async {
    final url = Uri.parse('${AppConstant.instance.baseUrl}${AppConstant.instance.loginEndpoint}');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponseModel.fromJson(json.decode(response.body));

        // Store tokens in GetStorage here
        final box = GetStorage();
        box.write('token', loginResponse.access);
        box.write('refresh', loginResponse.refresh);

        return loginResponse;
      } else {
        throw Exception("Failed to sign_in");
      }
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }
}
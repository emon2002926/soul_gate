import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:soul_gate/core/user_profile.dart';
import 'dart:convert';
import 'constants/app_constant.dart';
import 'util/storage_service.dart';


class UserController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final token = StorageService.accessToken;

      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'No access token found');
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConstant.instance.baseUrl}/api/auth/user/details/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        userProfile.value = UserProfile.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', 'Unauthorized: Invalid or expired token');
      } else {
        Get.snackbar('Error', 'Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
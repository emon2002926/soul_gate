class AppConstant {
  AppConstant._privateConstructor();
  static final AppConstant _instance = AppConstant._privateConstructor();
  static AppConstant get instance => _instance;

  // final String appLogo = "assets/logo/app_logo_with_name.png";
  final String font = "Montserrat";
  final String playfair = "PlayfairDisplay";
  final String poppins = "Poppins";
  final String freeTour = "Free Tour";
  final double DEAFULT_CAMERA_ZOOM = 15;

   final String baseUrl = 'https://sofiapi.dsrt321.online';
    String loginEndpoint = '${instance.baseUrl}/api/auth/login/';
  static const String signUpEndpoint = '/api/auth/signup/';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password/';
  static const String verifyCodeEndpoint = '/api/auth/verify_code/';
  static const String resetPasswordEndpoint = '/api/auth/set_new_password/';

}

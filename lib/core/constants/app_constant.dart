class AppConstant {
  AppConstant._privateConstructor();
  static final AppConstant _instance = AppConstant._privateConstructor();
  static AppConstant get instance => _instance;

  // final String appLogo = "assets/logo/app_logo_with_name.png";
  final String font = "Montserrat";
  final String playfair = "PlayfairDisplay";
  final String poppins = "Poppins";
  final String GOOGLE_MAPS_API_KEY = "API_KEY";
  final String scavengerHunt = "A Scavenger Hunt";
  final String freeTour = "Free Tour";
  final double DEAFULT_CAMERA_ZOOM = 15;
  // final String baseUrl = 'http://103.186.20.115:14000';
  // final String baseUrl = 'https://nestocbackend.dsrt321.online';
  final String baseUrl = 'https://nestorcapi.boltscootersllc.com';
  // Endpoints
  final String loginEndpoint = '/api/auth/login/';
  final String singUpEndpoint = '/api/auth/register/';
  final String forgotPasswordEndpoint = '/api/auth/forgot-password/';
  final String verifyCodeEndpoint = '/api/auth/verify_code/';
  final String resetPasswordEndpoint = '/api/auth/set_new_password/';

}

import 'package:get/get.dart';
import '../../features/auth/views/otp_verification_screen.dart';
import '../../features/auth/views/reset_password_screen.dart';
import '../../features/auth/views/sign_up_screen.dart';
import '../../features/auth/views/sing_in_screen.dart';
import '../../features/auth/views/verify_email_screen.dart';
import 'app_routes.dart';

List<GetPage> appRootRoutesFile = <GetPage>[
  /////////////  Authentication
  GetPage(name: AppRoutes.login, page: () =>  SingInScreen(), transition: Transition.rightToLeftWithFade, ),
  GetPage(name: AppRoutes.signUp, page: () => const SignUpScreen(), transition: Transition.rightToLeftWithFade, ),
  GetPage(name: AppRoutes.verifyEmail, page: () =>  EmailVerificationPage(), transition: Transition.rightToLeftWithFade, ),
  GetPage(name: AppRoutes.otpVerifyPage, page: () =>  OtpVerificationScreen(), transition: Transition.rightToLeftWithFade, ),
  GetPage(name: AppRoutes.resetPassword, page: () => const ResetPassScreen(),transition: Transition.rightToLeftWithFade, ),



];
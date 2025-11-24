import '../../models/sign_in/sign_in_request_model.dart';
import '../../models/sign_in/sign_in_response_model.dart';
import 'sign_in_data_source.dart';

class SignInRepository {
  final SignInDataSource dataSource;

  SignInRepository(this.dataSource);

  Future<LoginResponseModel?> login(LoginRequestModel loginRequest) {
    return dataSource.login(loginRequest);
  }
}
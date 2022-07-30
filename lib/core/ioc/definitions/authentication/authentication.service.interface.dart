import 'package:codelink_mobile/core/models/authentication/create_user.dart';
import 'package:codelink_mobile/core/models/authentication/create_user_response.dart';
import 'package:codelink_mobile/core/models/authentication/login.dart';
import 'package:codelink_mobile/core/models/authentication/login_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';

abstract class IAuthenticationService {
  Future<ServiceResponse<CreateUserResponse>> createUser(CreateUser createUser);
  Future<ServiceResponse<LoginResponse>> login(Login login);
}
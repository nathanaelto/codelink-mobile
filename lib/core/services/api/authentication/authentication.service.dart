import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.service.interface.dart';
import 'package:codelink_mobile/core/models/authentication/create_user.dart';
import 'package:codelink_mobile/core/models/authentication/create_user_response.dart';
import 'package:codelink_mobile/core/models/authentication/login.dart';
import 'package:codelink_mobile/core/models/authentication/login_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/http/http_request.dart';
import 'package:http/http.dart';

class AuthenticationService implements IAuthenticationService {
  static String get _apiUrl => EnvironmentService.get(EnvironmentVariable.API_URL);
  static String get _baseEndPoint => _apiUrl + '/users';

  @override
  Future<ServiceResponse<CreateUserResponse>> createUser(CreateUser createUser) async {
    final Response response = await HttpRequest.post(_baseEndPoint, body: createUser.encode());

    switch (response.statusCode) {
      case 201:
        return DecodableTools.decodeFromBodyString<CreateUserResponse>(response.body, CreateUserResponse().decode);
      case 409:
        return ServiceResponse.error('Email already exists');
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<LoginResponse>> login(Login login) async {
    String endPoint = _baseEndPoint + '/login';
    final Response response = await HttpRequest.post(endPoint, body: login.encode());

    switch (response.statusCode) {
      case 201:
        return DecodableTools.decodeFromBodyString<LoginResponse>(response.body, LoginResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

}
import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/get_user_response.dart';
import 'package:codelink_mobile/core/models/user/is_follow_response.dart';
import 'package:codelink_mobile/core/models/utils/codable.dart';
import 'package:codelink_mobile/core/services/api/secure_api_service.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/core/services/http/http_request.dart';
import 'package:http/http.dart';

class UserService extends SecureApiService implements IUserService {

  static String get _apiUrl =>
      EnvironmentService.get(EnvironmentVariable.API_URL);
  static String get _endPoint => _apiUrl + '/users';

  @override
  Future<ServiceResponse<GetUserResponse>> getMe() async {
    Map<String, String> headers = await getHeaders();
    final Response response = await HttpRequest.get(_endPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString(response.body, GetUserResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }

  }

  @override
  Future<ServiceResponse<GetUserResponse>> getUserById(String userId) async {
    Map<String, String> headers = await getHeaders();
    final String getUserByIdEndPoint = _endPoint + "/byId/$userId";
    final Response response = await HttpRequest.get(getUserByIdEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString(response.body, GetUserResponse().decode);
      default:
        return ServiceResponse.error('Une erreur est survenue !');
    }
  }

  @override
  Future<ServiceResponse<IsFollowResponse>> isFollow(String userId) async {
    Map<String, String> headers = await getHeaders();
    final String isFollowEndPoint = _endPoint + "/isFollow/$userId";
    final Response response = await HttpRequest.get(
        isFollowEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return DecodableTools.decodeFromBodyString(
            response.body, IsFollowResponse().decode);
      default:
        return ServiceResponse.error(
            'Une erreur est survenue sur le check follow!');
    }
  }

  @override
  Future<ServiceResponse<bool>> follow(String userId) async {
    Map<String, String> headers = await getHeaders();
    final String followEndPoint = _endPoint + "/follow/$userId";

    final Response response = await HttpRequest.post(followEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return ServiceResponse.success(true);
      default:
        return ServiceResponse.error("Une erreur est survenue !");
    }
  }

  @override
  Future<ServiceResponse<bool>> unfollow(String userId) async {
    Map<String, String> headers = await getHeaders();
    final String followEndPoint = _endPoint + "/follow/$userId";

    final Response response = await HttpRequest.delete(followEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return ServiceResponse.success(true);
      default:
        return ServiceResponse.error("Une erreur est survenue !");
    }
  }

  @override
  Future<ServiceResponse<bool>> logout() async {
    Map<String, String> headers = await getHeaders();
    final String logoutEndPoint = _endPoint + "/logout";

    final Response response = await HttpRequest.put(logoutEndPoint, headers: headers);

    switch (response.statusCode) {
      case 200:
        return ServiceResponse.success(true);
      default:
        return ServiceResponse.error("Une erreur est survenue !");
    }
  }
}
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/secure_api_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';

class SecureApiService implements ISecureApiService {

  final IAuthenticationDao _authenticationDao = getIt.get<IAuthenticationDao>();

  @override
  Future<Map<String, String>> getHeaders() async {
    String? token = await _authenticationDao.getToken();
    if (token != null) {
      return {
        'Authorization': token
      };
    }
    return {
      'Authorization': ''
    };
  }

}